class Button {
  
  float x;
  float y;
  float buttonW = 80;
  float buttonH = 40;
  
  boolean active = false;
  
  String label;
  String oscAddress;
  
  int normalColour = color(65);
  int activeColour = color(0, 180, 100);
  
 
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
      if (label.equals("PLAY")) {
  activeColour = color(0, 200, 0);
}
else if (label.equals("STOP")) {
  activeColour = color(220, 0, 0);
}
else if (label.equals("PAUSE")) {
  activeColour = color(230,180,0);
}
else if (label.equals("RECORD")) {
  activeColour = color(200, 0, 0);
}
else if (label.equals("FORWARD")) {
  activeColour = color(200, 0, 0);
}
      active = !active;
      
      oscManager.sendTrigger(oscAddress);
    }
  }
}
