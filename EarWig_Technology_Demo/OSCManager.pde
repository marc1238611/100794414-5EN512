import oscP5.*;    //Import oscP5 written by Andres Schlegel https://sojamo.de/libraries/oscp5/
import netP5.*;


class OSCManager {      //OSCManager class
  
  OscP5 oscP5;          //initiates oscP5 class
  
NetAddress reaperAddress;

  OSCManager(PApplet parent, String ip, int reaperPort) {      //constructor for osc communicaitons
  
  oscP5 = new OscP5(parent,9000);                      //Start osc and listen on port 9000
  
  reaperAddress = new NetAddress(ip, reaperPort); // set reapers ip and listening port
  
    
  }
    
 
  // Send a float value to an OSC address
  void sendFloat(String address, float value) {
    OscMessage message = new OscMessage(address);
    message.add(value);
    println("OSC OUT: " + address + " = " + value);
    oscP5.send(message, reaperAddress);
  }

  // Send an integer value to an OSC address
  void sendInt(String address, int value) {
    OscMessage message = new OscMessage(address);
    message.add(value);
    oscP5.send(message, reaperAddress);
  }
  
  void setSolo(int track, boolean solo) {
  sendInt("/track/" + track + "/solo", solo ? 1 : 0);                //sets the solo state OF A REAPER TRACK
}
  
  void setVolume(int track, float volume) {
    volume = constrain(volume, 0, 1);
    sendFloat("/track/" + track + "/volume", volume);               //sets the fader level
  }
  
   void setPan(int trackNumber, float pan) {                        //set pan 
    pan = constrain(pan, -1, 1);
 
 

 
 String address = "/track/" + trackNumber + "/pan";
    sendFloat(address, pan);
 }
 
  void setMute(int track, boolean mute) {
  sendInt("/track/" + track + "/mute", mute ? 1 : 0);
}


void setMasterMute(boolean mute) {
  setMute(0, mute);
}


    void sendTrigger(String address) {
  OscMessage message = new OscMessage(address);
  oscP5.send(message, reaperAddress);
}

void setEQEnabled(int track, boolean enabled) {
  sendInt("/track/" + track + "/fxeq/bypass", enabled ? 0 : 1);
}
   
 void setFXParam(int track, int fx, int param, float value) {
  value = constrain(value, 0, 1);
  
  String address = "/track/" + track + "/fx/" + fx + "/fxparam/" + param + "/value";
sendFloat(address, value);
 }
   

void play() {
  sendTrigger("/play");
}

void stop() {
  sendTrigger("/stop");
}

void pause() {
  sendTrigger("/pause");
}

void record() {
  sendTrigger("/record");

}
void rewind() {
  sendTrigger("action/40085");
}
void forward() {
  sendTrigger("/action/40084");
}


}
