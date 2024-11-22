
// Camera Parameters
class Camera {
  float cameraX, cameraY;
  float cameraVelocityX, cameraVelocityY;
  float cameraForwardX, cameraForwardY;
  float cameraRightX, cameraRightY;
  float cameraMoveSpeed = 2;
  float cameraTurnVelocity;
  float cameraTurnSpeed = 5;
  float cameraFov = 90;
  float cameraNearPlane = 1;
  float cameraFarPlane = 1000;
  float cameraFogDistance = 100;
  float cameraAngle;
  float cameraLerp = 0.5;
  Camera() {
    cameraX = 10;
    cameraY = 10;
  }
}

// Input
boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;
boolean qPressed;
boolean ePressed;

// Render Parameters
PImage buffer;
int bufferWidth = 360, bufferHeight = 240;
int targetWidth = 1280, targetHeight = 720;
float halfTargetWidth = 640, halfTargetHeight = 360;

// Textures
PImage floorTexture;
PImage wallTexture;
PImage ceilingTexture;

// Walls
float wallHeight = 10;

float epsilon = 0.001;

void camera_draw(Camera player) {
  background(0);
  float angle = radians(player.cameraAngle);
  player.cameraForwardX = cos(angle);
  player.cameraForwardY = sin(angle);
  player.cameraRightX = sin(angle);
  player.cameraRightY = -cos(angle);
  float deltaX = tan(radians(player.cameraFov / 2)) * player.cameraNearPlane;
  float deltaZ = bufferHeight * deltaX / bufferWidth;
  // Raycasting
  for (int i = 0; i < bufferWidth; i++) {
    float offset = (2 * i / float(bufferWidth) - 1) * deltaX;
    float vectorX = player.cameraForwardX * player.cameraNearPlane + player.cameraRightX * offset;
    float vectorY = player.cameraForwardY * player.cameraNearPlane + player.cameraRightY * offset;
    float magnitude2D = sqrt(vectorX * vectorX + vectorY * vectorY);
    float directionX = vectorX / magnitude2D;
    float directionY = vectorY / magnitude2D;
    RaycastResult result = raycast(directionX, directionY);
    float depth = directionX * result.distance * player.cameraForwardX + directionY * result.distance * player.cameraForwardY;
    float wallScreenHeight = wallHeight * (player.cameraNearPlane / depth) * (bufferHeight / deltaZ);
    int wallStart = int(clamp(0.5 * bufferHeight - 0.25 * wallScreenHeight, 0, 0.5 * bufferHeight));
    int wallStop = bufferHeight - wallStart;
    float wallOffset = 0.25 - 0.5 * (wallStart + wallStop) / wallScreenHeight;
    // Draw Ceilings
    for (int j = 0; j < wallStart; j++)
    {
      float vectorZ = (1 - 2 * j / float(bufferHeight)) * deltaZ;
      float magnitude3D = sqrt(magnitude2D * magnitude2D + vectorZ * vectorZ);
      float directionZ = vectorZ / magnitude3D;
      if (directionZ < epsilon && directionZ > -epsilon) { 
        buffer.pixels[i + j * bufferWidth] = color(0);
        continue;
      }
      float distance = (wallHeight / 2) / directionZ;
      float u = player.cameraX + vectorX * distance / magnitude3D;
      float v = player.cameraY + vectorY * distance / magnitude3D;
      if (u < 0) u = 1 - (-u % wallHeight) / wallHeight; else u = (u % wallHeight) / wallHeight;
      if (v < 0) v = 1 - (-v % wallHeight) / wallHeight; else v = (v % wallHeight) / wallHeight;
      color albedo = ceilingTexture.get(int(clamp(u, 0, 1) * (ceilingTexture.width - 1)), int(clamp(v, 0, 1) * (ceilingTexture.height - 1)));
      float shade = clamp((1 - (distance - player.cameraNearPlane) / (player.cameraFogDistance - player.cameraNearPlane)), 0, 1);
      buffer.pixels[i + j * bufferWidth] = multiplyColor(albedo, shade);
    }
    // Draw Walls
    for (int j = wallStart; j < wallStop; j++)
    {
      float v = j / wallScreenHeight + wallOffset;
      float y = 0.5 * wallHeight * (1 - 2 * v);
      float distance = sqrt(y * y + result.distance * result.distance);
      color albedo = wallTexture.get(int(clamp(result.u, 0, 1) * (wallTexture.width - 1)), int(clamp(v, 0, 1) * (wallTexture.height - 1)));
      float shade = clamp(1 - (distance - player.cameraNearPlane) / (player.cameraFogDistance - player.cameraNearPlane), 0, 1);
      buffer.pixels[i + j * bufferWidth] = multiplyColor(albedo, shade);
    }
    // Draw Floors
    for (int j = wallStop; j < bufferHeight; j++)
    {
      float vectorZ = (1 - 2 * j / float(bufferHeight)) * deltaZ;
      float magnitude3D = sqrt(magnitude2D * magnitude2D + vectorZ * vectorZ);
      float directionZ = vectorZ / magnitude3D;
      if (directionZ < epsilon && directionZ > -epsilon) {
        buffer.pixels[i + j * bufferWidth] = color(0);
        continue;
      }
      float distance = (-wallHeight / 2) / directionZ;
      float u = player.cameraX + vectorX * distance / magnitude3D;
      float v = player.cameraY + vectorY * distance / magnitude3D;
      if (u < 0) u = 1 - (-u % wallHeight) / wallHeight; else u = (u % wallHeight) / wallHeight;
      if (v < 0) v = 1 - (-v % wallHeight) / wallHeight; else v = (v % wallHeight) / wallHeight;
      color albedo = floorTexture.get(int(clamp(u, 0, 1) * (floorTexture.width - 1)), int(clamp(v, 0, 1) * (floorTexture.height - 1)));
      float shade = clamp((1 - (distance - player.cameraNearPlane) / (player.cameraFogDistance - player.cameraNearPlane)), 0, 1);
      buffer.pixels[i + j * bufferWidth] = multiplyColor(albedo, shade);
    }
  }
  buffer.updatePixels();
  image(buffer, 0, 0, targetWidth, targetHeight);

  // Update Input
  float velocityX = 0;
  float velocityY = 0;
  float velocityZ = 0;
  if (aPressed) {
    velocityX -= player.cameraRightX * player.cameraMoveSpeed;
    velocityY -= player.cameraRightY * player.cameraMoveSpeed;
  }
  if (dPressed) {
    velocityX += player.cameraRightX * player.cameraMoveSpeed;
    velocityY += player.cameraRightY * player.cameraMoveSpeed;
  }
  if (wPressed) {
    velocityX += player.cameraForwardX * player.cameraMoveSpeed;
    velocityY += player.cameraForwardY * player.cameraMoveSpeed;
  }
  if (sPressed) {
    velocityX -= player.cameraForwardX * player.cameraMoveSpeed;
    velocityY -= player.cameraForwardY * player.cameraMoveSpeed;
  }
  if (qPressed) velocityZ += player.cameraTurnSpeed;
  if (ePressed) velocityZ -= player.cameraTurnSpeed;
  // Update Camera
  player.cameraVelocityX = player.cameraLerp * velocityX + (1 - player.cameraLerp) * player.cameraVelocityX;
  player.cameraVelocityY = player.cameraLerp * velocityY + (1 - player.cameraLerp) * player.cameraVelocityY;
  player.cameraX += player.cameraVelocityX;
  player.cameraY += player.cameraVelocityY;
  player.cameraTurnVelocity = player.cameraLerp * velocityZ + (1 - player.cameraLerp) * player.cameraTurnVelocity;
  player.cameraAngle += player.cameraTurnVelocity;
}

