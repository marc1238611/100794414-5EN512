//A reusable UI button for transport controls, and per track controls.
class Button {
  
  float x;
  float y;
  float buttonW = 80;
  float buttonH = 40;
  float w;
  float h;
  int trackNumber = -1;
  int normalColour = color(65);
  int activeColour = color(0, 180, 100);
  int red = color(255, 0, 0);
  int buttonGroup = 0;
  int repeatDelay = 150; 
  int lastRepeatTime = 0;
  boolean isHeld = false;
  boolean isPlayPauseButton = false;
  boolean active = false;
  boolean isEQButton = false;  
  String pauseOscAddress;
  String label;
  String oscAddress;
  String buttonAction = "OSC";

  Button[] groupButtons;


  
 OSCManager oscManager;
 
//Creates the transporty controls and sends the configured osc address 
//when the button with the corressponding label is pressed.

  Button(float x, float y, String label, String oscAddress, OSCManager oscManager)
  {
      this.x = x;
    this.y = y;
    this.label = label;
    this.oscAddress = oscAddress;
    this.oscManager = oscManager;  
  }
  
//Creates a track mute or solo button and sets its size, track number, action and active color.
  Button(float x, float y, float w, float h,
       String label, String action, int trackNumber,
       OSCManager oscManager) {
  this.x = x;
  this.y = y;
  this.buttonW = w;
  this.buttonH = h;
  this.label = label;
  this.buttonAction = action;
  this.trackNumber = trackNumber;
  this.oscManager = oscManager;

  normalColour = color(75, 80, 90);
  if (action.equals("MUTE")) {
    activeColour = color(red);
  } else {
    activeColour = color(255, 165, 0);
  }
}
  
  //creates an EQ control button. "SEL" selects the trackf or EQ editing, while "EQ" toggles the tracks EQ.
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
       
  //Draws the button and shows its active state. 
  //the selected track's select button is highlighted using selectedEQTrack.
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

  //Responds only when clicked inside the button 
  //then runs the action for that button type.
  void mousePressed() {
    

    if (mouseX >= x && mouseX <= x + buttonW &&
    mouseY >= y && mouseY <= y + buttonH) {

      // Start the first seek command immediately; repeatAction() sends more
      // commands while the button remains held.
        if (label.equals("REWIND") || label.equals("FORWARD")) {
      isHeld = true;
      active = true;
      lastRepeatTime = millis();
      oscManager.sendTrigger(oscAddress);
      return;
    }
      
    //Selects the track for EQ editing
    if (isEQButton) {
  if (label.equals("SEL")){
        selectedEQTrack = trackNumber;
        oscManager.sendInt("/device/track/select", selectedEQTrack);
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
  
 //Toggle EQ bypass for this track and update the buttons active state
} else if (label.equals("EQ")) {
     active = !active;
    oscManager.setEQEnabled(trackNumber, active);
            println("EQ button toggled for track: " + trackNumber);

    }
    
    return;
//Applies mute or solo to the associated track
      } else if (buttonAction.equals("MUTE")) {
  active = !active;
  if (trackNumber == 0) {
    oscManager.setMasterMute(active);
  } else {
    oscManager.setMute(trackNumber, active);
  }
  return;
}
else if (buttonAction.equals("SOLO")) {
  active = !active;
  oscManager.setSolo(trackNumber, active);
  return;
}

//uses the separate play and pause OSC commands 
//while keeping the label and active state in sync with playback
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
  //Stores the Sel buttons so that when one channel is selected
  //The other channel is deselected.
  void setGroup(Button[] buttons) {
  groupButtons = buttons;
}

//Delays the repeat action for if a button is held down
  void repeatAction() {
  if (isHeld && millis() - lastRepeatTime >= repeatDelay) {
    oscManager.sendTrigger(oscAddress);
    lastRepeatTime = millis();
  }
  }
//Clears the active and held states when the mouse is released
void mouseReleased() {
  isHeld = false;
  active = false;
}
}
