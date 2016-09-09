import processing.video.*;
Movie currentMovie;
String currentMovieFilename = "test.mov";
int N = 0;
int glitchAmount = 50;

import oscP5.*;
OscP5 oscP5;

//Syphon section
import codeanticode.syphon.*;
SyphonServer server;
PGraphics canvas;


void setup() {
  size (1000,600, P3D);
  //background(255);
  //colorMode(HSB);
  currentMovie = new Movie(this, currentMovieFilename);
  currentMovie.loop();
  
  oscP5 = new OscP5(this, 12345);
  
  //Syphon section 
  canvas = createGraphics(1000, 600, P3D);
  server = new SyphonServer(this, "Processing Syphon");
}

void movieEvent(Movie m) {
  m.read();
}

void draw(){
  // Update canvas every 10 frames for some lag
  canvas.beginDraw();
  canvas.image(currentMovie, 0, 0);
  canvas.set(width, height, currentMovie);
  // Every glitchAmount / 20 frames, glitch the camera feed
  if (glitchAmount>2 && frameCount % ((102-glitchAmount)) == 0) {
    glitchFeed();
  }
  // Every glitchAmount / 8 frames, add some rainbow stuff
  if(glitchAmount>1 && frameCount % ((101-glitchAmount)) == 0) {
  // Randomly fill in pretty colors
    for (int i = 0; i < 3*glitchAmount; i++) {
      canvas.noStroke();
      canvas.fill(random(0,360),300,300,100);
      canvas.rect ((random (0, width)),(random (0, height)),(random (0,40)),(random(0,30)));
    }
  }
  
  textSize(42);
  canvas.text(frameRate, 10, 30);
  canvas.endDraw();
  
  image(canvas, 0, 0);
  
  
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
    canvas.set(x+r(80)-1,y+r(3)-1,get(x,y,r(99),r(30)));
  }
}

void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage.addrPattern(), theOscMessage.typetag());
  //theOscMessage.print();
  
  
  String[] parts = theOscMessage.addrPattern().split("/");
  
  if (parts[parts.length - 1].equals("SpineBase")) {
    //println(theOscMessage.addrPattern());
    if(theOscMessage.checkTypetag("fffs")) {
      float glitch = theOscMessage.get(2).floatValue();
      
      float glitchMap = map(glitch, 0, 5, 0, 100);
      float glitchMap2 = map(glitchMap, 15, 40, 100, 0);
      
      if (glitchMap2 > 100) {
        glitchMap2 = 100;
      }
      if (glitchMap2 < 0) {
        glitchMap2 = 0;
      }
      
      glitchAmount = parseInt(glitchMap2);
      println(glitchAmount);
      
      //println(theOscMessage.get(2).floatValue());
    }
  }
}
