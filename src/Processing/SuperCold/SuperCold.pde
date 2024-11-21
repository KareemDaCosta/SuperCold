Maze map;

void setup() {
  map = new Maze(6);
  System.out.println(map);
  windowResize(map.gridDimensionX*40, map.gridDimensionY*40);
}

void draw() {
  map.draw_map();
}
