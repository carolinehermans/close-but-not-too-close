// test z-value from 1 to 4+: blue(1), green(2), white + slow(3), black(<1,4+)
int z = 3;

import processing.video.*;
Movie currentMovie;
String currentMovieFilename = "BadTvOutput-trim.mp4";

import oscP5.*;
OscP5 oscP5;

//Syphon section
import codeanticode.syphon.*;
SyphonServer server;
PGraphics canvas;

// initialize gradient 
int dim;

void setup() {
  size (1000,600, P3D); 
  currentMovie = new Movie(this, currentMovieFilename);
  currentMovie.loop();
  
  oscP5 = new OscP5(this, 12345);
  
  //Syphon section 
  canvas = createGraphics(1000, 600, P3D);
  server = new SyphonServer(this, "Processing Syphon");

// gradient set up
  dim = width;
  
  colorMode(RGB, 100, 100, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  
  if (z == 3) {
    frameRate(1);
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

void draw(){
  // Update canvas every 10 frames for some lag (???)
  canvas.beginDraw();
  canvas.image(currentMovie, 0, 0);
  canvas.set(width, height, currentMovie);
  
  // display frame rate
  textSize(42);
  canvas.text(frameRate, 10, 30);
 
  canvas.endDraw(); 
  image(canvas, 0, 0);
  
  //gradient
  for (int x = 0; x <= width; x+=dim) {
    drawGradient(x, height/2);
  }  
}

void drawGradient(float x, float y) {
  int radius = dim/2;
  float col = random(0, 100);
  for (int r = radius; r > 0; r--) {
    
    //start
    if (z == 1){
    fill(0, 0, col, 1);
    ellipse(x, y, r, r);
    col = (col + 1) % 100;
    } 
    
    // too far
    else if (z == 2) {
    fill(0, col, 0, 1);  
    ellipse(x, y, r, r);
    col = (col + 1) % 100;
    }  
    
    // close
    else if (z == 3) {
    fill(col, col, col, 1);  
    ellipse(x, y, r, r);
    col = (col + 1) % 100;
    }
    
    //too close
    else {
    fill(col/8,col/8,col/8, 1);  
    ellipse(x, y, r, r);
    col = (col + 1) % 100;
    }
  }
}

/* Forwards value from Kinect 
@OscMessage OSC address pattern 
@theOscMessage OSC value 
*/
void oscEvent(OscMessage theOscMessage) {
  
  String[] parts = theOscMessage.addrPattern().split("/");
  
  if (parts[parts.length - 1].equals("SpineBase")) {
    //println(theOscMessage.addrPattern());
    if(theOscMessage.checkTypetag("fffs")) {

      //println(theOscMessage.get(2).floatValue());
    }
  }
}