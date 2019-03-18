class PathBar {
  float x, y, barWidth, barHeight, pathHeight;
  boolean active;
  String label;
  Input path;
  PathBar(String label, StringBuffer path) {
    this.label=label;
    this.path=new Input("", path);
  }
  void display(float x, float y, float barWidth) {
    pushStyle();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.barWidth=barWidth;
    barHeight=gui.thisFont.stepY(2)+gui.thisFont.gap(2);
    pathHeight=gui.thisFont.stepY()+gui.thisFont.gap();
    fill(gui.headColor[2].value);
    textAlign(LEFT);
    text(label+": ", x, y+gui.thisFont.stepY());
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y+gui.thisFont.stepY()+gui.thisFont.gap(), barWidth, gui.thisFont.stepY()+gui.thisFont.gap());
    fill(gui.bodyColor[0].value);
    if (active)
      path.cin(x+gui.thisFont.stepX(), y+gui.thisFont.stepY()+gui.thisFont.gap());
    else
      path.display(x+gui.thisFont.stepX(), y+gui.thisFont.stepY()+gui.thisFont.gap());
    popStyle();
  }
  void setPath(File selection) {
    if (selection!=null)
      path.value=selection.getAbsolutePath();
  }
  void keyType() {
    if (active)
      path.keyType();
  }
  void keyPress() {
    if (active) {
      path.keyPress();
      if (key==ENTER||key==RETURN) {
        path.commit();
        active=false;
      }
    }
  }
  void mousePress() {
    path.active();
    if (mouseX>x&&mouseX<x+barWidth&&mouseY>y+pathHeight&&mouseY<y+barHeight)
      active=true;
    else {
      path.commit();
      active=false;
    }
  }
}
