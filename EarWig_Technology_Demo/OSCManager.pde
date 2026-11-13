import oscP5.*;    //Import oscP5 written by Andres Schlegel https://sojamo.de/libraries/oscp5/
import netP5.*;

//Keeps OSC communication in one place so that UI ocmponents can send and 
//receive commands without having to build and send OSC messages themselves
class OSCManager {      //OSCManager class
  
  OscP5 oscP5;          
  
NetAddress reaperAddress;
//Sets the ip address and port to send OSC messages on to Reaper 
//MUST MATCH REAPERS RECEIVING IP ADDRESS AND PORT
  OSCManager(PApplet parent, String ip, int reaperPort) {      //constructor for osc communicaitons
  
  
  reaperAddress = new NetAddress(ip, reaperPort); // set reapers ip and listening port
  
    
  }
//Starts receiving OSC messages on the local port used by reaper to send data back to the sketch
 void startListening(PApplet parent) {
  oscP5 = new OscP5(parent, 9000);
}
//Builds an OSC Message with the requested address and value then sends it to the corresponding Reaper destination. 
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
  sendInt("/track/" + track + "/solo", solo ? 1 : 0);                //sets the solo state a Reaper track
}
  //constrains the volume to be within reapers valuer range of 0-1
  void setVolume(int track, float volume) {
    volume = constrain(volume, 0, 1);
    sendFloat("/track/" + track + "/volume", volume);               //sets the fader level
  }
  //constrains the pan value to within reapers 0-1 range and sends it to the channels pan address
   void setPan(int trackNumber, float pan) {                        //set pan 
    pan = constrain(pan, 0, 1);
 
 

 
 String address = "/track/" + trackNumber + "/pan";
    sendFloat(address, pan);
 }
 
  void setMute(int track, boolean mute) {
  sendInt("/track/" + track + "/mute", mute ? 1 : 0);
}

//Reuses the channels mute command but with track 0 to contorl the master mute state
void setMasterMute(boolean mute) {
  setMute(0, mute);
}


    void sendTrigger(String address) {
  OscMessage message = new OscMessage(address);
  oscP5.send(message, reaperAddress);
}
//sends the inverse of the enable state as Reapers EQ bypass has 
//0 means enabled and 1 means bypassed
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
