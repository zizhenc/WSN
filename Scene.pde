class Scene implements Screen {
  int time;
  Image image=new Image("Scene.png");
  String[] title={
    "New Graph...", 
    "Node Distributing...", "Link Generating...", "Smallest-last Ordering...", "Smallest-last Coloring...", "Partitioning...", "Relay Coloring...", "Smallest-last Coloring Partites...", "Relay Coloring Partites...", "Smallest-last Coloring Bipartites...", "Relay Coloring Bipartites...", 
    "Terminal Clique...", "Primary Independent Sets...", "Relay Independent Sets...", "Backbones...", "Surplus...", 
    "Degree Distribution Histogram...", 
    "Vertex Degree Plot...", "Color-size Plot...", 
    "New computation...", "New demonstration...", 
    "Color settings...", "System settings...", "Font settings...", 
    "About..."
  };
  void setting() {
    time=millis();
  }
  void display() {
    pushStyle();
    image.display(width>height?GUI.WIDTH:GUI.HEIGHT, 0, 0, max(width, height));
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text(title[navigation.nextPage], gui.thisFont.stepX(), height-gui.thisFont.stepY());
    popStyle();
    if (millis()-time>1000)
      navigation.page=navigation.nextPage;
  }
  void keyPress() {
  }
  void keyType() {
  }
  void keyRelease() {
  }
  void mousePress() {
  }
  void mouseRelease() {
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
