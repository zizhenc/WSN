class Radio {
  int value;
  float x, y, radioWidth, radioHeight, diameter, gap;
  LinkedList<String> labels=new LinkedList<String>();
  String maxLabel="";
  Radio(String...label) {
    for (String str : label) {
      labels.addLast(str);
      if (maxLabel.length()<str.length())
        maxLabel=str;
    }
  }
  void setLabels(LinkedList<String> labels) {
    this.labels.clear();
    maxLabel="";
    for (String label : labels) {
      this.labels.addLast(label);
      if (maxLabel.length()<label.length())
        maxLabel=label;
    }
  }
  boolean inCircle(int index) {
    return mouseX>x&&mouseY>y+(gap+diameter)*index&&mouseX<x+diameter&&mouseY<y+(gap+diameter)*(index+1);
  }
  boolean active() {
    for (int i=0; i<labels.size(); i++)
      if (inCircle(i)) {
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
    radioHeight=gui.thisFont.stepY(labels.size())+gui.thisFont.gap(labels.size()-1);
    gap=gui.thisFont.gap();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    for (int i=0; i<labels.size(); i++) {
      if (inCircle(i))
        fill(gui.colour[2].value, 70);
      else
        noFill();
      circle(x+diameter/2, y+i*(diameter+gap)+diameter/2, diameter);
    }
    fill(gui.bodyColor[2].value);
    for (ListIterator<String> i=labels.listIterator(); i.hasNext(); )
      text(i.next(), x+diameter+gui.thisFont.stepX(), y+diameter*i.previousIndex()+diameter/2+gap*i.previousIndex());
    stroke(gui.mainColor.value);
    strokeWeight(diameter/3);
    point(x+diameter/2, y+(diameter+gap)*value+diameter/2);
    popStyle();
  }
}
