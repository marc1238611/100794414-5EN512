//Stores the incoming left and right VU levels for each channels and 
//then draws a pair of meters for each one
class vuL {
  
float vumasterX = 915;  // Horizontal position


int maxHeight = 100;
int numtracks = 4; 
//array stores the most recent level for each channel. 
//0 is reserved for the master channel and track numbers are stored at their track number.
float[] vuL = new float[5]; 

float[] vuR = new float[5];  



 

String addr; 
//Reads the OSC address to identify the track or master and left for right channel.
//Then stores the received level for the next drawing frame
void oscEvent(OscMessage theOscMessage)  

{ 

 


    addr = theOscMessage.addrPattern(); 

    float oscfl=0.0; 

if (theOscMessage.checkTypetag("f")) {
  oscfl = theOscMessage.get(0).floatValue();
} else {
  println(addr);
  return;
}

       

    String[] adarray = split(addr,"/"); 

    int trnum=0; 



    if(adarray.length>1 && adarray[1].equals("track")) 

    { 

        if(adarray.length>2)  

          trnum = int(adarray[2]); 

    if (trnum < 1 || trnum > numtracks) {
  return;
}
        if(adarray.length>3 && adarray[3].equals("vu")) 

        { 

          if(adarray.length>4 && adarray[4].equals("L")) //sometimes  

          { 

            vuL[trnum] = oscfl; 

          } 

          else if(adarray.length>4 && adarray[4].equals("R")) 

          { 

            vuR[trnum] = oscfl;

          } 

        }     

    } 

//Master VU meter

    if(adarray.length>1 && adarray[1].equals("master")) 

    { 

      if(adarray.length>2 && adarray[2].equals("vu")) 

      { 

        if(adarray.length>3 && adarray[3].equals("L")) 

          vuL[0] = oscfl; 

        else if(adarray.length>3 && adarray[3].equals("R")) 

          vuR[0] = oscfl; 

      } 

    } 

} 
//Draws stereo track meters and the master VU meter, scales levels to the height, limits them to the display range and
//Changes the color of the VU to red when clipping
void display() 

{ 

noFill();
stroke(180);
strokeWeight(1);

rect(vumasterX, 250, 15, 100);       // Left  master meter outline
rect(vumasterX + 25, 250, 15, 100);  // Right master meter outline


stroke(40, 44, 52);
  strokeWeight(1); 

  for (int i = 1; i <= numtracks ; i++){
    float x = -45+i*75;
    
    noFill();
stroke(180);
strokeWeight(1);

rect(x, 250, 15, 100);       // Left meter outline
rect(x + 25, 250, 15, 100); // Right meter outline

    
    
    float meterHeightL = constrain(vuL[i],0,1)*100;
    float meterHeightR = constrain(vuR[i],0,1)*100;
    
noFill();
stroke(180);
strokeWeight(1);

//Left VU
if (meterHeightL >= maxHeight) {
  fill(255,0,0);  // Red = clipping
} else {
  fill(0,255,0);
}
   rect(x, 350 - meterHeightL,15, meterHeightL);


   //Right VU
  if (meterHeightR >= maxHeight) {
  fill(255,0, 0);  // Red = clipping
} else {
  fill(0,255,0);
  
}
rect(x +25, 350 - meterHeightR, 15, meterHeightR) ;
  }
  
  float masterHeightL = constrain(vuL[0], 0, 1) * 100;
    float masterHeightR = constrain(vuR[0], 0, 1) * 100;

  //mastervuL
  if (masterHeightL >= maxHeight) {
  fill(255, 0, 0);
} else {
  fill(0, 255, 0);
}
rect(vumasterX, 350 - masterHeightL, 15, masterHeightL);


//mastervuR
if (masterHeightR >= maxHeight) {
  fill(255, 0, 0);
} else {
  fill(0, 255, 0);
}
rect(vumasterX + 25, 350 - masterHeightR, 15, masterHeightR);
}
}
