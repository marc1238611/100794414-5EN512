import oscP5.*;
import netP5.*;

OSCManager oscManager;                        //OSC communication manager

Channel[] channels = new Channel[4];

void setup() {
  size(1080, 720);
    surface.setTitle("REAPER OSC Mixer");

  oscManager = new OSCManager(this, "127.0.0.1", 8000);        //creates OSC manager

  for (int i = 0; i < channels.length; i++) {
    float stripWidth = 75;                               
    float spacing = 19;                                 
    float startX = 10 + i * (stripWidth + spacing);

    channels[i] = new Channel(
      i + 1, startX, 20, stripWidth, 350, oscManager
    );
  }
}

void draw() {
  background(25);

  for (Channel channel : channels) {
    channel.display();
  }
}

void mousePressed() {                                  
  for (int i = 0; i < channels.length; i++) {
    channels[i].mousePressed();
  }
   for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();                        
}


  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();
  }
}

void mouseDragged() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseDragged();
  }
}

void mouseReleased() {
  for (int i = 0; i < channels.length; i++) {
    channels[i].mouseReleased();
  }
}
