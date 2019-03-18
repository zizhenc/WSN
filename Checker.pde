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
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    square(x, y, checkerHeight);
    fill(gui.bodyColor[2].value);
    text(label, x+checkerHeight+gui.thisFont.stepX(), y+checkerHeight/2);
    if (inRange()) {
      noStroke();
      fill(gui.highlightColor.value, 100);
      rect(x, y, checkerHeight, checkerHeight);
    }
    stroke(gui.mainColor.value);
    strokeWeight(gui.unit(2));
    if (value) {
      line(x+gui.unit(3), y+gui.unit(3), x+checkerHeight-gui.unit(3), y+checkerHeight-gui.unit(3));
      line(x+checkerHeight-gui.unit(3), y+gui.unit(3), x+gui.unit(3), y+checkerHeight-gui.unit(3));
    }
    popStyle();
  }
  boolean inRange() {
    return mouseX>x&&mouseX<x+checkerHeight&&mouseY>y&&mouseY<y+checkerHeight;
  }
  boolean active() {
    if (inRange()) {
      value=!value;
      return true;
    } else
      return false;
  }
}
