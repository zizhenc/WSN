class Switcher {
  float x, y, switchHeight;
  boolean value=true;
  String[] label=new String[2];
  Switcher(String labelI, String labelII) {
    label[0]=labelI;
    label[1]=labelII;
  }
  boolean active() {
    return mouseX>x&&mouseX<x+2*switchHeight&&mouseY>y&&mouseY<y+switchHeight;
  }
  void commit() {
    value=!value;
  }
  void display(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    rectMode(CORNER);
    switchHeight=gui.thisFont.stepY();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    if (value)
      fill(gui.colour[2].value, 70);
    else
      noFill();
    rect(x, y, 2*switchHeight, switchHeight, switchHeight/2);
    fill(gui.bodyColor[2].value);
    text(label[value?1:0], x+2*switchHeight+gui.thisFont.stepX(), y+switchHeight/2);
    noStroke();
    fill(gui.mainColor.value);
    if (value)
      circle(x+1.5*switchHeight, y+switchHeight/2, switchHeight-gui.unit(4));
    else
      circle(x+switchHeight/2, y+switchHeight/2, switchHeight-gui.unit(4));
    popStyle();
  }
}
