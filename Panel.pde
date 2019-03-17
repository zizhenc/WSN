abstract class Panel {
  float x, y, panelWidth, panelHeight;
  String label;
  abstract void setting();
  abstract void show();
  abstract void mouseRelease();
  void display(float x, float y) {
    pushStyle();
    this.x=x;
    this.y=y;
    panelWidth=(width-gui.unit(40))/3;
    panelHeight=height*2/3;
    gui.head.initialize();
    fill(gui.bodyColor[2].value);
    text(label, x+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y, panelWidth, panelHeight, gui.unit(10));
    gui.body.initialize();
    show();
    popStyle();
  }
  void keyPress() {
  }
  void keyType() {
  }
  void mousePress() {
  }
}
