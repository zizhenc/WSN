class GIF extends Animation {
  int count, index, slowDown=1;
  PImage[] frame;
  GIF(String filename, int count) {
    initialize(filename, count);
  }
  GIF(String filename, int count, int slowDown) {
    this.slowDown=slowDown;
    initialize(filename, count);
  }
  void initialize(String filename, int count) {
    this.count=count;
    frame=new PImage[count];
    for (int i=0; i<count; i++)
      frame[i]=loadImage(filename+System.getProperty("file.separator")+filename+" ("+i+").gif");
    animeWidth=frame[0].width;
    animeHeight=frame[0].height;
  }
  void display(int mode, float x, float y, float factor) {
    if (frameCount%slowDown==0)
      index++;
    switch(mode) {
    case GUI.SCALE:
      image(frame[index%count], x, y, gui.unit(animeWidth)*factor, gui.unit(animeHeight)*factor);
      break;
    case GUI.WIDTH:
      image(frame[index%count], x, y, factor, animeHeight*factor/animeWidth);
      break;
    case GUI.HEIGHT:
      image(frame[index%count], x, y, animeWidth*factor/animeHeight, factor);
    }
  }
}
