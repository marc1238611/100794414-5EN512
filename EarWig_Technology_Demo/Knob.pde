class Knob {
  
  //Position and size
 float x;          
 float y;
 float knobSize;
 
  // Pan value
 float pan = 0.0;    // Pan value: -1 = left, 0 = centre, +1 = right
 String controlType = "PAN";
float minValue = -1;
float maxValue = 1;
String label = "PAN";
 
 
 
boolean dragging = false;
 //OSC 
 int trackNumber;
 OSCManager oscManager;
 
 Knob(float x, float y, float knobSize, int trackNumber, OSCManager oscManager) {
   this.x = x;
   this.y = y;
   this.knobSize = knobSize;
   this.trackNumber = trackNumber;
   this.oscManager = oscManager;
 }
 
 Knob(float x, float y, float knobSize, String label, float minValue, float maxValue, float startValue, int trackNumber, OSCManager oscManager) {
   this.x = x;
   this.y = y;
   this.knobSize = knobSize;
   this.label = label;
   this.minValue = minValue;
   this.maxValue = maxValue;
   this.pan = startValue;
   this.trackNumber = trackNumber;
   this.oscManager = oscManager;
    this.controlType = "EQ";
}
 
 
 void display(){
   
   //Pan Knob
   
  noStroke();
  fill(10, 14, 18);
  ellipse(x, y, knobSize * 2, knobSize * 2);
  
 
  
  float angle = map(pan, minValue, maxValue, radians(135), radians(405));
  
  //position indicator
  
 

    float endX = x + cos(angle) * knobSize;
    float endY = y + sin(angle) * knobSize;
 
 stroke(25, 190, 170);
    strokeWeight(3);
    line(x, y, endX, endY);
    
   //Display  PAN label and current value 
   
   
   fill(230);
   noStroke();
   textAlign(CENTER);
   textSize(10);
  

    text(nf(pan, 1, 2), x, y + knobSize + 29);
    
    fill(255);
textAlign(CENTER, CENTER);
textSize(13);
text("PAN", x, y + 27);
  }

//check whether mouse is clicked on pan knob
void mousePressed(){
  if (dist(mouseX, mouseY, x, y) <= knobSize *1) {
    dragging = true;
  
  }
}

//update pan value while dragging
void mouseDragged() {
  if(dragging) {
  pan -= (mouseY - pmouseY) *
  ((maxValue - minValue)/150.0);
  
   
    
    pan = constrain(pan, minValue, maxValue);
    

  if (controlType.equals("PAN")) {
    float reaperPan = (pan + 1.0) / 2.0;    
      oscManager.setPan(trackNumber, reaperPan);
    }


  }
    
}


//stop mouse dragging 
void mouseReleased() {
  dragging = false;
}
}
