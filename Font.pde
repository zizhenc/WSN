class Font {
  int size;
  PFont font;
  Font(String fontFile, int size) {
    font=loadFont(fontFile);
    this.size=size;
  }
  float gap() {
    return gap(1);
  }
  float gap(float factor) {
    if (this==gui.thisFont)
      return 2*textDescent()*factor;
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=2*textDescent()*factor;
      popStyle();
      return value;
    }
  }
  float stepX() {
    return stepX(1);
  }
  float stepX(float factor) {
    if (this==gui.thisFont)
      return textWidth('x')*factor;
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=textWidth('x')*factor;
      popStyle();
      return value;
    }
  }
  float stepY() {
    return stepY(1);
  }
  float stepY(float factor) {
    if (this==gui.thisFont)
      return factor*(textAscent()+2*textDescent());
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=factor*(textAscent()+2*textDescent());
      popStyle();
      return value;
    }
  }
  void initialize() {
    gui.thisFont=this;
    textFont(font, gui.unit(size));
  }
}
