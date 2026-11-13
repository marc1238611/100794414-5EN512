//EARWIG Technology OSC mixer Demo for REAPER
//This sketch connects to Reaper using OSC and lets the user 
//Control the channels volumes, pan, transport buttons and ReaEQ settings from a Processing UI

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
int colEQ1 = 670;
  int colEQ2 = 720;      
  int colEQ3 = 770;
  int colEQ4 = 820;


  int buttonW = 55;
  int buttonH = 20;

void setup() {
  size(1080, 720);
  pixelDensity(2);

  surface.setTitle("REAPER OSC Mixer");

//Connects to the REAPER instance over OSC
//Incoming messages update the UI, and outoging messages send control changes such as volume, pan, mute and transport controls.
  oscManager = new OSCManager(this, "127.0.0.1", 8000);        //creates OSC manager




  vuMeters = new vuL();

  //Creates the mixer channel strips 
  //Each channel represents one track in reaper and has volume, solo, pan and mute controls in the visual mixer.
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
//TRANSPORT CONTROLS
//the transport controls map directly to Reaper actions.
//these button ID's are specific to Reapers Default OSC mappings and allow the Ui to trigger 
//rewind, forward, play, pause and record functions.
  String[] labels = {
    "REWIND", "FORWARD", "PLAY", "STOP", "RECORD",
  };
  String[] addresses = {
    "/action/40084", "/action/40085", "/play", "/stop", "/record"
  };
  for (int i = 0; i < transportButtons.length; i++) {
    transportButtons[i] = new Button(980, 10+i*90, labels[i], addresses[i], oscManager);
  };

  //Reaper treats play and pause as separate OSC addresses.
  //the Play/Pause button is configured to toggle between play and pause and 
  //uses a separate pause command when pause is active.
  transportButtons[2].isPlayPauseButton = true;
transportButtons[2].pauseOscAddress = "/pause";



//MASTER CHANNEL
//Represents the master track in reaper and has volume, solo, pan and mute controls in the visual mixer.
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





    //EQ CONTROLS
//EQ controls are grouped by channel and band.
//The UI allows the user to edit the selected tracks EQ settings
//without having to recreate the entire EQ panel for each channel.

  //EQ knob positioning
int rowEQstart = 150; //EQ Knob rows start height

  //EQ knob settings
  //EQ knob values are defined in ranges compatible with Reaper
  //Gain is in dB, Frequency is in Hz, and Octave is a multiplier used to determine the EQ filter band response.
  String[] eqLabels = {"GAIN", "FREQ", "OCT"};
  float[] minValues = {0, 20, 0.01};
  float[] maxValues = {12, 24000, 4.00};
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

  //Each channel gets a button to turn the EQ on or off 
  //aswell as a button to select the channel to change its EQ.
  for (int i = 0;i<eqonButtons.length; i++) {
    
    //EQ on/off button
    eqonButtons[i] = new Button(channels[i].x + 10, channels[i].y + 150, "EQ", i+1, oscManager);
    eqonButtons[i].buttonW = buttonW;
  eqonButtons[i].buttonH = buttonH;

//EQ select button
eqSelectButtons[i] = new  Button(channels[i].x + 10, channels[i].y + 100, "SEL", i+1, oscManager);
  eqSelectButtons[i].buttonW = buttonW;  
eqSelectButtons[i].buttonH = buttonH;  
}
oscManager.startListening(this);
oscManager.sendInt("/device/track/count", channels.length);
oscManager.sendInt("/device/track/select", selectedEQTrack);
}

//Draws the full Mixer UI each frame.
//This includes track strips, transport controls aswell as EQ controls.
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

  int bandLabel = 120; 
textSize(12);
text("BAND 1", colEQ1, bandLabel);
text("BAND 2", colEQ2, bandLabel);
text("BAND 3", colEQ3, bandLabel);
text("BAND 4", colEQ4, bandLabel);


  for (Button button : eqonButtons) {
  button.display();
}
for (Button button : eqSelectButtons) {
  button.display();
}
}

