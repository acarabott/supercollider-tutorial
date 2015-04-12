/**
 * oscP5message by andreas schlegel
 * example shows how to create osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
int sendPort = 6666;
int textSize = 32;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", sendPort);
}


void draw() {
  int bg = 0;
  int fg = 255;
  
  if (mousePressed) {
    bg = 255;
    fg = 0;
  }
    
  background(bg); 
  
  fill(fg);
  textSize(textSize);
  textAlign(CENTER);
  
  float textY = textSize; 
  text("Click me", width * 0.5, textY);
  textY += textSize * 2;
  textAlign(LEFT);
  text("Send port: ", 0, textY);
  text(sendPort, width * 0.5, textY); 
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(mouseX); /* add an int to the osc message */
  myMessage.add(mouseY); /* add a float to the osc message */
  myMessage.add("click!"); /* add a string to the osc message */
  
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
