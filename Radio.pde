class Radio {
  int value;
  float x, y, radioWidth, radioHeight, diameter, gap;
  String[] label;
  String maxLabel="";
  Radio(String...label) {
    this.label=label;
    for (String str : label)
      if (maxLabel.length()<str.length())
        maxLabel=str;
  }
  boolean inRange(int index) {
    return mouseX>x&&mouseY>y+(gap+diameter)*index&&mouseX<x+diameter&&mouseY<y+(gap+diameter)*(index+1);
  }
  boolean active() {
    for (int i=0; i<label.length; i++)
      if (inRange(i)) {
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
    diameter=gui.thisFont.stepY();
    radioWidth=textWidth(maxLabel)+diameter+gui.thisFont.stepX();
    radioHeight=gui.thisFont.stepY(label.length)+gui.thisFont.gap(label.length-1);
    gap=gui.thisFont.gap();
    for (int i=0; i<label.length; i++)
      if (inRange(i)) {
        noStroke();
        fill(gui.highlightColor.value, 100);
        circle(x+diameter/2, y+i*(diameter+gap)+diameter/2, diameter);
      }
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    for (int i=0; i<label.length; i++)
      circle(x+diameter/2, y+i*(diameter+gap)+diameter/2, diameter);
    fill(gui.bodyColor[2].value);
    for (int i=0; i<label.length; i++)
      text(label[i], x+diameter+gui.thisFont.stepX(), y+diameter*i+diameter/2+gap*i);
    stroke(gui.mainColor.value);
    strokeWeight(diameter/3);
    point(x+diameter/2, y+(diameter+gap)*value+diameter/2);
    popStyle();
  }
}
