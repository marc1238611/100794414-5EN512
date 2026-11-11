import oscP5.*;
import netP5.*;

OSCManager oscManager;                        //OSC communication manager
vuL vuMeters;

Channel[] channels = new Channel[4];
MasterChannel[] MasterChannels = new MasterChannel[1];
Knob[] panKnobs = new Knob[4];
Knob masterPanKnob;
Button[] transportButtons = new Button[5];


Knob[] eqBand1 = new Knob[3];
Knob[] eqBand2 = new Knob[3];
Knob[] eqBand3 = new Knob[3];
Knob[] eqBand4 = new Knob[3];
Button[] eqonButtons = new Button[4];
Button[] eqSelectButtons = new Button[4];

int selectedEQTrack = 1;




void setup() {
  size(1080, 720);
  pixelDensity(2);

  surface.setTitle("REAPER OSC Mixer");

  oscManager = new OSCManager(this, "127.0.0.1", 8000);        //creates OSC manager




  vuMeters = new vuL();
  for (int i = 0; i < channels.length; i++) {
    float stripWidth = 75;
    float spacing = 1;
    float startX = 10 + i * (stripWidth + spacing);


    for (int j = 0; j < panKnobs.length; j++) {
      float x =  10 + j * (stripWidth + spacing) + stripWidth / 2;
      float y = 370;

      panKnobs[j] = new Knob(
        x, y, 15, j + 1, oscManager
        );
    }

    channels[i] = new Channel(
      i + 1, startX, 00, stripWidth, 320, oscManager
      );
  }

  String[] labels = {
    "REWIND", "FORWARD", "PLAY", "STOP", "RECORD",
  };
  String[] addresses = {
    "/action/40084", "/action/40085", "/play", "/stop", "/record"
  };
  for (int i = 0; i < transportButtons.length; i++) {
    transportButtons[i] = new Button(980, 10+i*90, labels[i], addresses[i], oscManager);
  };
  transportButtons[2].isPlayPauseButton = true;
transportButtons[2].pauseOscAddress = "/pause";

  //Master channel


  for (int i = 0; i < MasterChannels.length; i++) {
    float stripWidth = 75;
    float spacing = 1;
    float startX = 900 + i * (stripWidth + spacing);


    MasterChannels[i] = new MasterChannel(0,
      startX, 0, stripWidth, 320, oscManager
      );
  }
  masterPanKnob = new Knob(
    937.5, 370, 15, 0, oscManager
    );




  //EQ knob positioning
  //EQ Knob Column x coord
  int colEQ1 = 670;
  int colEQ2 = 720;      
  int colEQ3 = 770;
  int colEQ4 = 820;
int rowEQstart = 150; //EQ Knob rows height


  //EQ knob settings

  String[] eqLabels = {"GAIN", "FREQ", "OCT"};
  float[] minValues = {-30, 20, 0.01};
  float[] maxValues = {30, 20000, 4.00};
  float[] starteqValues = {0, 1000, 1};

  //EQ Band 1

  for (int control = 0; control < 3; control++) {
    eqBand1[control] = new Knob(
      colEQ1, rowEQstart + control * 70, 15,
      eqLabels[control], minValues[control],
      maxValues[control], starteqValues[control],
      selectedEQTrack, oscManager
      );
    eqBand1[control].eqBand = 1;
  }
  //EQ Band 2

  for (int control = 0; control < 3; control++) {
    eqBand2[control] = new Knob(
      colEQ2, rowEQstart + control * 70, 15,
      eqLabels[control], minValues[control],
      maxValues[control], starteqValues[control],
      selectedEQTrack, oscManager
      );
    eqBand2[control].eqBand = 2;
  }

  //EQ Band 3
  for (int control = 0; control < 3; control++) {
    eqBand3[control] = new Knob(
      colEQ3, rowEQstart + control * 70, 15,
      eqLabels[control], minValues[control],
      maxValues[control], starteqValues[control],
      selectedEQTrack, oscManager
      );
    eqBand3[control].eqBand = 3;
  }

  //EQ Band 4

  for (int control = 0; control < 3; control++) {
    eqBand4[control] = new Knob(
      colEQ4, rowEQstart + control * 70, 15,
      eqLabels[control], minValues[control],
      maxValues[control], starteqValues[control],
      selectedEQTrack, oscManager
      );
    eqBand4[control].eqBand = 4;
  }
  for (int i = 0;i<eqonButtons.length; i++) {
    
    //EQ on/off button
    eqonButtons[i] = new Button(channels[i].x + 10, channels[i].y + 150, "EQ", i+1, oscManager);
    eqonButtons[i].buttonW = 55;
  eqonButtons[i].buttonH = 20;


//EQ select button
eqSelectButtons[i] = new  Button(channels[i].x + 10, channels[i].y + 100, "SEL", i+1, oscManager);
    
  eqSelectButtons[i].buttonW = 55;  // Width
eqSelectButtons[i].buttonH = 20;  // Height

}



}




