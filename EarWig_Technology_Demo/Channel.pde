class Channel {
  int TrackNumber;
  float x;
  float y;
  float w;
  float h;
  
  float volume = 0.75;
  float pan = 0.0;
  
  boolean solo = false;
  
  Channel(int TrackNumber, float x, float y, float w, float h) {
    this.TrackNumber = TrackNumber;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h; }
    
    void display() {
      fill(40, 44, 52);
      stroke(90);
      rect(x,y,w,h,6);
      
      fill(255);
      textAlign(CENTER,CENTER);
      textSize(14);
      text("Track" + TrackNumber,
     x + w / 2, y+20);
     
    fill(200);
    textSize(11);
    text("VOLUME", x + w / 2, y + 45);
    
    float faderX = x+ w /2;
    float faderTop = y +65;
    float faderBottom = y + h - 75;
    stroke(150);
    line(faderX, faderTop, faderX, faderBottom);
    
    float faderY = map(volume, 0, 1, faderBottom, faderTop);
    
    stroke(230);
    fill(220);
    rectMode(CENTER);
    rect(faderX, faderY, w*0.55, 9, 3);
    rectMode(CORNER);
    
    
    fill(200);
    text("PAN", x + w /2, y + h -53);
    
   fill(255);
   text(nf(pan,1,2), x + w / 2, y+h -36);
   
   if (solo) {
     fill (190, 50, 50);}
     else{ fill(75, 80, 90);
     }
     
    noStroke();
    rect(x+10, y+h-27, w-20, 20, 4);
    
    fill(255);
    textSize(11);
    
    }
}
   
   
   
    
    
    
