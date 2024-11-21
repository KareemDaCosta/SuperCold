class Boundary {
  int x1, y1, x2, y2;

  Boundary(int x1, int y1, int x2, int y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }

  void show() {
    stroke(255);
    line(x1, y1, x2, y2);
  }
}

void setup_boundaries(Maze map, ArrayList<Boundary> walls) {  
    for (int y = 0; y < map.gridDimensionY; y++) {
      for (int x = 0; x <  map.gridDimensionX; x++) {
        if (map.grid[x][y] == 'X') {
             walls.add(new Boundary(x * blockSize, y * blockSize, x * blockSize + blockSize, y * blockSize));
             walls.add(new Boundary(x * blockSize, y * blockSize, x * blockSize, y * blockSize + blockSize));
             walls.add(new Boundary(x * blockSize + blockSize, y * blockSize + blockSize, x * blockSize + blockSize, y * blockSize));
             walls.add(new Boundary(x * blockSize + blockSize, y * blockSize + blockSize, x * blockSize, y * blockSize + blockSize));
        }
      }
    }
}

void draw_boundaries(ArrayList<Boundary> walls) {
    for (Boundary wall : walls) {
      wall.show();
    } 
}
