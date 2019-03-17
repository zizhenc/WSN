public class PathBar {
  float x, y, pathWidth, pathHeight;
  boolean active;
  String label;
  Input path;
  PathBar(String label, String path) {
    this.label=label;
    this.path=new Input("", path);
  }
  void display(float x, float y, float pathWidth) {
    pushStyle();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.pathWidth=pathWidth;
    pathHeight=gui.thisFont.stepY(2)+gui.thisFont.gap(2);
    fill(gui.headColor[2].value);
    textAlign(LEFT);
    text(label+": ", x, y+gui.thisFont.stepY());
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y+gui.thisFont.stepY()+gui.thisFont.gap(), pathWidth-gui.unit(8), gui.thisFont.stepY()+gui.thisFont.gap());
    fill(gui.bodyColor[0].value);
    textAlign(LEFT, CENTER);
    if (active)
      path.cin(x+gui.thisFont.stepX(), y+gui.thisFont.stepY(1.5)+gui.thisFont.gap(1.5));
    else
      path.display(x+gui.thisFont.stepX(), y+gui.thisFont.stepY(1.5)+gui.thisFont.gap(1.5));
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
    if (active)
      path.keyPress();
  }
  void mousePress() {
    path.active();
    if (mouseX>x&&mouseX<x+pathWidth&&mouseY>y+gui.thisFont.stepY()+gui.thisFont.gap()&&mouseY<y+gui.thisFont.stepY(2)+gui.thisFont.gap(2))
      active=true;
    else {
      path.commit();
      active=false;
    }
  }
}
