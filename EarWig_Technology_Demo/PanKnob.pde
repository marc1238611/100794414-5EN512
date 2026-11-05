class PanKnob {
  
  //Position and size
 float x;          
 float y;
 float knobSize;
 
  // Pan value
 float pan = 0.0;    // Pan value: -1 = left, 0 = centre, +1 = right
 
 
boolean dragging = false;

 
 //OSC 
 int trackNumber;
 OSCManager oscManager;
 
 PanKnob(float x, float y, float knobSize, int trackNumber, OSCManager oscManager) {
   this.x = x;
   this.y = y;
   this.knobSize = knobSize;
   this.trackNumber = trackNumber;
   this.oscManager = oscManager;
 }
 
 //KNOB
 void display(){
  noStroke();
  fill(10, 14, 18);
  ellipse(x, y, knobSize * 2, knobSize * 2);
  
 
  
  float angle = map(pan, -1, 1, radians(135), radians(405));
  
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
  pan = map(mouseX, x - knobSize, x + knobSize, -100, 100);
  pan = constrain(pan, -100, 100);

       oscManager.setPan(trackNumber, pan);
  }
}


//stop mouse dragging 
void mouseReleased() {
  dragging = false;
}
}
