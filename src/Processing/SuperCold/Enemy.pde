class Enemy {
  float x, y;
  float velocityX, velocityY;

  Enemy(int startingX, int startingY) {
    x = startingX;
    y = startingY;
  }
  
  void move(int newX, int newY) {
      x = newX;
      y = newY;
  }
  
  void updateVelocity(int newVelocityX, int newVelocityY) {
     velocityX = newVelocityX;
     velocityY = newVelocityY;
  }
}
