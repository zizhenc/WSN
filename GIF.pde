class GIF extends Animation {
  int count, index, slowDown=1;
  PImage[] frame;
  boolean loop=true;
  GIF(String filename, int count) {
    this.count=count;
    isPlaying=true;
    frame=new PImage[count];
    for (int i=0; i<count; i++)
      frame[i]=loadImage(filename+System.getProperty("file.separator")+filename+" ("+i+").gif");
  }
  GIF(String filename, int count, int slowDown) {
    this(filename, count);
    this.slowDown=slowDown;
  }
  void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      animeWidth=gui.unit(frame[0].width)*factor;
      animeHeight=gui.unit(frame[0].height)*factor;
      break;
    case GUI.WIDTH:
      animeWidth=factor;
      animeHeight=frame[0].height*factor/frame[0].width;
      break;
    case GUI.HEIGHT:
      animeWidth=frame[0].width*factor/frame[0].height;
      animeHeight=factor;
    }
    image(frame[index%count], x, y, animeWidth, animeHeight);
    if (isPlaying)
      if (loop) {
        if (frameCount%slowDown==0)
          index++;
      } else if (frameCount%slowDown==0&&index<count)
        index++;
  }
  void play() {
    isPlaying=true;
  }
  void repeat() {
    loop=true;
    isPlaying=true;
  }
  void pause() {
    isPlaying=false;
  }
  void end() {
    index=0;
    isPlaying=false;
  }
  int hours() {
    return round(slowDown*(index)/frameRate)/3600;
  }
  int minutes() {
    return round((slowDown*(index)/frameRate)%3600)/60;
  }
  int seconds() {
    return round(slowDown*(index)/frameRate)%60;
  }
  float position() {
    return (index%count)*1f/count;
  }
}
