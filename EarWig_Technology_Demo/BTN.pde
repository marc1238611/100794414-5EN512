class Button {
  
  float x;
  float y;
  float buttonW = 80;
  float buttonH = 40;
  
  String label;
  String oscAddress;
 
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
    fill(65);
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
      
      oscManager.sendTrigger(oscAddress);
    }
  }
}
