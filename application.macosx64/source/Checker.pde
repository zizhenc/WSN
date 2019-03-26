class Checker {
  float x, y, checkerWidth, checkerHeight;
  String label;
  boolean value=true;
  Checker(String label) {
    this.label=label;
  }
  void display(float x, float y) {
    pushStyle();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    checkerWidth=textWidth(label)+gui.thisFont.stepY()+gui.thisFont.stepX();
    checkerHeight=gui.thisFont.stepY();
    rectMode(CORNER);
    textAlign(LEFT, CENTER);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    if (inBox())
      fill(gui.colour[2].value, 70);
    else
      noFill();
    square(x, y, checkerHeight);
    fill(gui.bodyColor[2].value);
    text(label, x+checkerHeight+gui.thisFont.stepX(), y+checkerHeight/2);
    if (value) {
      strokeWeight(gui.unit(2));
      if (mousePressed&&inBox())
        stroke(gui.colour[3].value);
      else
        stroke(gui.mainColor.value);
      line(x+gui.unit(3), y+gui.unit(3), x+checkerHeight-gui.unit(3), y+checkerHeight-gui.unit(3));
      line(x+checkerHeight-gui.unit(3), y+gui.unit(3), x+gui.unit(3), y+checkerHeight-gui.unit(3));
    }
    popStyle();
  }
  boolean inBox() {
    return mouseX>x&&mouseX<x+checkerHeight&&mouseY>y&&mouseY<y+checkerHeight;
  }
  boolean active() {
    if (inBox()) {
      value=!value;
      return true;
    } else
      return false;
  }
}
