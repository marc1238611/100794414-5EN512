// REAPER OSC mixer demo
// Sends OSC control messages to reaper and listens for the feedback
import oscP5.*;                               //imports the OSCP5 library by Andreas Schlegel
import netP5.*;

OSCManager oscManager;                        //OSC communication manager - handles the outgoing OSC commands and incoming feedback
vuL vuMeters;                                 //displays the VU meter for reaper audio levels

Channel[] channels = new Channel[4];                      //Creates 4 channel strips in the mixer UI
MasterChannel[] MasterChannels = new MasterChannel[1];    // Master output Channel strip
Knob[] knobs = new Knob[4];                      //PanKnob and pan function control for each channel
Knob masterPanKnob;                                        //PanKnob and pan function control for the Master channel



Button[] transportButtons = new Button[4];                //Creates the 4 transport buttons

boolean rewinding = false;
boolean fastForwarding = false;




void setup() {
  size(1080, 720);
  surface.setTitle("REAPER OSC Mixer");

  oscManager = new OSCManager(this, "127.0.0.1", 8000);        //creates OSC manager




  vuMeters = new vuL();
  for (int i = 0; i < channels.length; i++) {
    float stripWidth = 75;
    float spacing = 1;
    float startX = 10 + i * (stripWidth + spacing);

<<<<<<< Updated upstream
    for (int j = 0; j < panKnobs.length; j++) {
=======

    for (int j = 0; j < knobs.length; j++) {
>>>>>>> Stashed changes
      float x =  10 + j * (stripWidth + spacing) + stripWidth / 2;
      float y = 370;

      knobs[j] = new Knob(
        x, y, 15, j + 1, oscManager
        );
    }

    channels[i] = new Channel(
      i + 1, startX, 00, stripWidth, 320, oscManager
      );
  }

  String[] labels = {
    "REWIND", "FORWARD", "PLAY", "RECORD",
  };
  String[] addresses = {
    "/action/40084", "/action/40085", "/play", "/record"
  };
  for (int i = 0; i < transportButtons.length; i++) {
    transportButtons[i] = new Button(980, 10+i*90, labels[i], addresses[i], oscManager);
  };

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
}

void draw() {
  background(25);

  for (Channel channel : channels) {
    channel.display();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.display();
  }
  for (int j = 0; j < knobs.length; j++) {
    knobs[j].display();
  }
  
  for (Button button : transportButtons) {
    button.display();
  }
  for (Button button : transportButtons) {
    button.repeatAction();
  }
  vuMeters.display();
  masterPanKnob.display();
  
}
void mousePressed() {

  for (int i = 0; i < channels.length; i++) {
    channels[i].mousePressed();
  }
  for (int j = 0; j < knobs.length; j++) {
    knobs[j].mousePressed();
  }
  for (Button button : transportButtons) {
    button.mousePressed();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.mousePressed();
  }
  masterPanKnob.mousePressed();
}

void mouseDragged() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();
  }
  for (int j = 0; j < knobs.length; j++) {
    knobs[j].mouseDragged();
  }
  for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.mouseDragged();
  }
  masterPanKnob.mouseDragged();
}

void mouseReleased() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseReleased();
  }
  for (int j = 0; j < knobs.length; j++) {
    knobs[j].mouseReleased();
  }
  masterPanKnob.mouseReleased();

 for (MasterChannel masterchannel : MasterChannels) {
    masterchannel.mouseReleased();
 }
 
 for (Button button : transportButtons) {
  button.mouseReleased();
}
}




void oscEvent(OscMessage theOscMessage) {
  vuMeters.oscEvent(theOscMessage);

  String address = theOscMessage.addrPattern();
  String[] adarray = split(address,"/"); 
    if (
    (theOscMessage.checkTypetag("f") ||
    theOscMessage.checkTypetag("i")) &&
    adarray.length > 3 && adarray[1].equals("track")) {
int trackNumber = int(adarray[2]);
float value = theOscMessage.get(0).floatValue();
if (trackNumber >= 0 && trackNumber <= channels.length) {
 int index = trackNumber - 1;
  String property = adarray[3];

  if (property.equals("volume")) {
    channels[index].volume = constrain(value, 0, 1);
  } else if (property.equals("pan")) {
    panKnobs[index].pan = constrain(value * 2 - 1, -1, 1);
  } else if (property.equals("mute")) {
    channels[index].mute = value != 0;
  } else if (property.equals("solo")) {
    channels[index].solo = value != 0;
  

}

    }
}
}