class Intro {
  String selectedOption;
  boolean inIntro;
  Intro() {
    selectedOption = "Host Game";
    inIntro = true;
  }
  
  void show_intro() {
    if(ePressed) {
      selectedOption = "Join Lobby";
    }
    else if(qPressed) {
      selectedOption = "Host Game";
    }
    
    textAlign(CENTER);
    textFont(titleFont);
    fill(0, 10);
    noStroke();
    rect(0, 0, width, height);
    fill(255);
    ellipse(random(width), random(height), 2, 2);
    text("Super Cold", width/2, 2*height/5);
    
    textFont(buttonFont);
    
    if(selectedOption == "Host Game") {
       stroke(255, 255, 255);
       strokeWeight(3);
    }
    else {
      stroke(150, 150, 150);
      strokeWeight(2);
    }
    noFill();
    rect(width/6, 3*height/5, width/4, height/6);
    
    if(selectedOption == "Host Game") {
       fill(255, 255, 255);
    }
    else {
      fill(150, 150, 150);
    }
    text("Host Game", width/6 + width/8, (3 * height/5 + height/12 + 12));
    
    
    if(selectedOption == "Join Lobby") {
       stroke(255, 255, 255);
       strokeWeight(3);
    }
    else {
      stroke(150, 150, 150);
      strokeWeight(2);
    }
    noFill();
    rect(width - width/6 - width/4, 3*height/5, width/4, height/6);
    
    if(selectedOption == "Join Lobby") {
       fill(255, 255, 255);
    }
    else {
      fill(150, 150, 150);
    }
    
    text("Join Lobby", width - width/6 - width/4 + width/8, (3 * height/5 + height/12 + 12));
  }
  
}
