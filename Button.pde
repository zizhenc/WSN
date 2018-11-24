class Button {
  int alignment;
  float x, y, buttonHeight, buttonWidth;//x and y is real coordinates
  String label;
  Button(String label) {
    this.label=label;
  }
  boolean active() {
    if (alignment==CENTER)
      return mouseX>x-buttonWidth/2&&mouseX<x+buttonWidth/2&&mouseY>y-buttonHeight/2&&mouseY<y+buttonHeight/2;
    else
      return mouseX>x&&mouseX<x+buttonWidth&&mouseY>y&&mouseY<y+buttonHeight;
  }
  void buttonMode(int mode) {
    alignment=mode;
  }
  void display(float x, float y) {
    display(x, y, textWidth(label)+gui.thisFont.stepX(2), gui.thisFont.stepY(2));
  }
  void display(int mode, float x, float y, float factor) {
    if (mode==GUI.WIDTH)
      display(x, y, factor, gui.thisFont.stepY(2));
    else if (mode==GUI.HEIGHT)
      display(x, y, textWidth(label)+gui.thisFont.stepX(2), factor);
  }
  void display(float x, float y, float buttonWidth, float buttonHeight) {
    this.buttonWidth=buttonWidth;
    this.buttonHeight=buttonHeight;
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    pushStyle();
    rectMode(alignment);
    textAlign(CENTER, CENTER);
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit());
    noFill();
    rect(x, y, buttonWidth, buttonHeight, gui.unit(8), 0, gui.unit(8), 0);
    if (active()) {
      gui.kind=HAND;
      fill(gui.highlightColor.value, 100);
      noStroke();
      rect((alignment==CENTER?0:gui.unit(3))+x, (alignment==CENTER?0:gui.unit(3))+y, buttonWidth-gui.unit(6), buttonHeight-gui.unit(6), gui.unit(8), 0, gui.unit(8), 0);
      fill(gui.bodyColor[mousePressed?0:2].value);
    } else
      fill(gui.bodyColor[2].value);
    text(label, (alignment==CENTER?0:buttonWidth/2)+x, (alignment==CENTER?0:buttonHeight/2)+y);
    popStyle();
  }
}