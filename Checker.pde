class Checker {
  float x, y, checkerWidth, checkerHeight;
  String label;
  boolean value;
  Checker(String label) {
    this.label=label;
  }
  void display(float x, float y) {
    pushStyle();
    rectMode(CORNER);
    textAlign(LEFT, CENTER);
    checkerWidth=gui.thisFont.stepY()+gui.thisFont.stepX()+textWidth(label);
    checkerHeight=gui.thisFont.stepY();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y, checkerHeight, checkerHeight);
    fill(gui.bodyColor[2].value);
    text(label, x+checkerHeight+gui.thisFont.stepX(), y+checkerHeight/2);
    if (active()) {
      noStroke();
      gui.kind=HAND;
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
  boolean active() {
    return mouseX>x&&mouseX<x+checkerHeight&&mouseY>y&&mouseY<y+checkerHeight;
  }
}
