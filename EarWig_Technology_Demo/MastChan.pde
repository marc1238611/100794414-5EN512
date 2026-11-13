//Represents Reapers master channel strip and gives it its own fader, pan, solo and mute controls. Channel 0 is used as Reaper defaults channel 0 as the master channel

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

Button muteButton;
Button soloButton;
//Stores the master channel strips position and OSC connection.
//Creates mute and solo buttons using channel 0
  MasterChannel(int MASTER, float x, float y, float w, float h,
        OSCManager oscManager) {
    this.MASTER = MASTER;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
this.oscManager = oscManager;

muteButton = new Button(x + 10, y + 430, w - 20, 20,
                        "MUTE", "MUTE", 0, oscManager);
soloButton = new Button(x + 10, y + 460, w - 20, 20,
                        "SOLO", "SOLO", 0, oscManager);
  }
//Draw the master channel's strip including its fader, positions the fader handle relative to the current volume value
//Draws the solo and mute buttons
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

   
    
   muteButton.display();
soloButton.display();
}
//Forwards mouse presses to the master channels buttons and 
//begins fader dragging when the mouse is pressed within the fader area
void mousePressed() {
    muteButton.mousePressed();
soloButton.mousePressed();

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
//Converts the mouses and hence faders vertical position into a clamped 0-1 value and 
//Sends it to Reaper as track 0
  void updateVolume() {
    float faderTop = y + 500;
    float faderBottom = y + 690;

    volume = map(mouseY, faderTop, faderBottom, 1, 0);
    volume = constrain(volume, 0, 1);
     oscManager.setVolume(0, volume);
  }
}
