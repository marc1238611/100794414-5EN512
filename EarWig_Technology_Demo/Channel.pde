
class Channel {
  int CHnumber;
  float x;
  float y;
  float w;
  float h;

  OSCManager oscManager;              // OSC manager


  float volume = 0.75;
  float pan = 0.0;

  boolean draggingFader = false;
  boolean solo = false;

  Channel(int CHnumber, float x, float y, float w, float h,
        OSCManager oscManager) {
    this.CHnumber = CHnumber;
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
    rect(x, y, w, h);

    // Channel title
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("Channel " + CHnumber, x + w / 2, y + 20);

    // Volume label
    fill(200);
    textSize(11);
    text("VOLUME", x + w / 2, y + 45);

    // Draw fader track
    float faderX = x + w / 2;
    float faderTop = y + 65;
    float faderBottom = y + h - 75;

    stroke(150);
    line(faderX, faderTop, faderX, faderBottom);

    // Draw fader handle
    float faderY = map(volume, 0, 1, faderBottom, faderTop);

    stroke(230);
    fill(220);
    rectMode(CENTER);
    rect(faderX, faderY, w * 0.55, 9, 3);
    rectMode(CORNER);

    // Pan display
    fill(200);
    text("PAN", x + w / 2, y + h - 53);

    fill(255);
    text(nf(pan, 1, 2), x + w / 2, y + h - 36);

    // Solo button
    float buttonX = x + 10;
    float buttonY = y + h - 27;
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
  }

  void mousePressed() {
    // Check Solo button
    float buttonX = x + 10;
    float buttonY = y + h - 27;
    float buttonW = w - 20;
    float buttonH = 20;

    if (mouseX >= buttonX &&
        mouseX <= buttonX + buttonW &&
        mouseY >= buttonY &&
        mouseY <= buttonY + buttonH) {
      solo = !solo;
      return;
    }

    // Check fader area
    float faderX = x + w / 2;
    float faderTop = y + 65;
    float faderBottom = y + h - 75;

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
    float faderTop = y + 65;
    float faderBottom = y + h - 75;

    volume = map(mouseY, faderTop, faderBottom, 1, 0);
    volume = constrain(volume, 0, 1);
     oscManager.setVolume(CHnumber, volume);
  }
}
