class vuL {
  
float vumasterX = 915;  // Horizontal position


int maxHeight = 100;
int numtracks = 4; 

float[] vuL = new float[100]; //allow up to 100 tracks 

float[] vuR = new float[100]; //allow up to 100 tracks 



 

String addr; 

void oscEvent(OscMessage theOscMessage)  

{ 

 

    //store full OSC address 

    addr = theOscMessage.addrPattern(); 

    float oscfl=0.0; 

    //we're after a float type number, if it is one, grab it 

    if(theOscMessage.checkTypetag("f")) 

      oscfl = theOscMessage.get(0).floatValue(); 

    else //if it isn't, print the address in console 

      println(addr); 

       

    String[] adarray = split(addr,"/"); 

    int trnum=0; 

    //ALWAYS check length of array to check that there is  

    //something to compare.  Exception caused otherwise. 

    if(adarray.length>1 && adarray[1].equals("track")) 

    { 

        if(adarray.length>2)  

          trnum = int(adarray[2]); 

        if(adarray.length>3 && adarray[3].equals("vu")) 

        { 

          if(adarray.length>4 && adarray[4].equals("L")) //sometimes  

          { 

            vuL[trnum] = oscfl; 

          } 

          else if(adarray.length>4 && adarray[4].equals("R")) 

          { 

            vuR[trnum] = theOscMessage.get(0).floatValue(); 

          } 

        }     

    } 

    //catch MASTER VU data 

    if(adarray.length>1 && adarray[1].equals("master")) 

    { 

      if(adarray.length>2 && adarray[2].equals("vu")) 

      { 

        if(adarray.length>3 && adarray[3].equals("L")) 

          vuL[0] = theOscMessage.get(0).floatValue(); 

        else if(adarray.length>3 && adarray[3].equals("R")) 

          vuR[0] = theOscMessage.get(0).floatValue(); 

      } 

    } 

} 

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



 
  if (meterHeightR >= maxHeight) {
  fill(255,0, 0);  // Red = clipping
} else {
  fill(0,255,0);
  
}
if (meterHeightL >= maxHeight) {
  fill(255,0,0);  // Red = clipping
} else {
  fill(0,255,0);
}
  rect(x, 350 - meterHeightL,15, meterHeightL);
  
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
  if (masterHeightL >= 95) {
  fill(255, 0, 0);
} else {
  fill(0, 255, 0);
}
rect(vumasterX, 350 - masterHeightL, 15, masterHeightL);


//mastervuR
if (masterHeightR >= 95) {
  fill(255, 0, 0);
} else {
  fill(0, 255, 0);
}
rect(vumasterX + 25, 350 - masterHeightR, 15, masterHeightR);
}
}
