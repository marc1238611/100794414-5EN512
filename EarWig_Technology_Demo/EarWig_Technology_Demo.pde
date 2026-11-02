import oscP5.*;
import netP5.*;

OSCManager oscManager;                        //OSC communication manager

Channel[] channels = new Channel[4];
PanKnob[] panKnobs = new PanKnob[4];

Button[] transportButtons = new Button[5];

void setup() {
  size(1080, 720);
    surface.setTitle("REAPER OSC Mixer");

  oscManager = new OSCManager(this, "127.0.0.1", 8000);        //creates OSC manager

  for (int i = 0; i < channels.length; i++) {
    float stripWidth = 75;                               
    float spacing = 1;                                 
    float startX = 10 + i * (stripWidth + spacing);
    
    
  for (int j = 0; j < panKnobs.length; j++) {
    float x =  10 + j * (stripWidth + spacing) + stripWidth / 2;
    float y = 400;

  panKnobs[j] = new PanKnob(
    x, y, 15, j + 1, oscManager
  );
}

    channels[i] = new Channel(
      i + 1, startX,00, stripWidth, 320, oscManager
    );
   
  }
  
   String[] labels = {
    "REWIND", "PLAY", "PAUSE", "STOP", "RECORD"
  };
  String[] addresses = {
    "/rewind", "/play", "/pause", "/stop", "/record"
  };
   for (int i = 0; i < transportButtons.length; i++) {
    transportButtons[i] = new Button(920, 10+i*90, labels[i], addresses[i], oscManager);
  }
  


}

void draw() {
  background(25);

  for (Channel channel : channels) {
    channel.display();
  }
  for (int j = 0; j < panKnobs.length; j++) {
 panKnobs[j].display();
  }
  
  for (Button button : transportButtons) {
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
}

void mouseDragged() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();
  }
     for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mouseDragged();
}
}

void mouseReleased() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseReleased();
  }
      for (int j = 0; j < panKnobs.length; j++) {
    panKnobs[j].mouseReleased();
    
    }

}
