Maze map;
Camera player;
Enemy enemy;
ArrayList<Wall> walls;
Intro intro;

final int mazeW = 5;
final int mazeH = 5;
final int blockSize = 10;
final int minimapBoundarySize = 10;
final char backChar = ' ', wallChar = 'X', cellChar = ' ', pathChar = '*';
final int gunCooldownMax = 12;
float playerWidth = 0.2;
PFont buttonFont;
PFont titleFont;
int gunCooldown = 0;

int sceneW = 1280;
int sceneH = 720;

void setup() {
  size(1280, 720);
  frameRate(30);
  intro = new Intro();
  titleFont = createFont("Audiowide.ttf", 128);
  buttonFont = createFont("Oxanium.ttf", 32);
}

void draw() {
  if(intro.inIntro) {
    intro.show_intro();
  }
  else {
    enemy.updateVariables();
    enemy.updateTexture(player);
    camera_draw(player, enemy);
    draw_minimap(walls, map, false);
    draw_crosshair();
    if(gunCooldown > 0) {
       gunCooldown--; 
    }
  }
}

void setup_game_host() {
  map = new Maze(mazeW, mazeH);
  walls = new ArrayList<Wall>();
  setup_walls(map, walls);
  player = new Camera();
  enemy = new Enemy(25, 35);
  setup_game();  
}

void setup_game_lobby() {
 //recieve game information and player coordinates from the host
 setup_game();
}

void setup_game() {
  floorTexture = loadImage("floor.jpg");
  wallTexture = loadImage("wall.jpg");
  ceilingTexture = loadImage("ceiling.jpg");
  buffer = createImage(bufferWidth, bufferHeight, RGB);
  intro.inIntro = false;
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
        wall.show(offsetX, shrink, mapHeight);
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
    ellipse(playerX, mapHeight - playerY, 5, 5);
    stroke(255);
    line(playerX, mapHeight - playerY, playerX + player.cameraForwardX * 10, mapHeight - playerY - player.cameraForwardY * 10);
}

void draw_crosshair() {
 stroke(255);
 line(width / 2 + 30, height / 2, width / 2 + 10, height / 2);
 line(width / 2 - 30, height / 2, width / 2 - 10, height / 2);
 line(width / 2, height / 2 + 30, width / 2, height / 2 + 10);
 line(width / 2, height / 2 - 30, width / 2, height / 2 - 10);
 fill(255);
 circle(width / 2, height / 2, 2);
 if(gunCooldown > 0) {
   stroke(150);
   line(width / 2 - 30, height / 2 + 50, width / 2 + 30, height / 2 + 50);
   stroke(255);
   line(width / 2 - 30, height / 2 + 50, (width / 2 - 30 + (float) 60 / gunCooldownMax * (gunCooldownMax - gunCooldown)), height / 2 + 50);
 }
}

void mouseClicked() { 
  if(intro.inIntro) {
    if(intro.selectedOption == "Host Game") {
       setup_game_host();
    }
    else {
       setup_game_lobby(); 
    }
  }
  else {
     triggerShot(player, enemy); 
  }
}

void triggerShot(Camera player, Enemy enemy) {
  if(gunCooldown != 0) {
     return; 
  }
  Wall enemyBoundary = getEnemyBoundary(player, enemy);
  RaycastResult result = raycast(player.cameraForwardX, player.cameraForwardY, enemyBoundary);
  gunCooldown = gunCooldownMax;
  if(result.enemyDistance > -1) {
     //Enemy hit
     enemy.triggerDeath();
  }
}
