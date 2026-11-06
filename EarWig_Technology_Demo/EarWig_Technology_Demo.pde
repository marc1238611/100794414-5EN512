import oscP5.*;
import netP5.*;

OSCManager oscManager;                        //OSC communication manager
vuL vuMeters;

Channel[] channels = new Channel[4];
MasterChannel[] MasterChannels = new MasterChannel[1];
PanKnob[] panKnobs = new PanKnob[4];
Knob masterPanKnob;
Button[] transportButtons = new Button[6];


void setup() {
  size(1080, 720);
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

      panKnobs[j] = new PanKnob(
        x, y, 15, j + 1, oscManager
        );
    }

    channels[i] = new Channel(
      i + 1, startX, 00, stripWidth, 320, oscManager
      );
  }

  String[] labels = {
    "REWIND", "FORWARD", "PLAY", "PAUSE", "STOP", "RECORD",
  };
  String[] addresses = {
    "/action/40085", "/action/40084", "/play", "/pause", "/stop", "/record"
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
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].display();
  }

  for (Button button : transportButtons) {
    button.display();
  }
  vuMeters.display();
  masterPanKnob.display();
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
}

void mouseReleased() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseReleased();
  }
  for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mouseReleased();
  }
  masterPanKnob.mouseReleased();
}






void oscEvent(OscMessage theOscMessage) {
  vuMeters.oscEvent(theOscMessage);
}
