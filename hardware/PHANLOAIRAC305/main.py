import cv2
import numpy as np
import requests
import time
import threading
import tensorflow as tf

# =========================
# THÔNG SỐ
# =========================
ESP32_CAM_IP = "192.168.100.116"
ESP32_DEV_IP = "192.168.100.6"
JAVA_BACKEND_URL = "http://localhost:8080/EcoSortBin/api/event"
STREAM_URL = f"http://{ESP32_CAM_IP}:81/stream"

model_path = "trash_model.tflite" 

CLASS_NAMES = ["glass", "metal", "plastic"]
IMG_SIZE = 224

CONF_THRESHOLD = {
    "glass": 87,
    "metal": 45,
    "plastic": 95
}

SEND_INTERVAL = 2

# =========================
# 1. LUỒNG ĐỌC CAMERA NGẦM (CHỐNG TRỄ ẢNH)
# =========================
class CameraStream:
    def __init__(self, url):
        # Giảm kích thước bộ đệm của OpenCV xuống tối thiểu để không bị delay hình
        self.cap = cv2.VideoCapture(url, cv2.CAP_FFMPEG)
        self.cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
        
        self.ret, self.frame = self.cap.read()
        self.running = True
        self.lock = threading.Lock()
        self.thread = threading.Thread(target=self.update, args=(), daemon=True)
        self.thread.start()

    def update(self):
        while self.running:
            ret, frame = self.cap.read()
            if ret:
                with self.lock:
                    self.frame = frame
            # Thêm khoảng nghỉ cực nhỏ ( ~60 FPS) để không làm treo CPU và tràn mạng WiFi
            time.sleep(0.015)

    def read(self):
        with self.lock:
            return self.frame.copy() if self.frame is not None else None

    def stop(self):
        self.running = False
        self.thread.join(timeout=1.0)
        self.cap.release()

# =========================
# 2. GỬI HTTP NGẦM (ASYNC)
# =========================
def send_to_esp32dev_async(label, confidence):
    def _send():
        try:
            url = f"http://{ESP32_DEV_IP}/set"
            params = {"type": label, "conf": str(int(confidence))}
            requests.get(url, params=params, timeout=0.5) # Giảm timeout xuống 0.5s
            print(f"[ASYNC] Sent -> {label} ({confidence:.1f}%)")
        except Exception as e:
            # Chỉ in lỗi nhẹ, tránh làm spam terminal
            pass
            
    threading.Thread(target=_send, daemon=True).start()

def send_to_java_backend_async(label, confidence):
    def _send():
        try:
            # Gửi dạng form-data để Java dễ lấy qua request.getParameter()
            payload = {
                "wasteType": label.upper(),
                "confidence": str(round(float(confidence), 2)),
                "deviceId": "SMART_BIN_001"
            }
            requests.post(JAVA_BACKEND_URL, data=payload, timeout=1.0)
        except Exception:
            pass
    threading.Thread(target=_send, daemon=True).start()

# =========================
# KHỞI TẠO TFLITE INTERPRETER
# =========================
print("Loading TFLite model...")
interpreter = tf.lite.Interpreter(model_path=model_path, num_threads=4)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("TFLite Model loaded successfully!")

print(f"Connecting to stream: {STREAM_URL}...")
cam = CameraStream(STREAM_URL)
time.sleep(1.5) # Đợi camera ổn định stream

last_sent_time = 0
last_label = None
frame_count = 0

final_label = "unknown"
final_conf = 0.0
prev_gray = None

# =========================
# LOOP CHÍNH
# =========================
try:
    while True:
        frame = cam.read()
        if frame is None:
            time.sleep(0.01)
            continue

        frame_count += 1
        
        # --- BƯỚC TỐI ƯU 1: Thu nhỏ ảnh để phát hiện chuyển động siêu nhanh ---
        small_frame = cv2.resize(frame, (320, 240))
        gray = cv2.cvtColor(small_frame, cv2.COLOR_BGR2GRAY)
        gray = cv2.GaussianBlur(gray, (21, 21), 0)

        if prev_gray is None:
            prev_gray = gray
            continue

        frame_delta = cv2.absdiff(prev_gray, gray)
        thresh = cv2.threshold(frame_delta, 25, 255, cv2.THRESH_BINARY)[1]
        motion_level = np.sum(thresh)

        prev_gray = gray

        # --- BƯỚC TỐI ƯU 2: Nhận diện AI (Chỉ chạy khi có chuyển động) ---
        # Do ảnh đã thu nhỏ (320x240) nên ngưỡng motion_level giảm xuống ~10000 là vừa đẹp
        if motion_level >= 10000 and (frame_count % 3 == 0):
            img = cv2.resize(frame, (IMG_SIZE, IMG_SIZE))
            img = img.astype(np.float32) / 255.0
            img = np.expand_dims(img, axis=0)

            # GỌI AI
            interpreter.set_tensor(input_details[0]['index'], img)
            interpreter.invoke()
            pred = interpreter.get_tensor(output_details[0]['index'])[0]

            class_id = np.argmax(pred)
            confidence = np.max(pred) * 100
            label = CLASS_NAMES[class_id]

            if label in CONF_THRESHOLD and confidence >= CONF_THRESHOLD[label]:
                final_label = label
                final_conf = confidence
            else:
                final_label = "unknown"
                final_conf = confidence

            # GỬI DỮ LIỆU HTTP
            current_time = time.time()
            if (final_label != last_label) or (current_time - last_sent_time > SEND_INTERVAL):
                send_to_esp32dev_async(final_label, final_conf)
                # CHỈ gửi lên Web/Database nếu phát hiện được rác (không gửi unknown)
                if final_label != "unknown":
                    send_to_java_backend_async(final_label, final_conf)
                
                last_label = final_label
                last_sent_time = current_time

        # --- HIỂN THỊ ---
        color = (0, 255, 0) if final_label != "unknown" else (0, 0, 255)
        text = f"{final_label} : {final_conf:.1f}%"
        
        # Hiển thị thêm trạng thái Motion để bạn dễ căn chỉnh độ nhạy
        motion_text = f"Motion: {motion_level}"

        cv2.putText(frame, text, (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)
        cv2.putText(frame, motion_text, (20, 80), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 0), 1)

        cv2.imshow("Trash Classification (TFLite Optimized)", frame)

        if cv2.waitKey(1) == 27: # ESC để thoát
            break

finally:
    print("Stopping...")
    cam.stop()
    cv2.destroyAllWindows()
    print("Done!")