# :gun: SuperCold

# About

SuperCold is a 1 vs.1 first person shooter game, designed to work in Processing with an 
LILYGO TTGO ESP32 board, two joysticks, and a button. This was designed for COMS3930 Creative Embedded Systems,
a class at Barnard College/Columbia University.

# Hardware Setup

Components required per player:
1. Two joysticks
2. A button
3. Breadboard
4. LILYGO TTGO ESP32 Board

To run this game, breadboarding is needed. You can follow the fritzing diagram/file in the fritzing folder.

Essentially, the breadboard should be set up this way:


<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/fritzing/supercold-fritzing.png" height="300" width="430"></a>

Though you don't need an enclosure to play this game, we have built one.

# Software Setup

Arduino IDE and Processing is needed for this project. Make sure that you have the Arduino IDE software and your ESP32 software installed. 
If you do not have Arduino IDE or the ESP32 LILYGO TTGO software, follow these instructions 
to install them: https://coms3930.notion.site/Lab-1-TFT-Display-a53b9c10137a4d95b22d301ec6009a94.

After setting up the breadboard, connect it to your computer via a USB-C cable. Upload the Arduino code, found in 
src/Arduino/SuperCold, named SuperCold.ino, and open it in the IDE. Upload this code to the board. In your serial monitor, you should see the joystick values 
and button value that is being recorded, prepended by a "C: ". To make sure this works, you can move around the joystick and press 
the button to ensure that the components are working.

Once this code is uploaded, close the Arduino IDE, and open Processing. Download the files in src/Processing and open them in Processing. 
After doing so, start the game.
