import processing.serial.*;

Maze map;
Camera player;
Enemy enemy;
ArrayList<Wall> walls;
Intro intro;
boolean isHost = false;
int broadcastLobbyTimer = 0;

boolean lobbySetup1 = false;
boolean lobbySetup2 = false;

Serial myPort;  // Create object from Serial class

final int[][] respawnLocations = {
  {15, 15, 0},
  {15, 95, 0},
  {195, 15, 180},
  {195, 95, 180},
};

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
int playerDyingCountdown = 0;
int playerDyingStage = 0;

int sceneW = 1280;
int sceneH = 720;

int playerScore;
int enemyScore;


void setup() {
  size(1280, 720);
  frameRate(30);
  intro = new Intro();
  titleFont = createFont("Audiowide.ttf", 128);
  buttonFont = createFont("Oxanium.ttf", 32);
  
  String portName = Serial.list()[2];
  //Used for getting proper port
  //printArray(Serial.list());
  //println(portName);
  
  myPort = new Serial(this, portName, 9600); // ensure baudrate is consistent with arduino sketch
  myPort.bufferUntil('\n');
}

void draw() {
  if(intro.inIntro) {
    intro.show_intro();
  }
  else if(intro.inSetup) {
     if(lobbySetup1 && lobbySetup2) {
        intro.inSetup = false;
     }
     else {
       intro.show_setup(); 
       if(isHost) {
         if(broadcastLobbyTimer <= 0) {
           broadcastLobby(); 
           broadcastLobbyTimer = 150;
         }
         else {
           broadcastLobbyTimer--; 
         }
       }
     }
  }
  else if (playerDyingCountdown > 0) {
    handlePlayerDeath();
  }
  else {
    if(gunCooldown > 0) {
       gunCooldown--; 
    }
    
    enemy.updateVariables();
    enemy.updateTexture(player);
    camera_draw(player, enemy);
    draw_minimap(walls, map, false);
    draw_crosshair();
    drawScore();
  }
}

void setup_game_host() {
  setup_game();  
  int playerLocationIndex = (int) random(0, 4);
  int enemyLocationIndex = (int) random(0, 4);
  while(enemyLocationIndex == playerLocationIndex) {
    enemyLocationIndex = (int) random(0, 4);
  }
  int[] playerLocation = respawnLocations[playerLocationIndex];
  int[] enemyLocation = respawnLocations[enemyLocationIndex];
  walls = new ArrayList<Wall>();
  setup_walls(map, walls);
  player = new Camera(playerLocation[0], playerLocation[1], playerLocation[2]);
  enemy = new Enemy(enemyLocation[0], enemyLocation[1], enemyLocation[2]);
  isHost = true;
}

void setup_game_lobby() {
 //recieve game information and player coordinates from the host
 setup_game();
}

