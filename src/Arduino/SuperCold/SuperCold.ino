#include <WiFi.h>
#include <esp_now.h>

#define BUTTON_PIN 21

int xyzPins[] = {36, 37, 38};   // y, x, z(switch) pins first one
int xyzPins2[] = {39, 32, 33}; // y, x, z (switch) pins second one

unsigned long previousMillis = 0;
const long interval = 66;

void setup() {
  Serial.begin(9600);
  pinMode(BUTTON_PIN, INPUT_PULLUP); // for button
  espnowSetup();
}

void formatMacAddress(const uint8_t *macAddr, char *buffer, int maxLength)
// Formats MAC Address
{
  snprintf(buffer, maxLength, "%02x:%02x:%02x:%02x:%02x:%02x", macAddr[0], macAddr[1], macAddr[2], macAddr[3], macAddr[4], macAddr[5]);
}

void receiveCallback(const esp_now_recv_info_t *macAddr, const uint8_t *data, int dataLen)
/* Called when data is received
   You can receive 3 types of messages
   1) a "POSITION" message, which indicates the opponent's position (x, y), velocity (x, y), and camera angle.
   2) a "FIRE" message, which indicates the opponent has fired their gun (and whether they hit)
   3) a "SETUP" message, which is sent once at startup and sends the map information and the joiner's position.
   4) a "SETUP COMPLETE", which is sent once when the joiner completes their setup.
   
   Messages are formatted as follows:
   [P/F/S/C]: message
   For example, an POSITION message for "x: 15, y: 15, velocityX: 13, velocityY: 13, angle: 90":
   P: 15,15,13,13,90
   For example, a FIRE message with success false:
   F: false
*/

{
  // Only allow a maximum of 250 characters in the message + a null terminating byte
  char buffer[ESP_NOW_MAX_DATA_LEN + 1];
  int msgLen = min(ESP_NOW_MAX_DATA_LEN, dataLen);
  strncpy(buffer, (const char *)data, msgLen);

  // Make sure we are null terminated
  buffer[msgLen] = 0;
  String recvd = String(buffer);
  // Format the MAC address
  char macStr[18];
  // formatMacAddress(macAddr, macStr, 18);

  // Send message to the serial port
  Serial.println(recvd);
}

void sentCallback(const uint8_t *macAddr, esp_now_send_status_t status)
// Called when data is sent
{
  char macStr[18];
  formatMacAddress(macAddr, macStr, 18);
}

void broadcast(const String &message)
// Emulates a broadcast
{
  // Broadcast a message to every device in range
  uint8_t broadcastAddress[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
  esp_now_peer_info_t peerInfo = {};
  memcpy(&peerInfo.peer_addr, broadcastAddress, 6);
  if (!esp_now_is_peer_exist(broadcastAddress)) {
    esp_now_add_peer(&peerInfo);
  }
  // Send message
  esp_err_t result = esp_now_send(broadcastAddress, (const uint8_t *)message.c_str(), message.length());
}

void espnowSetup() {
  // Set ESP32 in STA mode to begin with
  delay(500);
  WiFi.mode(WIFI_STA);

  // Disconnect from WiFi
  WiFi.disconnect();

  // Initialize ESP-NOW
  if (esp_now_init() == ESP_OK) {
    esp_now_register_recv_cb(receiveCallback);
    esp_now_register_send_cb(sentCallback);
  } else {
    delay(3000);
    ESP.restart();
  }
}


void loop() {
  unsigned long currentMillis = millis();

  if(Serial.available() > 0) {
    while(Serial.available() > 0) {
      String message = Serial.readStringUntil('\n');
      broadcast(message);
    }
  }
  
  // send data 30 times per sec
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    int buttonState = digitalRead(BUTTON_PIN);
    int yVal = analogRead(xyzPins[0]);
    int xVal = analogRead(xyzPins[1]);
    int yVal2 = analogRead(xyzPins2[0]);
    int xVal2 = analogRead(xyzPins2[1]);

    String data = "C: " + String(yVal) + "," + String(xVal) + "," +
                  String(yVal2) + "," + String(xVal2) + "," + String(buttonState);

    Serial.println(data);
  }
}
