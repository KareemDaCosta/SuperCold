Maze map;
Particle player;
ArrayList<Boundary> walls;

final int mazeW = 5;
final int mazeH = 5;
final int blockSize = 20;
final char backChar = ' ', wallChar = 'X', cellChar = ' ', pathChar = '*';

int sceneW = 800;
int sceneH = 800;

void setup() {
  map = new Maze(mazeW, mazeH);
  windowResize(sceneW, sceneH);
  player = new Particle();
  walls = new ArrayList<Boundary>();
  setup_boundaries(map, walls);
}

void draw() {
  draw_boundaries(walls);
  camera_draw(player, walls, map);
}
