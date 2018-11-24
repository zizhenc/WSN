class Radio {
  int value;
  float x, y, radioWidth, radioHeight, diameter, gap;
  String[] label;
  Radio(String[] label) {
    this.label=label;
  }
  boolean active() {
    for (int i=0; i<label.length; i++)
      if (mouseX>x&&mouseY>y+(gap+diameter)*i&&mouseX<x+diameter&&mouseY<y+(gap+diameter)*(i+1)) {
        value=i;
        return true;
      }
    return false;
  }
  void display(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    radioWidth=textWidth(label[0])+gui.thisFont.stepX()+gui.thisFont.stepY();
    radioHeight=gui.thisFont.stepY(label.length)+gui.thisFont.gap(label.length-1);
    diameter=gui.thisFont.stepY();
    gap=gui.thisFont.gap();
    if (mouseX>this.x&&mouseX<this.x+diameter&&mouseY>this.y&&mouseY<this.y+radioHeight)
      gui.kind=HAND;
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    for (int i=0; i<label.length; i++)
      ellipse(x+diameter/2, y+i*(diameter+gap)+diameter/2, diameter, diameter);
    fill(gui.bodyColor[2].value);
    for (int i=0; i<label.length; i++)
      text(label[i], x+diameter+gui.thisFont.stepX(), y+diameter*i+diameter/2+gap*i);
    stroke(gui.mainColor.value);
    strokeWeight(gui.unit(4));
    point(x+diameter/2, y+(diameter+gap)*value+diameter/2);
    popStyle();
  }
}
