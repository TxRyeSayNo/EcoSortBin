import tensorflow as tf

# 1. Tải mô hình Keras gốc
print("Đang tải mô hình Keras...")
model = tf.keras.models.load_model("trash_model.keras")

# 2. Khởi tạo bộ chuyển đổi TFLite Converter
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# TỐI ƯU HÓA (Tùy chọn cực kỳ đáng giá):
# Bật tính năng tối ưu hóa mặc định (giảm dung lượng model xuống 4 lần, chạy nhanh hơn)
converter.optimizations = [tf.lite.Optimize.DEFAULT]

# 3. Tiến hành chuyển đổi
print("Đang chuyển đổi sang TFLite...")
tflite_model = converter.convert()

# 4. Lưu ra file .tflite
tflite_file = "trash_model.tflite"
with open(tflite_file, "wb") as f:
    f.write(tflite_model)

print(f"Thành công! Mô hình đã được lưu tại: {tflite_file}")