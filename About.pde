class About implements Screen {
  About() {
  }
  void setting() {
  }
  void display() {
    pushStyle();
    gui.body.initialize();

    navigation.display();
    popStyle();
  }
  void keyPress() {
  }
  void keyRelease() {
    navigation.keyRelease();
  }
  void keyType() {
  }
  void mousePress() {
    navigation.mousePress();
  }
  void mouseRelease() {
    navigation.mouseRelease();
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
