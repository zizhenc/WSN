class Switcher {
  float x, y, switchWidth, switchHeight;
  boolean value=true;
  String[] label=new String[2];
  Switcher(String labelI, String labelII) {
    label[0]=labelI;
    label[1]=labelII;
  }
  boolean active() {
    return mouseX>x&&mouseX<x+2*switchHeight&&mouseY>y&&mouseY<y+switchHeight;
  }
  void display(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    rectMode(CORNER);
    switchWidth=gui.thisFont.stepY(2)+textWidth(label[0].length()>label[1].length()?label[0]:label[1])+gui.thisFont.stepX();
    switchHeight=gui.thisFont.stepY();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y, 2*switchHeight, switchHeight, switchHeight/2);
    fill(gui.bodyColor[2].value);
    text(label[value?1:0], x+2*switchHeight+gui.thisFont.stepX(), y+switchHeight/2);
    noStroke();
    if (active())
      gui.kind=HAND;
    if (value) {
      fill(gui.highlightColor.value, 100);
      rect(x, y, 2*switchHeight, switchHeight, switchHeight/2);
      fill(gui.mainColor.value);
      ellipse(x+1.5*switchHeight, y+switchHeight/2, switchHeight-gui.unit(4), switchHeight-gui.unit(4));
    } else {
      fill(gui.mainColor.value);
      ellipse(x+switchHeight/2, y+switchHeight/2, switchHeight-gui.unit(4), switchHeight-gui.unit(4));
    }
    popStyle();
  }
}
