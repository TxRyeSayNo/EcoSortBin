#include "esp_camera.h"
#include <WiFi.h>

//
// WARNING!!! PSRAM IC required for UXGA resolution and high JPEG quality
//            Ensure ESP32 Wrover Module or other board with PSRAM is selected
//            Partial images will be transmitted if image exceeds buffer size
//
//            You must select partition scheme from the board menu that has at least 3MB APP space.
//            Face Recognition is DISABLED for ESP32 and ESP32-S2, because it takes up from 15 
//            seconds to process single frame. Face Detection is ENABLED if PSRAM is enabled as well

// ===================
// Select camera model
// ===================
//#define CAMERA_MODEL_WROVER_KIT // Has PSRAM
//#define CAMERA_MODEL_ESP_EYE // Has PSRAM
#define CAMERA_MODEL_ESP32S3_EYE // Has PSRAM
//#define CAMERA_MODEL_M5STACK_PSRAM // Has PSRAM
//#define CAMERA_MODEL_M5STACK_V2_PSRAM // M5Camera version B Has PSRAM
//#define CAMERA_MODEL_M5STACK_WIDE // Has PSRAM
//#define CAMERA_MODEL_M5STACK_ESP32CAM // No PSRAM
//#define CAMERA_MODEL_M5STACK_UNITCAM // No PSRAM
//#define CAMERA_MODEL_AI_THINKER // Has PSRAM
//#define CAMERA_MODEL_TTGO_T_JOURNAL // No PSRAM
//#define CAMERA_MODEL_XIAO_ESP32S3 // Has PSRAM
// ** Espressif Internal Boards **
//#define CAMERA_MODEL_ESP32_CAM_BOARD
//#define CAMERA_MODEL_ESP32S2_CAM_BOARD
//#define CAMERA_MODEL_ESP32S3_CAM_LCD
//#define CAMERA_MODEL_DFRobot_FireBeetle2_ESP32S3 // Has PSRAM
//#define CAMERA_MODEL_DFRobot_Romeo_ESP32S3 // Has PSRAM
#include "camera_pins.h"

// ===========================
// Enter your WiFi credentials
// ===========================
const char* ssid = "Van Anh T3";
const char* password = "28098884";

void startCameraServer();
void setupLedFlash(int pin);

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  Serial.println();

  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  
  // BOOST 1: Tăng tốc độ xung nhịp XCLK lên 24MHz (hoặc 20MHz nếu bị nhiễu sọc) giúp tăng FPS tối đa
  config.xclk_freq_hz = 20000000; 
  config.pixel_format = PIXFORMAT_JPEG; 
  
  // BOOST 2: Mặc định khởi động ở độ phân giải vừa phải (VGA) để cân bằng mượt mà và nét.
  // Bạn có thể chỉnh thành FRAMESIZE_QVGA (320x240) nếu muốn siêu mượt (FPS cao nhất).
  config.frame_size = FRAMESIZE_VGA; 
  
  // BOOST 3: Tối ưu hóa bộ đệm Frame Buffer cho PSRAM
  config.fb_location = CAMERA_FB_IN_PSRAM;
  config.jpeg_quality = 12; // Chất lượng ảnh tốt (giá trị càng thấp ảnh càng nét nhưng nặng)
  config.fb_count = 2;       // Tăng lên 2 frame buffers để tạo cơ chế "Gối đầu" (Double Buffering) giúp stream mượt, không giật
  config.grab_mode = CAMERA_GRAB_LATEST; // Luôn lấy khung hình mới nhất, giảm tối đa độ trễ (delay) hình ảnh

  // Kiểm tra và tự động ép cấu hình cao nhất nếu phát hiện có PSRAM
  if(config.pixel_format == PIXFORMAT_JPEG){
    if(psramFound()){
      config.jpeg_quality = 12; // Giữ ở mức 12-14 để giữ tốc độ truyền tải WiFi cực nhanh
      config.fb_count = 2;
      config.grab_mode = CAMERA_GRAB_LATEST;
    } else {
      config.frame_size = FRAMESIZE_SVGA;
      config.fb_location = CAMERA_FB_IN_DRAM;
    }
  } else {
    config.frame_size = FRAMESIZE_240X240;
#if CONFIG_IDF_TARGET_ESP32S3
    config.fb_count = 2;
#endif
  }

#if defined(CAMERA_MODEL_ESP_EYE)
  pinMode(13, INPUT_PULLUP);
  pinMode(14, INPUT_PULLUP);
#endif

  // camera init
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }

  sensor_t * s = esp_camera_sensor_get();
  
  // BOOST 4: Cấu hình thanh ghi chuyên biệt cho cảm biến OV3660 để tối ưu xử lý ảnh
  if (s->id.PID == OV3660_PID) {
    s->set_vflip(s, 1);       // Lật lại ảnh bị ngược mặc định của OV3660
    s->set_brightness(s, 1);   // Tăng độ sáng nhẹ
    s->set_saturation(s, -1);  // Giảm bão hòa màu một chút để ảnh đỡ bết góc tối
    
    // Khởi động mượt mà ở độ phân giải chỉ định
    s->set_framesize(s, config.frame_size);
  }

#if defined(CAMERA_MODEL_M5STACK_WIDE) || defined(CAMERA_MODEL_M5STACK_ESP32CAM)
  s->set_vflip(s, 1);
  s->set_hmirror(s, 1);
#endif

#if defined(CAMERA_MODEL_ESP32S3_EYE)
  s->set_vflip(s, 1);
#endif

// Setup LED FLash if LED pin is defined in camera_pins.h
#if defined(LED_GPIO_NUM)
  setupLedFlash(LED_GPIO_NUM);
#endif

  // BOOST 5: Tối ưu kết nối WiFi tránh rơi vào trạng thái ngủ (Power Save Mode) gây trễ stream
  WiFi.begin(ssid, password);
  WiFi.setSleep(false); 

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  startCameraServer();

  Serial.println("\n=================================================");
  Serial.println("           CAMERA READY & CONNECTED!             ");
  Serial.println("=================================================");
  
  // 1. Link bảng điều khiển (Web Control Panel)
  Serial.print("1. Web UI Control : http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");

  // 2. Link Stream video trực tiếp (Direct MJPEG Stream)
  // Trong đa số thư viện ESP32 (app_httpd.cpp), luồng stream chạy trên cổng 81
  Serial.print("2. Direct Stream  : http://");
  Serial.print(WiFi.localIP());
  Serial.println(":81/stream");

  // (Dự phòng) Một số phiên bản thư viện dùng chung cổng 80 cho stream
  Serial.print("3. Stream (Alt)   : http://");
  Serial.print(WiFi.localIP());
  Serial.println("/stream");
  
  Serial.println("=================================================\n");
}

void loop() {
  // Do nothing. Everything is done in another task by the web server
  delay(10000);
}