color multiplyColor(color col, float a) {
  return color(red(col) * a, green(col) * a, blue(col) * a);
}

void keyPressed() {
  if (key == 'w') wPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'd') dPressed = true;
  if (key == 'q') qPressed = true;
  if (key == 'e') ePressed = true;
}

void keyReleased()
{
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
  if (key == 'q') qPressed = false;
  if (key == 'e') ePressed = false;
}

int clamp(int x, int min, int max) {
  if (x < min) return min;
  if (x > max) return max;
  return x;
}

float clamp(float x, float min, float max) {
  if (x < min) return min;
  if (x > max) return max;
  return x;
}

RaycastResult raycast(float directionX, float directionY) {
  RaycastResult result = new RaycastResult();
  for (int i = 0; i < walls.size(); i++) {
    float determinant = directionX * walls.get(i).dY - directionY * walls.get(i).dX;
    if (determinant < epsilon && determinant > -epsilon)
      continue;
    float distance = walls.get(i).dY * (walls.get(i).p1X - player.cameraX) - walls.get(i).dX * (walls.get(i).p1Y - player.cameraY);
    distance /= determinant;
    if (distance < player.cameraNearPlane || distance > result.distance)
      continue;
    float u = directionY * (player.cameraX - walls.get(i).p1X) - directionX * (player.cameraY - walls.get(i).p1Y);
    u /= determinant;
    if (u < 0 || u > 1)
      continue;
    result.distance = distance;
    result.u = ((u * walls.get(i).wallLength) % wallHeight) / wallHeight;
  }
  return result;
}

class RaycastResult {
  float distance = player.cameraFarPlane;
  float u;
  RaycastResult() {
  }
}   
