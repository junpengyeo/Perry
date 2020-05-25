import java.awt.AWTException;
import java.awt.Robot;

import org.openkinect.*;
import org.openkinect.processing.*;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

float deg = 15; // Start at 15 degrees

Robot robby;
int xx = 0, yy = 0;
//int stageWidth = 1280;
//int stageHeight = 720;
int stageWidth = 1920;
int stageHeight = 1080;
int prW, prH;
int stageScale = 5/3;

void setup() {
  size(640, 360);

  prW = stageWidth/width;
  prH = stageHeight/height;

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  deg = kinect.getTilt();

  try
  {
    robby = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
}

void draw() {
  background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  fill(50, 100, 250, 200);
  noStroke();
  ellipse(v1.x, v1.y, 20, 20);

  // Let's draw the "lerped" location  
  PVector v2 = tracker.getLerpedPos();
  fill(100, 250, 50, 200);
  noStroke();
  ellipse(v2.x, v2.y, 20, 20);  

  xx = ((int(v2.x)*stageScale) * prW);
  yy = ((int(v2.y)*stageScale) * prH);    
  robby.mouseMove(xx, yy);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold", 10, 500);
}

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
      println(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
      println(t);
    }
    if (keyCode == LEFT) {
      deg++;
    } else if (keyCode == RIGHT) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
    println(deg);
  }
}
