import processing.video.*;
Movie currentMovie;
String currentMovieFilename = "test.mov";
int N = 0;
int glitchAmount = 50;

import oscP5.*;
OscP5 oscP5;

void setup() {
  size (1000,600);
  background(255);
  colorMode(HSB);
  currentMovie = new Movie(this, currentMovieFilename);
  currentMovie.loop();
  
  oscP5 = new OscP5(this, 12345);
}

void movieEvent(Movie m) {
  m.read();
  draw();
}

void draw(){
  // Update canvas every 10 frames for some lag
  image(currentMovie, 0, 0);
  set(width, height, currentMovie);
  // Every glitchAmount / 20 frames, glitch the camera feed
  if (glitchAmount>2 && frameCount % ((102-glitchAmount)) == 0) {
    glitchFeed();
  }
  // Every glitchAmount / 8 frames, add some rainbow stuff
  if(glitchAmount>1 && frameCount % ((101-glitchAmount)) == 0) {
  // Randomly fill in pretty colors
    for (int i = 0; i < 3*glitchAmount; i++) {
      noStroke();
      fill(random(0,360),300,300,100);
      rect ((random (0, width)),(random (0, height)),(random (0,40)),(random(0,30)));
    }
  }
}

// Get a random number
int r(int a){
  return int(random(a));
}

// Scramble the camera feed
void glitchFeed() {
  for (int i=0; i<5*glitchAmount; i++) {
    int x = r(width);
    int y = r(height);
    set(x+r(80)-1,y+r(3)-1,get(x,y,r(99),r(30)));
  }
}

void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage.addrPattern(), theOscMessage.typetag());
  //theOscMessage.print();
  
  
  String[] parts = theOscMessage.addrPattern().split("/");
  
  if (parts[parts.length - 1].equals("SpineBase")) {
    //println(theOscMessage.addrPattern());
    if(theOscMessage.checkTypetag("fffs")) {
      println(theOscMessage.get(2).floatValue());
    }
  }
}