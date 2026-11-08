class MasterChannel {
  int MASTER;
  float x;
  float y;
  float w;
  float h;

  OSCManager oscManager;              // OSC manager


  float volume = 0.75;
  
  boolean draggingFader = false;
  boolean solo = false;
boolean masterMute = false;

  MasterChannel(int MASTER, float x, float y, float w, float h,
        OSCManager oscManager) {
    this.MASTER = MASTER;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
this.oscManager = oscManager;
  }

  void display() {
    // Draw channel background
    fill(40, 44, 52);
    stroke(90);
    rect(x, y, w, 720);

    // Channel title
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(MASTER, x + w / 2, y + 700);

  

    // Draw fader track
    float faderX = x + w / 2;
    float faderTop = y + 500;
    float faderBottom = y + 690;

    stroke(150);
    line(faderX, faderTop, faderX, faderBottom);

    // Draw fader handle
    float faderY = map(volume, 0, 1, faderBottom, faderTop);

    stroke(230);
    fill(220);
    rectMode(CENTER);
    rect(faderX, faderY, w * 0.55, 9, 3);
    rectMode(CORNER);

   
    // Solo button
    float buttonX = x + 10;
    float buttonY = y + 460;
    float buttonW = w - 20;
    float buttonH = 20;

    if (solo) {
      fill(255, 165, 0);
    } else {
      fill(75, 80, 90);
    }
    
    
    noStroke();
    rect(buttonX, buttonY, buttonW, buttonH, 4);

    fill(255);
    textSize(11);
    text("SOLO", buttonX + buttonW / 2,
                 buttonY + buttonH / 2);
  

if (masterMute) {
      fill(255, 0 ,0);
    } else {
      fill(75, 80, 90);
    }

float mastermutebtnY = y + 430;
rect(buttonX,mastermutebtnY , buttonW, buttonH, 4);

fill(255);
    textSize(11);
    text("MUTE", buttonX + buttonW / 2,
      mastermutebtnY + buttonH / 2);
}

void mousePressed() {
    float buttonX = x + 10;
    float buttonY = y + 460;
    float buttonW = w - 20;
    float buttonH = 20;
float mastermutebtnY = y + 430;

    // Check Solo button
    if (mouseX >= buttonX &&
        mouseX <= buttonX + buttonW &&
        mouseY >=  buttonY &&
        mouseY <= buttonY + buttonH) {
      solo = !solo;
      oscManager.setSolo(0, solo);               // Send OSC to REAPER

      return;
    }
//Check Mute button
    if (mouseX >= buttonX &&
        mouseX <= buttonX + buttonW &&
        mouseY >= mastermutebtnY &&
        mouseY <= mastermutebtnY + buttonH) {
      masterMute = !masterMute;
      oscManager.setMasterMute(masterMute);               // Send OSC to REAPER

      return;
    }
    // Check fader area
    float faderX = x + w / 2;
    float faderTop = y + 500;
    float faderBottom = y + 690;

    if (mouseX >= faderX - w * 0.3 && 
        mouseX <= faderX + w * 0.3 &&
        mouseY >= faderTop - 10 &&
        mouseY <= faderBottom + 10) {
      draggingFader = true;
      updateVolume();
    }
  }
  
  void mouseDragged() {
    if (draggingFader) {
      updateVolume();
    }
  }

  void mouseReleased() {
    draggingFader = false;
  }

  void updateVolume() {
    float faderTop = y + 500;
    float faderBottom = y + 690;

    volume = map(mouseY, faderTop, faderBottom, 1, 0);
    volume = constrain(volume, 0, 1);
     oscManager.setVolume(0, volume);
  }
}
