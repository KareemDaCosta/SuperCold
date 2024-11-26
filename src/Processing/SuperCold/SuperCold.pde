Maze map;
Camera player;
Enemy enemy;
ArrayList<Wall> walls;

final int mazeW = 5;
final int mazeH = 5;
final int blockSize = 10;
final int minimapBoundarySize = 10;
final char backChar = ' ', wallChar = 'X', cellChar = ' ', pathChar = '*';
float playerWidth = 0.2;

int sceneW = 1280;
int sceneH = 720;

void setup() {
  size(1280, 720);
  frameRate(30);
  map = new Maze(mazeW, mazeH);
  walls = new ArrayList<Wall>();
  setup_walls(map, walls);
  player = new Camera();
  enemy = new Enemy(25, 35);
  buffer = createImage(bufferWidth, bufferHeight, RGB);
  floorTexture = loadImage("floor.jpg");
  wallTexture = loadImage("wall.jpg");
  ceilingTexture = loadImage("ceiling.jpg");
}

void draw() {
  enemy.updateVariables();
  enemy.updateTexture(player);
  camera_draw(player, enemy);
  draw_minimap(walls, map, false);
  draw_crosshair();
}


void draw_minimap(ArrayList<Wall> walls, Maze map, boolean blind) {
    
    float shrink = blockSize/minimapBoundarySize;
    int offsetX = width - map.gridDimensionX * minimapBoundarySize;
    int mapHeight = map.gridDimensionY * minimapBoundarySize;
    fill(0);
    rectMode(CORNERS);
    rect(offsetX, 0, width, mapHeight);
    
    if(!blind) {
      for (Wall wall : walls) {
        wall.show(offsetX, shrink);
      }
    }
    
    /*else {
       for(Wall wall: player.get_visible_boundaries(walls)) {
         wall.show(offsetX, shrink);
       }
    }*/
    
    float playerX = offsetX + player.cameraX/shrink;
    float playerY = player.cameraY/shrink;
    fill(255);
    ellipse(playerX, playerY, 5, 5);
    stroke(255);
    line(playerX, playerY, playerX + player.cameraForwardX * 10, playerY + player.cameraForwardY * 10);
}

void draw_crosshair() {
 stroke(255);
 line(width / 2 + 30, height / 2, width / 2 + 10, height / 2);
 line(width / 2 - 30, height / 2, width / 2 - 10, height / 2);
 line(width / 2, height / 2 + 30, width / 2, height / 2 + 10);
 line(width / 2, height / 2 - 30, width / 2, height / 2 - 10);
 fill(255);
 circle(width / 2, height / 2, 2);
  
}
