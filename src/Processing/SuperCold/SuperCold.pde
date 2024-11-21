Maze map;
Particle player;
ArrayList<Boundary> walls;

final int mazeW = 5;
final int mazeH = 5;
final int blockSize = 20;

int sceneW;
int sceneH;

void setup() {
  map = new Maze(mazeW, mazeH);
  System.out.println(map);
  sceneW = map.gridDimensionX*blockSize;
  sceneH = map.gridDimensionY*blockSize;
  windowResize(sceneW * 2, sceneH);
  player = new Particle();
  walls = new ArrayList<Boundary>();
  setup_boundaries(map, walls);
}

void draw() {
  camera_draw(player, walls);
  draw_boundaries(walls);
}
