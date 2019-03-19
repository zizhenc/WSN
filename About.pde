class About implements Screen {
  AnimationPlayer player;
  About(WSN wsn) {
    player=new VideoPlayer(wsn, "The Weak.mp4");
  }
  void setting() {
    player.animation.repeat();
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    player.display(GUI.WIDTH, gui.thisFont.stepX(), gui.thisFont.stepY(), width/2);
    navigation.display();
    popStyle();
  }
  void keyPress() {
    navigation.keyPress();
  }
  void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active())
      player.keyRelease();
  }
  void keyType() {
  }
  void mousePress() {
    navigation.mousePress();
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active())
      player.mouseRelease();
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
