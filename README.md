# :gun: SuperCold

# About

SuperCold is a 1 vs.1 first person shooter game, designed to work in Processing with an 
LILYGO TTGO ESP32 board, two joysticks, and a button. This was designed for COMS3930 Creative Embedded Systems,
a class at Barnard College/Columbia University.

Blog Post Link:

Game Demonstration URL: https://youtu.be/ZPlPPXtJgXw

Hardware Demonstration URL 1: https://youtu.be/G9jpJyo6zvE

Hardware Demonstration URL 2: https://youtu.be/uUqCYK2Ewng

# Hardware Setup

Components required per player:
1. Two joysticks
2. A button
3. Breadboard
4. LILYGO TTGO ESP32 Board

To run this game, breadboarding is needed. You can follow the fritzing diagram/file in the fritzing folder.

Essentially, the breadboard should be set up this way:


<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/fritzing/supercold-fritzing.png" height="300" width="430"></a>

Though you don't need an enclosure to play this game, we have built one. It's meant for laser cutting. Feed the wires of the components through the holes that are built into the design.

Left side URL: https://cad.onshape.com/documents/07ceb72ceb090dab75ac0fec/w/98673474abd7e072173f39ee/e/25c00ce18c5c9eedaac6cd59?renderMode=0&uiState=675a3f5927ccb052a8b508a4

Right side URL: https://cad.onshape.com/documents/3fa702f85601735e85225603/w/23016780c4209c4159dd0dbf/e/887f0b19d0142e7bd0c91851?renderMode=0&uiState=675a3f45410bed34edb3aeb8

<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/onshape-left.png" height="300" width="430"></a>
<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/onshape-right.png" height="300" width="300"></a>

This is what the final design should look like:

<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/enclosure-pic-2.jpg" height="300" width="300"></a>

# Software Setup

Arduino IDE and Processing is needed for this project. Make sure that you have the Arduino IDE software and your ESP32 software installed. 
If you do not have Arduino IDE or the ESP32 LILYGO TTGO software, follow these instructions 
to install them: https://coms3930.notion.site/Lab-1-TFT-Display-a53b9c10137a4d95b22d301ec6009a94.

After setting up the breadboard, connect it to your computer via a USB-C cable. Upload the Arduino code, found in 
src/Arduino/SuperCold, named SuperCold.ino, and open it in the IDE. Upload this code to the board. In your serial monitor, you should see the joystick values 
and button value that is being recorded, prepended by a "C: ". To make sure this works, you can move around the joystick and press 
the button to ensure that the components are working.

Once this code is uploaded, close the Arduino IDE, and open Processing. Download the files in src/Processing and open them in Processing. 
After doing so, start the game. At this point in time, make sure that you have at least one other person with the code running.

Have one person host the game and one person join the game. You can use one joystick (the one using 39, 32, 33) to control the left and right of the camera, as well as 
the selection in the lobby. Use the button to shoot in the game or to confirm choice in lobby. The other joystick will be used for movement in the game.

You can also use WASD for movement, Q and E for left and right turning, and clicking to simulate the button. Have fun!

# Demonstration GIFs

<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/SuperCold%20Video%20Demo%20Gif.gif" height="300" width="430"></a>
<a href="url"><img src="https://github.com/KareemDaCosta/Super-Cold/blob/main/media/SuperCold%20Hardware%20Gif.gif" height="300" width="430"></a>