//Forward mouse events into the individual features
//Each widget handles its own hit testing and value updates, keeping the interaciton logic modular and easier to maintain.
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




//Handles incoming Messages from REAPER
//and updates these parameters in the UI to sync with changes which happen in Reaper

void oscEvent(OscMessage theOscMessage) {

  vuMeters.oscEvent(theOscMessage);

String address = theOscMessage.addrPattern();

println("OSC IN: " + address);

//Updates per track values from REAPERs OSC Messages
//Each address corresponds to a specific track property and is mapped to the appropriate UI element.
 for (int i = 0; i < channels.length; i++) {
    if (address.equals("/track/" + (i + 1) + "/volume") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].volume =
        constrain(theOscMessage.get(0).floatValue(), 0, 1);
        }
         if (address.equals("/track/" + (i + 1) + "/mute") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].muteButton.active = theOscMessage.get(0).floatValue() != 0;
    }

    if (address.equals("/track/" + (i + 1) + "/solo") &&
        theOscMessage.checkTypetag("f")) {
      channels[i].soloButton.active = theOscMessage.get(0).floatValue() != 0;
    }
     if (address.equals("/track/" + (i + 1) + "/pan") &&
        theOscMessage.checkTypetag("f")) {
      panKnobs[i].pan = map(theOscMessage.get(0).floatValue(), 0, 1, -1, 1);
    }


      }

      //Master Channel
      //Updates the Master channel from the same OSC protocol
      //the Master channel is treated separately from the normal channels as it represents the overall mix rather than a single input.
      if (address.equals("/master/volume") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].volume =
    constrain(theOscMessage.get(0).floatValue(), 0, 1);
}

if (address.equals("/track/mute/toggle") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].muteButton.active =
  theOscMessage.get(0).floatValue() != 0;
}

if (address.equals("/master/solo") &&
    theOscMessage.checkTypetag("f")) {
  MasterChannels[0].soloButton.active =
  theOscMessage.get(0).floatValue() != 0;
}

if (address.equals("/master/pan") &&
    theOscMessage.checkTypetag("f")) {
  masterPanKnob.pan =
    map(theOscMessage.get(0).floatValue(), 0, 1, -1, 1);
}
    
      
//EQ stuff
//EQ bypass state is sent as a normalized float from REAPER
//that float is converted into the buttons active state so that the UI reflects whether EQ is enabled or
for (int i = 0; i < channels.length; i++) {
 if (address.equals("/track/" + (i + 1) + "/fxeq/bypass") &&
    theOscMessage.checkTypetag("f")) {
  eqonButtons[i].active = theOscMessage.get(0).floatValue() != 0;
}

    }
    updateEqKnobFromReaper(theOscMessage);
  }
  void updateEqKnobFromReaper(OscMessage msg) {
    println("Address received: " + msg.addrPattern());
  String[] parts = split(msg.addrPattern().substring(1), '/');
if (!msg.checkTypetag("f")) return;
int track;
  int band;
  String parameter;

  if (parts.length != 7 ||
      !parts[0].equals("track") ||
      !parts[2].equals("fxeq") ||
      !parts[3].equals("band")){
  track = int(parts[1]);
    band = int(parts[4]);
    parameter = parts[5] + "/" + parts[6];
  }

  else if (parts.length == 5 &&
           parts[0].equals("fxeq") &&
           parts[1].equals("band")) {
    track = selectedEQTrack;
    band = int(parts[2]);
 parameter = parts[3] + "/" + parts[4];
  } else {
    return;
  }

  if (track != selectedEQTrack || band < 1 || band > 4) return;

  Knob[][] bands = {eqBand1, eqBand2, eqBand3, eqBand4};
  Knob knob;


if (parameter.equals("gain/db")) {
    knob = bands[band - 1][0];
  } else if (parameter.equals("freq/hz")) {
    knob = bands[band - 1][1];
  } else if (parameter.equals("q/oct")) {
    knob = bands[band - 1][2];
  } else {
    return;
  }

  knob.pan = constrain(
    msg.get(0).floatValue(),
    knob.minValue,
    knob.maxValue
  );
}
