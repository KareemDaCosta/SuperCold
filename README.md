# :gun: SuperCold

# About

SuperCold is a 1 vs.1 first person shooter game, designed to work in Processing with an
LILYGO TTGO ESP32 board.

To read more about the development of the game, check out my blog post here: https://medium.com/@kd2688/super-cold-25c6b1b90f1c

Game Demonstration URL: https://www.youtube.com/watch?v=WEBndFqB_kw

# Hardware Setup

Each player will need a LILYGO TTGO ESP32 Board

# Software Setup

Arduino IDE and Processing is needed for this project. Make sure that you have the Arduino IDE software and your ESP32 software installed.
If you do not have Arduino IDE or the ESP32 LILYGO TTGO software, follow these instructions
to install them: https://coms3930.notion.site/Lab-1-TFT-Display-a53b9c10137a4d95b22d301ec6009a94.

Connect the ESP-32 to your computer via a USB-C cable. Upload the Arduino code, found in
src/Arduino/SuperCold, named SuperCold.ino, and open it in the IDE. Upload this code to the board. In your serial monitor, you should see the joystick values
and button value that is being recorded, prepended by a "C: ". To make sure this works, you can move around the joystick and press
the button to ensure that the components are working.

Once this code is uploaded, close the Arduino IDE, and open Processing. Download the files in src/Processing and open them in Processing.
After doing so, start the game. At this point in time, make sure that you have at least one other person with the code running.

You can also use WASD for movement, Q and E for left and right turning, and clicking to simulate the button. Have fun!

# Demonstration!

<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/SuperCold%20Video%20Demo%20Gif.gif" height="300" width="430"></a>
