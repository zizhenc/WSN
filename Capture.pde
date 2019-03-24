 class Capture {
  int x, y, captureWidth, captureHeight, time;
  StringBuffer path=new StringBuffer("Screenshots");
  boolean active, finish, mode;
  void store() {
    active=true;
    finish=!mode;
    x=y=captureWidth=captureHeight=0;
    if (finish) {
      saveFrame(path+System.getProperty("file.separator")+"WSN-"+frameCount+".png");
      time=millis();
    }
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    rectMode(CORNER);
    if (mode) {
      stroke(gui.colour[1].value);
      strokeWeight(gui.unit(2));
      dottedLine(0, mouseY, width, mouseY);
      dottedLine(mouseX, 0, mouseX, height);
      if (captureWidth!=0&&captureHeight!=0) {
        fill(gui.bodyColor[2].value);
        String prompt="Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to crop.";
        textAlign(RIGHT);
        text(prompt, x-gui.thisFont.stepX()+(captureWidth>0?captureWidth:0), y+gui.thisFont.stepY()+(captureHeight>0?captureHeight:0));
      } 
      noFill();
      rect(x, y, captureWidth, captureHeight);
    }
    if (finish) {
      fill(gui.colour[2].value);
      noStroke();
      if (millis()-time<200)
        rect(0, 0, width, height);
      else
        active=false;
    }
    popStyle();
  }
  void dottedLine(float x1, float y1, float x2, float y2) {
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
  }
  void keyRelease() {
    if (mode&&(key==ENTER||key==RETURN)&&captureWidth!=0&&captureHeight!=0) {
      get(x+(captureWidth>0?0:captureWidth), y+(captureHeight>0?0:captureHeight), abs(captureWidth), abs(captureHeight)).save(path+System.getProperty("file.separator")+"WSN-"+frameCount+".png");
      x=y=captureWidth=captureHeight=0;
      finish=true;
      time=millis();
    }
  }
  void mousePress() {
    if (mode) {
      x=mouseX;
      y=mouseY;
      captureWidth=captureHeight=0;
    }
  }
  void mouseDrag() {
    if (mode) {
      captureWidth=mouseX-x;
      captureHeight=mouseY-y;
    }
  }
}