void setup_game() {
  map = new Maze(mazeW, mazeH);
  floorTexture = loadImage("floor.jpg");
  wallTexture = loadImage("wall.jpg");
  ceilingTexture = loadImage("ceiling.jpg");
  buffer = createImage(bufferWidth, bufferHeight, RGB);
  intro.inIntro = false;
  intro.inSetup = true;
  playerScore = 0;
  enemyScore = 0;
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
  if(intro.inSetup) {
    return; 
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
  ArrayList<String> message = new ArrayList<>();
  if(result.enemyDistance > -1) {
     //Enemy hit
     message.add("true");
     enemy.triggerDeath();
  }
  else {
     message.add("false");

  }
  sendMessage('F', message);
}

void triggerPlayerDeath() {
  if(playerDyingStage == 0) {
   playerDyingStage = 1;
   playerDyingCountdown = 20;
  }
}

void handlePlayerDeath() {
  //triggered by ESP message (set up during communication stage) 
    playerDyingCountdown--;
    fill(255, 0, 0, 35);
    noStroke();
    rect(0, 0, width, height);
    if(playerDyingCountdown == 0) {
      playerDyingStage++;
      if(playerDyingStage == 2) {
        playerDyingCountdown = 60;
        enemyScore++; 
        fill(255, 0, 0);
        rect(0, 0, width, height);
      }
      if(playerDyingStage >= 3) {
         playerDyingStage = 0;
         int respawnLocationIndex = (int) random(0, 4);
         int[] respawnLocation = respawnLocations[respawnLocationIndex];
         player = new Camera(respawnLocation[0], respawnLocation[1], respawnLocation[2]);
      }
    }
    if(playerDyingStage == 2) {
      fill(255);
      textFont(titleFont);
      text("You Died", width/2, height/2 + 64);
    }
    drawScore();
}


void drawScore() {
  fill(255);
  textFont(titleFont);
  text(Integer.toString(playerScore) + " - " + Integer.toString(enemyScore), width/2, height/6);
}

void sendMessage(char prefix, ArrayList<String> message) {
  String formattedMessage = "";
  for(int i = 0; i < message.size(); i++) {
    formattedMessage += message.get(i);
    if(i < message.size() - 1) {
       formattedMessage += ","; 
    }
  }
  myPort.write(prefix + ": " + formattedMessage + "\n");
}

void serialEvent(Serial myPort) {
  try {
  if(myPort.available() > 0) {
    while(myPort.available() > 0) {
     String receivedMessage = myPort.readStringUntil('\n').trim();
     
     if(receivedMessage.charAt(0) == 'A') {
        lobbySetup1 = true; 
        continue;
     }
     if(receivedMessage.charAt(0) == 'B') {
        lobbySetup2 = true; 
        continue;
     }
     
     String[] components = receivedMessage.split(": ");
     String[] message;
     switch(components[0]) {
      case "P":
        message = components[1].split(",");
        if(!intro.inIntro && !intro.inSetup) {
          enemy.updatePosition(Float.parseFloat(message[0]), Float.parseFloat(message[1]));
          enemy.updateVelocity(Float.parseFloat(message[2]), Float.parseFloat(message[3]));
          enemy.updateCameraAngle(Float.parseFloat(message[4]));
        }
        break;
      case "F":
        message = components[1].split(",");
        enemy.fire();
        if(message[0].equals("true")) {
          triggerPlayerDeath();
        }
        break;
      case "S":
        message = components[1].split(",");
        if(intro.inSetup && !isHost) {
          handleSetup(message);
        }
        break;
      case "M":
        message = components[1].split(",");
        if(intro.inSetup && !isHost) {
          handleMap(message);
        }
        break;
     }
    }
  }
  }
  catch(RuntimeException e) {
    e.printStackTrace();
    System.out.println(e);
  }
}

void handleSetup(String[] message) {
  float x, y, angle;
  x = Float.parseFloat(message[0]);
  y = Float.parseFloat(message[1]);
  angle = Float.parseFloat(message[2]);
  enemy = new Enemy(x, y, angle);
  
  x = Float.parseFloat(message[3]);
  y = Float.parseFloat(message[4]);
  angle = Float.parseFloat(message[5]);
  player = new Camera(x, y, angle);
  
  map.gridDimensionX = Integer.parseInt(message[6]);
  map.gridDimensionY = Integer.parseInt(message[7]);

  lobbySetup1 = true;
  
  ArrayList<String> new_message = new ArrayList<>();
  sendMessage('A', new_message);
}

void handleMap(String[] message) {
  map.grid = new char[map.gridDimensionX][map.gridDimensionY];
  for(int x = 0; x < map.gridDimensionX; x++) {
    for(int y = 0; y < map.gridDimensionY; y++) {
      int i = map.gridDimensionY * x + y;
      map.grid[x][y] = message[0].charAt(i);
    }
  }
  
  walls = new ArrayList<Wall>();
  setup_walls(map, walls);
  
  lobbySetup2 = true;
  
  ArrayList<String> new_message = new ArrayList<>();
  sendMessage('B', new_message);
}

void broadcastLobby() {
  ArrayList<String> message = new ArrayList<>();
  message.add("" + player.cameraX);
  message.add("" + player.cameraY);
  message.add("" + player.cameraAngle);
 
  message.add("" + enemy.x);
  message.add("" + enemy.y);
  message.add("" + enemy.cameraAngle / PI * 180);
  
  message.add("" + map.gridDimensionX);
  message.add("" + map.gridDimensionY);
  
  String map_str = "";
  for(int i = 0; i < map.grid.length; i++) {
    for(int j = 0; j < map.grid[0].length; j++) {
      map_str += "" + map.grid[i][j];
    }
  }
  ArrayList<String> map = new ArrayList<>();
  map.add(map_str);
  sendMessage('S', message);
  sendMessage('M', map);
}
