class Wall {
  float p1X, p1Y;
  float p2X, p2Y;
  float  dX,  dY;
  float wallLength;
  Wall(float pAX, float pAY, float pBX, float pBY) {
    p1X = pAX;
    p1Y = pAY;
    p2X = pBX;
    p2Y = pBY;
    dX  = p1X - p2X;
    dY  = p1Y - p2Y;
    wallLength = sqrt(dX * dX + dY * dY);
  }
  
   void show(int offsetX, float shrink) {
    stroke(255);
    line(p1X/shrink + offsetX, p1Y/shrink, p2X/shrink + offsetX, p2Y/shrink);
   }
}

void setup_walls(Maze map, ArrayList<Wall> walls) {  
    for (int y = 0; y < map.gridDimensionY; y++) {
      for (int x = 0; x <  map.gridDimensionX; x++) {
        if (map.grid[x][y] == 'X') {
             walls.add(new Wall(x * blockSize, y * blockSize, x * blockSize + blockSize, y * blockSize));
             walls.add(new Wall(x * blockSize, y * blockSize, x * blockSize, y * blockSize + blockSize));
             walls.add(new Wall(x * blockSize + blockSize, y * blockSize + blockSize, x * blockSize + blockSize, y * blockSize));
             walls.add(new Wall(x * blockSize + blockSize, y * blockSize + blockSize, x * blockSize, y * blockSize + blockSize));
        }
      }
    }
}
