// TEST CODE//
Channel channel1;

void setup() {
  size(250, 400);

  channel1 = new Channel(
    1,    
    25,   
    20,   
    180,  
    350   
  );
}

void draw() {
  background(25);
  channel1.display();
}