void draw() {
  background(25);

  for (Channel channel : channels) {
    channel.display();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.display();
  }
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].display();
  }

  for (Button button : transportButtons) {
    button.display();
  }
 transportButtons[0].repeatAction(); // REWIND
transportButtons[1].repeatAction(); // FORWARD
  vuMeters.display();
  masterPanKnob.display();

  //EQ
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("CHANNEL " + selectedEQTrack + " EQ", 740, 100);


  for (Knob knob : eqBand1) knob.display();
  for (Knob knob : eqBand2) knob.display();
  for (Knob knob : eqBand3) knob.display();
  for (Knob knob : eqBand4) knob.display();
  for (Button button : eqonButtons) {
  button.display();
}
for (Button button : eqSelectButtons) {
  button.display();
}
}

void mousePressed() {

  for (int i = 0; i < channels.length; i++) {
    channels[i].mousePressed();
  }
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mousePressed();
  }
  for (Button button : transportButtons) {
    button.mousePressed();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.mousePressed();
  }
  masterPanKnob.mousePressed();
  
  //EQ stuff
  
  for (Knob knob : eqBand1) knob.mousePressed();
for (Knob knob : eqBand2) knob.mousePressed();
for (Knob knob : eqBand3) knob.mousePressed();
for (Knob knob : eqBand4) knob.mousePressed();
  for (Button button : eqonButtons) {
  button.mousePressed();
}
for (Button button : eqSelectButtons) {
  button.mousePressed();
}
}

void mouseDragged() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();
  }
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mouseDragged();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.mouseDragged();
  }
  masterPanKnob.mouseDragged();
  
  for (Knob knob : eqBand1) knob.mouseDragged();
for (Knob knob : eqBand2) knob.mouseDragged();
for (Knob knob : eqBand3) knob.mouseDragged();
for (Knob knob : eqBand4) knob.mouseDragged();
}

void mouseReleased() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseReleased();
  }
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mouseReleased();
  }
  masterPanKnob.mouseReleased();
  
  for (Knob knob : eqBand1) knob.mouseReleased();
for (Knob knob : eqBand2) knob.mouseReleased();
for (Knob knob : eqBand3) knob.mouseReleased();
for (Knob knob : eqBand4) knob.mouseReleased();

transportButtons[0].mouseReleased();
transportButtons[1].mouseReleased();
}






void oscEvent(OscMessage theOscMessage) {

  vuMeters.oscEvent(theOscMessage);

String address = theOscMessage.addrPattern();

println("OSC IN: " + address);

// for my channels
 for (int i = 0; i < channels.length; i++) {
    if (address.equals("/track/" + (i + 1) + "/volume") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].volume =
        constrain(theOscMessage.get(0).floatValue(), 0, 1);
        }
         if (address.equals("/track/" + (i + 1) + "/mute") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].mute = theOscMessage.get(0).floatValue() != 0;
    }

    if (address.equals("/track/" + (i + 1) + "/solo") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].solo = theOscMessage.get(0).floatValue() != 0;
    }
     if (address.equals("/track/" + (i + 1) + "/pan") &&
        theOscMessage.checkTypetag("f")) {
      panKnobs[i].pan = map(theOscMessage.get(0).floatValue(), 0, 1, -1, 1);
    }


      }

      //Master Channel

      if (address.equals("/master/volume") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].volume =
    constrain(theOscMessage.get(0).floatValue(), 0, 1);
}

if (address.equals("/track/mute/toggle") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].masterMute =
    theOscMessage.get(0).floatValue() != 0;
}

if (address.equals("/master/solo") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].solo =
    theOscMessage.get(0).floatValue() != 0;
}

if (address.equals("/master/pan") &&
    theOscMessage.checkTypetag("f")) {
  masterPanKnob.pan =
    map(theOscMessage.get(0).floatValue(), 0, 1, -1, 1);
}
    
      
//EQ stuff
for (int i = 0; i < channels.length; i++) {
 if (address.equals("/track/" + (i + 1) + "/fxeq/bypass") &&
    theOscMessage.checkTypetag("f")) {
  eqonButtons[i].active = theOscMessage.get(0).floatValue() != 0;
}

    }
    
  }