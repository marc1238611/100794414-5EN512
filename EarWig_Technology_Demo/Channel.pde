//Represents one Reaper track in the fader, it draws the fader, mute and solo controls
//and sends user changes to Reaper through OSC

class Channel {
  int CHnumber;
  float x;
  float y;
  float w;
  float h;
  float volume = 0.75;

  OSCManager oscManager;              // OSC manager

  boolean draggingFader = false;
  boolean solo = false;
  boolean mute = false;

Button muteButton;
Button soloButton;

//Stores the channels track number, screen position and OSC connection
//Creates its solo and mute buttons at a position relaitve to the channel strip.
  Channel(int CHnumber, float x, float y, float w, float h,
    OSCManager oscManager) {
    this.CHnumber = CHnumber;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.oscManager = oscManager;
    
    muteButton = new Button(x + 10, y + 430, w - 20, 20,
                        "MUTE", "MUTE", CHnumber, oscManager);
soloButton = new Button(x + 10, y + 460, w - 20, 20,
                        "SOLO", "SOLO", CHnumber, oscManager);
  }

  //Draws the channel strip and fader. 
  //Stores the mapped 0-1 volume to the faders screen position
  //then draws the mute and solo buttons
  void display() {
    // Draw channel background
    fill(40, 44, 52);
    stroke(90);
    rect(x, y, w, 720);

    // Channel title
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(CHnumber, x + w / 2, y + 700);


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
    muteButton.display();
soloButton.display();


  }

  //Forwards the mouse click to the mute and solo buttons 
  //and starts dragging the fader if the mouse was pressed
  //within the fader boundary.
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

//Converts the mouse's vertical position into a volume value and clamp its to 0-1 and sends the updated value to Reaper via OSC
  void updateVolume() {
    float faderTop = y + 500;
    float faderBottom = y + 690;

    volume = map(mouseY, faderTop, faderBottom, 1, 0);
    volume = constrain(volume, 0, 1);
    oscManager.setVolume(CHnumber, volume);

    
  }
  
}
