abstract class Setting {
  Image box=new Image("Box.png");
  String label;
  Animation video;
  abstract void initialize();
  abstract void moreMousePresses();
  abstract void moreMouseReleases();
  abstract void moreKeyReleases();
  void moreKeyPresses() {
  }
  abstract void show(float x, float y, float panelWidth, float panelHeight);
  void setting() {
    video.repeat();
    initialize();
  }
  void display() {
    pushStyle();
    box.display(GUI.WIDTH, width/2, height-box.imageHeight, width/2);
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text(label, gui.thisFont.stepX(), gui.thisFont.stepY());
    gui.body.initialize();
    video.display(GUI.WIDTH, width/2, height/6, width/2-width/12);
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(width/12, height/6, width/3, height*2/3, gui.unit(8));
    show(width/12, height/6, width/3, height*2/3);
    navigation.display();
    popStyle();
  }
  void keyPress() {
    navigation.keyPress();
    if (!navigation.active())
      moreKeyPresses();
  }
  void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active())
      moreKeyReleases();
  }
  void keyType() {
  }
  void mousePress() {
    navigation.mousePress();
    if (!navigation.active())
      moreMousePresses();
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active())
      moreMouseReleases();
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
