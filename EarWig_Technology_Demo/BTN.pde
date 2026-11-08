class Button {

  float x;
  float y;
  float buttonW = 80;
  float buttonH = 40;

  boolean active = false;
  boolean isHeld = false;

  String label;
  String oscAddress;

  int normalColour = color(65);
  int activeColour = color(0, 180, 100);
int repeatDelay = 150; // milliseconds between repeats
int lastRepeatTime = 0;

  OSCManager oscManager;

  Button(float x, float y, String label, String oscAddress, OSCManager oscManager)
  {
    this.x = x;
    this.y = y;
    this.label = label;
    this.oscAddress = oscAddress;
    this.oscManager = oscManager;
  }

  void display() {

    if (active) {
      fill(activeColour);
    } else {
      fill(normalColour);
    }

    stroke(220);
    rect(x, y, buttonW, buttonH, 8);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text(label, x + buttonW/2, y + buttonH/2);
  }

  void mousePressed() {
    if (mouseX >= x && mouseX <= x + buttonW &&
      mouseY >= y && mouseY <= y + buttonH) {


      //Forward and Rewind Button
      if (label.equals("REWIND") || label.equals("FORWARD")) {
        isHeld = true;
        active = true;
        activeColour = color(200, 0, 0);

        oscManager.sendTrigger(oscAddress);
        return;
      }

      //Other Transport Controls
      if (label.equals("PLAY")) {
        activeColour = color(0, 200, 0);
      } else if (label.equals("STOP")) {
        activeColour = color(220, 0, 0);
      } else if (label.equals("PAUSE")) {
        activeColour = color(230, 180, 0);
      } else if (label.equals("RECORD")) {
        activeColour = color(200, 0, 0);
      } else if (label.equals("FORWARD")) {
        activeColour = color(200, 0, 0);
      } else if (label.equals("/rewind")) {
        activeColour = color(200, 0, 0);
      }
      active = !active;

      oscManager.sendTrigger(oscAddress);
    }
  }
  void repeatAction() {
    if (isHeld &&  millis() - lastRepeatTime >= repeatDelay) {
       oscManager.sendTrigger(oscAddress);
         lastRepeatTime = millis();
    }
  }
  
  void mouseReleased () {
  if (isHeld) {
    isHeld = false;
    active = false;
  }
}
}
