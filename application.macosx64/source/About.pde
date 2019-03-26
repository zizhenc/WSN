class About implements Screen {
  Tree tree;
  Animation motion=new GIF("Motion", 72);
  LinkedList<Rocket> rockets=new LinkedList<Rocket>();
  Image forest=new Image("Forest.png"), moon=new Image("Moon.png");
  String info="Author: Zizhen Chen\nWeb name: DragonZ\nZodiac: Aries\nChinese zodiac: Dragon\nEmail: zizhenc@smu.edu\nWebsite: http://lyle.smu.edu/~zizhenc\nAlma mater: Southern Methodist University\nHometown: Shanghai, China";
  float angle;
  void setting() {
    tree=new Stem(0, 0, PI, height/7);
    rockets.clear();
  }
  void display() {
    push();
    for (Rocket rocket : rockets)
      rocket.display();
    textAlign(CENTER);
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text("Wireless Sensor Networks", width/2-forest.imageWidth/2, gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Version: "+gui._V, width/2-forest.imageWidth/2, gui.thisFont.stepY(2));
    gui.body.initialize();
    fill(gui.bodyColor[1].value);
    imageMode(CENTER);
    motion.display(GUI.WIDTH, width/2-forest.imageWidth/2, gui.head.stepY(3)+motion.animeHeight/2, textWidth("Alma mater: Southern Methodist University"));
    text(info, width/2-forest.imageWidth/2, gui.head.stepY(3)+motion.animeHeight+gui.thisFont.stepY());
    translate(width-forest.imageWidth/2, height-navigation.barHeight);
    tree.display();
    tint(255, sin(angle+1.5*PI)*255);
    forest.display(GUI.HEIGHT, 0, navigation.barHeight-height/2, height);
    rotate(angle);
    noStroke();
    fill(255, 216, 0, 200);
    circle(0, height*3/4, height/7);
    fill(255, 216, 0, 90);
    circle(0, height*3/4, height/5);
    tint(255, sin(angle-1.5*PI)*255);
    moon.display(GUI.WIDTH, 0, -height*3/4, height/7);
    popMatrix();
    navigation.display();
    popStyle();
    angle+=0.01;
  }
  void keyPress() {
    navigation.keyPress();
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
    if (navigation.active())
      rockets.addLast(new Rocket());
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
