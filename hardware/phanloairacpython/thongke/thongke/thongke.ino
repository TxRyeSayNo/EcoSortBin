#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>

//==================== WIFI ====================
const char* ssid = "Van Anh T3";
const char* password ="28098884";

// URL WEB APP GOOGLE SHEETS (/exec)
String scriptURL =
"https://script.google.com/macros/s/AKfycbzVzufy2j_oPOfqRysyKIiYYzgdbg3rnKRGYwOq8I-YNTAR7vDLIFhzShiX8Qr5ebfm/exec";

//==================== HC-SR04 ====================

// GLASS
#define TRIG1 13
#define ECHO1 12

// METAL
#define TRIG2 14
#define ECHO2 27

// PLASTIC
#define TRIG3 26
#define ECHO3 25

//==================== CHIỀU CAO THÙNG ====================

#define GLASS_HEIGHT   20.0
#define METAL_HEIGHT   20.0
#define PLASTIC_HEIGHT 20.0

//=========================================================

float readDistance(int trigPin, int echoPin)
{
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);

  if(duration == 0)
  {
    return -1;
  }

  float distance = duration * 0.0343 / 2.0;

  return distance;
}

int calculatePercent(float distance, float binHeight)
{
  if(distance < 0)
    return 0;

  int percent =
    (binHeight - distance) * 100.0 / binHeight;

  percent = constrain(percent, 0, 100);
  return percent;
}

//=========================================================

void connectWiFi()
{
  WiFi.begin(ssid, password);

  Serial.print("Connecting WiFi");

  while(WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("WiFi Connected");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
}

//=========================================================

void sendToGoogleSheet(
  int glass,
  int metal,
  int plastic)
{
  if(WiFi.status() != WL_CONNECTED)
  {
    Serial.println("WiFi Lost!");
    connectWiFi();
    return;
  }

  String url =
    scriptURL +
    "?glass=" + String(glass) +
    "&metal=" + String(metal) +
    "&plastic=" + String(plastic);

  Serial.println(url);

  WiFiClientSecure client;
  client.setInsecure();

  HTTPClient http;

  http.setFollowRedirects(
      HTTPC_STRICT_FOLLOW_REDIRECTS);

  if(http.begin(client, url))
  {
    int httpCode = http.GET();

    Serial.print("HTTP Code: ");
    Serial.println(httpCode);

    if(httpCode > 0)
    {
      String payload =
        http.getString();

      Serial.print("Response: ");
      Serial.println(payload);
    }
    else
    {
      Serial.print("Error: ");
      Serial.println(
        http.errorToString(httpCode));
    }

    http.end();
  }
  else
  {
    Serial.println(
      "Cannot connect Google Script");
  }
}

//=========================================================

void setup()
{
  Serial.begin(115200);

  pinMode(TRIG1, OUTPUT);
  pinMode(ECHO1, INPUT);

  pinMode(TRIG2, OUTPUT);
  pinMode(ECHO2, INPUT);

  pinMode(TRIG3, OUTPUT);
  pinMode(ECHO3, INPUT);

  connectWiFi();
}

//=========================================================

void loop()
{
  float glassDistance =
    readDistance(TRIG1, ECHO1);

  delay(60);

  float metalDistance =
    readDistance(TRIG2, ECHO2);

  delay(60);

  float plasticDistance =
    readDistance(TRIG3, ECHO3);

  int glassPercent =
    calculatePercent(
      glassDistance,
      GLASS_HEIGHT);

  int metalPercent =
    calculatePercent(
      metalDistance,
      METAL_HEIGHT);

  int plasticPercent =
    calculatePercent(
      plasticDistance,
      PLASTIC_HEIGHT);

  Serial.println("========== BIN STATUS ==========");

  Serial.print("Glass Distance: ");
  Serial.print(glassDistance);
  Serial.print(" cm | ");
  Serial.print(glassPercent);
  Serial.println("%");

  Serial.print("Metal Distance: ");
  Serial.print(metalDistance);
  Serial.print(" cm | ");
  Serial.print(metalPercent);
  Serial.println("%");

  Serial.print("Plastic Distance: ");
  Serial.print(plasticDistance);
  Serial.print(" cm | ");
  Serial.print(plasticPercent);
  Serial.println("%");

  sendToGoogleSheet(
    glassPercent,
    metalPercent,
    plasticPercent);

  Serial.println("Waiting 30s...");
  Serial.println();

  delay(30000);
}