/* 
  LILYGO Joystick Example
  Joystick X, Y, and SW are connected to pins 39, 32, and 33
  Joystick 2 X, Y, and SW are connected to pins 12, 13, and 15
  Button is connected to 21
  Prints out X, Y, Z values to Serial
*/

#define BUTTON_PIN 21

int xyzPins[] = {39, 32, 33};   // x, y, z(switch) pins first one
int xyzPins2[] = {12, 13, 15}; // x, y, z (switch) pins second one
void setup() {
  Serial.begin(9600);
  pinMode(xyzPins[2], INPUT_PULLUP);  // pullup resistor for switch
  pinMode(xyzPins2[2], INPUT_PULLUP);  // pullup resistor for switch
  pinMode(BUTTON_PIN, INPUT_PULLUP); // for button
}
void loop() {
  int buttonState = digitalRead(BUTTON_PIN);
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int xVal2 = analogRead(xyzPins2[0]);
  int yVal2 = analogRead(xyzPins2[1]);
  int zVal2 = digitalRead(xyzPins2[2]);
  Serial.printf("%d,%d,%d", xVal, yVal, zVal);
  Serial.printf("|");
  Serial.printf("%d,%d,%d", xVal2, yVal2, zVal2);
  Serial.printf("|");
  Serial.println(buttonState); // check if button is pressed
  Serial.println();
  delay(100);
}