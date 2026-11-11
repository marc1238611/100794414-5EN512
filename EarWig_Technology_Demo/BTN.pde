class Button {
  
  float x;
  float y;
  float buttonW = 80;
  float buttonH = 40;
  float w;
  float h;
  boolean active = false;
  boolean isEQButton = false;  
   int trackNumber = -1;
  String label;
  String oscAddress;
  
  int normalColour = color(65);
  int activeColour = color(0, 180, 100);
  
  int buttonGroup = 0;

boolean isHeld = false;
int repeatDelay = 150; // milliseconds between repeats
int lastRepeatTime = 0;
boolean isPlayPauseButton = false;
String pauseOscAddress;

Button[] groupButtons;


  
 OSCManager oscManager;
 
  Button(float x, float y, String label, String oscAddress, OSCManager oscManager)
  {
      this.x = x;
    this.y = y;
    this.label = label;
    this.oscAddress = oscAddress;
    this.oscManager = oscManager;  
  }
  
  
  //EQ on/off Button
  Button(float x, float y, String label,
       int trackNumber, OSCManager oscManager) {
         
         this.x = x;
         this.y = y;
         this.label = label;
         this.trackNumber = trackNumber;
         this.oscManager = oscManager;
    this.isEQButton = true;
  this.oscAddress = "";
       }
       
     
  void display() {
    
 
 if (isEQButton && label.equals("SEL")) {
  fill(trackNumber == selectedEQTrack ? activeColour : normalColour);
} else if (active) {
  fill(activeColour);
} else {
  fill(normalColour);


}

   noStroke();
    rect(x, y, buttonW, buttonH, 4);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text(label, x + buttonW/2, y + buttonH/2);
    
  }
       void mousePressed() {
    

    if (mouseX >= x && mouseX <= x + buttonW &&
    mouseY >= y && mouseY <= y + buttonH) {
        if (label.equals("REWIND") || label.equals("FORWARD")) {
      isHeld = true;
      active = true;
      lastRepeatTime = millis();
      oscManager.sendTrigger(oscAddress);
      return;
    }
      if (isEQButton) {
  if (label.equals("SEL")){
        selectedEQTrack = trackNumber;
        for (Knob knob : eqBand1) knob.trackNumber = trackNumber;
for (Knob knob : eqBand2) knob.trackNumber = trackNumber;
for (Knob knob : eqBand3) knob.trackNumber = trackNumber;
for (Knob knob : eqBand4) knob.trackNumber = trackNumber;
        if (groupButtons !=null) {
          for (int i = 0; i < groupButtons.length; i++) {
          groupButtons[i].active =
          (groupButtons[i] == this);
        }
  }
  println("Selected EQ track: " + selectedEQTrack);
  
 
} else if (label.equals("EQ")) {
     active = !active;
    oscManager.setEQEnabled(trackNumber, !active);
            println("EQ button toggled for track: " + trackNumber);

    }
    
    return;
      }
      else if (isPlayPauseButton) {
  if (active) {
    oscManager.sendTrigger(pauseOscAddress);
    label = "PLAY";
    active = false;
  } else {
    oscManager.sendTrigger(oscAddress); // "/play"
    label = "PAUSE";
    active = true;
    activeColour = color(0, 200, 0);
  }
  return;
}
else { if (label.equals("PLAY")) {
  activeColour = color(0, 200, 0);
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
  
  void setGroup(Button[] buttons) {
  groupButtons = buttons;
}
  void repeatAction() {
  if (isHeld && millis() - lastRepeatTime >= repeatDelay) {
    oscManager.sendTrigger(oscAddress);
    lastRepeatTime = millis();
  }
  }

void mouseReleased() {
  isHeld = false;
  active = false;
}
}
