class Enemy {
  float x, y;
  float velocityX, velocityY;
  float cameraAngle;
  int firingCountdown;
  boolean firing;
  boolean justFired;
  char movementLetter;
  int movementTimer;
  int dyingTimer;
  char dyingStage;
  float enemyWidth = 4;
  float enemyHeight = 0;
  PImage texture;

  Enemy(int startingX, int startingY) {
    x = startingX;
    y = startingY;
    firing = false;
    justFired = false;
    cameraAngle = 0;
    firingCountdown = 0;
    movementLetter = 'A';
    movementTimer = 20;
    dyingTimer = 0;
    dyingStage = 1;
    texture = loadImage("./Sprites/B15BA1.png");
    enemyHeight = (float) texture.height / (float) texture.width * enemyWidth;
  }
  
  void updatePosition(int newX, int newY) {
    x = newX;
    y = newY;
  }
  
  void updateVelocity(int newVelocityX, int newVelocityY) {
     velocityX = newVelocityX;
     velocityY = newVelocityY;
  }
  
  void fire() {
     firing = true;
     firingCountdown = 15;
  }
  
  void updateVariables() {
   if(movementTimer > 0) {
      movementTimer--;
      if(movementTimer == 0) {
         movementTimer = 20;
         if(movementLetter == 'A') {
            movementLetter = 'B'; 
         }
         else if(movementLetter == 'B') {
            movementLetter = 'C'; 
         }
         else if(movementLetter == 'C') {
            movementLetter = 'D'; 
         }
         else {
            movementLetter = 'A'; 
         }
      }
   }
   if(firingCountdown > 0) {
      firingCountdown--; 
      if(firingCountdown == 0) {
         if(firing) {
           firingCountdown = 20;
           firing = false;
           justFired = true;
         }
         else {
            justFired = false;
         }
      }
   }
   if(dyingTimer > 0) {
      dyingTimer--;
      if(dyingTimer == 0) {
         dyingTimer = 10;
         dyingStage++;
         if(dyingStage == 6) {
            //Trigger new game 
         }
      }
    }
  } 
}
