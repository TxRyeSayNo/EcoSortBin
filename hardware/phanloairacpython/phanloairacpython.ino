#include <WiFi.h>
#include <WebServer.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <ESP32Servo.h>

// =========================
// WIFI
// =========================
const char* ssid = "Van Anh T3";
const char* password = "28098884";

// =========================
// SERVER
// =========================
WebServer server(80);

// =========================
// LCD CONFIG
// =========================
LiquidCrystal_I2C lcd(0x27, 16, 2); 

// =========================
// SERVO CONFIG
// =========================
Servo servoGlass;
Servo servoPlastic;
Servo servoPaper;

const int pinGlass = 18;   
const int pinMetal = 19;
const int pinPlastic = 23;

// =========================
// VARIABLES FOR LOGIC (Thêm mới biến kiểm soát thời gian)
// =========================
String lastType = "";
int lastConf = 0;

bool isProcessing = false;       // Biến cờ: true nghĩa là đang xử lý rác (khóa nhận dữ liệu mới)
unsigned long servoOpenTime = 0; // Lưu thời điểm bắt đầu mở servo
const long waitTime = 5000;      // Thời gian mở servo (5000ms = 5 giây)

// =========================
// HIỂN THỊ LCD
// =========================
void showLCD(String type, int conf) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("TRASH CLASSIFY");
  lcd.setCursor(0, 1);
  lcd.print(type);
}

// =========================
// HANDLE HTTP
// =========================
void handleSet() {
  // Nếu hệ thống đang trong 3 giây xử lý rác cũ, từ chối nhận dữ liệu mới để chống trùng
  if (isProcessing) {
    server.send(429, "text/plain", "System Busy - Processing previous trash");
    return;
  }

  if (!server.hasArg("type")) {
    server.send(400, "text/plain", "Missing type");
    return;
  }

  String type = server.arg("type");
  String confStr = server.arg("conf");
  int conf = confStr.toInt();

  lastType = type;
  lastConf = conf;

  Serial.println("===== RECEIVED =====");
  Serial.println(type);
  Serial.println(conf);

  // Hiển thị lên LCD
  showLCD(type, conf);

  // Bật cờ khóa dữ liệu và lưu thời gian bắt đầu kích hoạt servo
  isProcessing = true;
  servoOpenTime = millis(); 

  // Kích hoạt mở đúng servo ngay lập tức
  if (type == "glass") {
    servoGlass.write(180); 
  } 
  else if (type == "metal") {
    servoPlastic.write(180);
  } 
  else if (type == "plastic") {
    servoPaper.write(180);
  }

  // Phản hồi cho phía gửi dữ liệu (Python/App) biết là đã nhận thành công
  server.send(200, "text/plain", "OK");
}

// =========================
// SETUP
// =========================
void setup() {
  Serial.begin(115200);

  Wire.begin(21, 22);

  lcd.init();
  lcd.backlight();
  
  lcd.setCursor(0, 0);
  lcd.print("System Starting.");
  lcd.setCursor(0, 1);
  lcd.print("Connecting Wifi.");

  servoGlass.attach(pinGlass);
  servoPlastic.attach(pinMetal);
  servoPaper.attach(pinPlastic);

  // Đưa tất cả servo về trạng thái đóng ban đầu (90 độ)
  servoGlass.write(0);
  servoPlastic.write(0);
  servoPaper.write(0);

  WiFi.begin(ssid, password);

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnected!");
  Serial.println(WiFi.localIP());

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Connected IP:");
  lcd.setCursor(0, 1);
  lcd.print(WiFi.localIP().toString());

  server.on("/set", handleSet);
  server.begin();
  Serial.println("Server started");
}

// =========================
// LOOP
// =========================
void loop() {
  server.handleClient(); // Duy trì lắng nghe tín hiệu mạng liên tục

  // Nếu hệ thống đang bận xử lý và đã qua thời gian chờ
  if (isProcessing && (millis() - servoOpenTime >= waitTime)) {
    
    // Kiểm tra xem vừa rồi đã mở thùng nào thì CHỈ ĐÓNG TỪ TỪ THÙNG ĐÓ
    if (lastType == "glass") {
      for (int pos = 180; pos >= 0; pos -= 1) {
        servoGlass.write(pos);
        delay(1);
      }
    } 
    else if (lastType == "metal") {
      for (int pos = 180; pos >= 0; pos -= 1) {
        servoPlastic.write(pos); // (Giữ đúng tên biến theo code gốc của bạn)
        delay(1);
      }
    } 
    else if (lastType == "plastic") {
      for (int pos = 180; pos >= 0; pos -= 1) {
        servoPaper.write(pos);   // (Giữ đúng tên biến theo code gốc của bạn)
        delay(1);
      }
    }
    
    // (An toàn kép) Đảm bảo cả 3 thực sự về góc 0 sau vòng lặp
    servoGlass.write(0);
    servoPlastic.write(0);
    servoPaper.write(0);
    
    // Cập nhật lại LCD thông báo sẵn sàng
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("TRASH CLASSIFY");
    lcd.setCursor(0, 1);
    lcd.print("Ready...");

    // Mở khóa cờ xử lý, cho phép nhận dữ liệu mới
    isProcessing = false; 
    Serial.println("===== READY FOR NEXT TRASH =====");
  }
}