Maze map;
Particle player;
ArrayList<Boundary> walls;

final int mazeW = 5;
final int mazeH = 5;
final int blockSize = 80;
final int minimapBoundarySize = 10;
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
  camera_draw(player, walls, map);
  draw_minimap(walls, map, player, true);
}


void draw_minimap(ArrayList<Boundary> walls, Maze map, Particle player, boolean blind) {
    int shrink = blockSize/minimapBoundarySize;
    int offsetX = width - map.gridDimensionX * minimapBoundarySize;
    int mapHeight = map.gridDimensionY * minimapBoundarySize;
    fill(0);
    rectMode(CORNERS);
    rect(offsetX, 0, width, mapHeight);
    
    if(!blind) {
      for (Boundary wall : walls) {
        wall.show(offsetX, shrink);
      }
    }
    else {
       for(Boundary wall: player.get_visible_boundaries(walls)) {
         wall.show(offsetX, shrink);
       }
    }
    
    float playerX = offsetX + player.pos.x/shrink;
    float playerY = player.pos.y/shrink;
    fill(255);
    ellipse(playerX, playerY, 5, 5);
}
