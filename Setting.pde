class Setting implements Screen {
  Image box=new Image("Box.png");
  Panel colors=new ColorPanel(), system=new SystemPanel(), fonts=new FontPanel();
  Capture capture=new Capture();
  void setting() {
    colors.setting();
    system.setting();
    fonts.setting();
  }
  void display() {
    pushStyle();
    box.display(GUI.WIDTH, width/2, height-box.imageHeight, width/2);
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text("Preference", gui.thisFont.stepX(), gui.thisFont.stepY());
    colors.display(gui.unit(10), height/6);
    system.display(gui.unit(20)+colors.panelWidth, height/6);
    fonts.display(gui.unit(30)+colors.panelWidth+system.panelWidth, height/6);
    gui.body.initialize();
    navigation.display();
    popStyle();
  }
  void keyPress() {
    navigation.keyPress();
    if (!navigation.active())
      system.keyPress();
  }
  void keyRelease() {
    navigation.keyRelease();
  }
  void keyType() {
    if (!navigation.active())
      system.keyType();
  }
  void mousePress() {
    navigation.mousePress();
    if (!navigation.active()) {
      colors.mousePress();
      system.mousePress();
      fonts.mousePress();
    }
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      colors.mouseRelease();
      system.mouseRelease();
      fonts.mouseRelease();
    }
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
