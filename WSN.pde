import processing.video.Movie;
import java.util.Stack;
import java.util.Arrays;
import java.util.Random;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Comparator;
import java.util.ListIterator;
GUI gui=new GUI();
Graph graph;
Screen[] screen;
IO io;
Error error;
Navigation navigation;
Capture capture;
MessageBox box;
void settings() {
  size(gui.getWidth(), gui.getHeight(), P3D);
}
void setup() {
  gui.initialize();
  thread("daemon");
}
void draw() {
  if (gui.load) {
    background(gui.colour[0].value);
    screen[navigation.page].display();
  } else
    gui.display();
  if (box.active)
    box.display();
  if (capture.active)
    capture.display();
}
void keyPressed() {
  if (gui.load&&!capture.active)
    if (box.active)
      box.keyPress();
    else
      screen[navigation.page].keyPress();
}
void keyReleased() {
  if (gui.load)
    if (capture.active)
      capture.keyRelease();
    else if (!box.active)
      screen[navigation.page].keyRelease();
}
void keyTyped() {
  if (gui.load&&!capture.active&&!box.active)
    screen[navigation.page].keyType();
}
void mousePressed() {
  if (gui.load)
    if (capture.active)
      capture.mousePress();
    else if (box.active)
      box.mousePress();
    else
      screen[navigation.page].mousePress();
}
void mouseReleased() {
  if (gui.load&&!capture.active)
    if (box.active)
      box.mouseRelease();
    else
      screen[navigation.page].mouseRelease();
}
void mouseDragged() {
  if (gui.load)
    if (capture.active)
      capture.mouseDrag();
    else if (box.active)
      box.mouseDrag();
    else
      screen[navigation.page].mouseDrag();
}
void mouseWheel(MouseEvent event) {
  if (gui.load)
    screen[navigation.page].mouseScroll(event);
}
void exit() {
  error.clean();
  super.exit();
}
void movieEvent(Movie movie) {
  if (navigation.page>19&&navigation.page<23)
    movie.read();
}
void daemon() {
  if (gui.load)
    graph.compute();
  else {
    error=new Error();
    io=new IO();
    navigation=new Navigation();
    capture=new Capture();
    box=new MessageBox();
    screen=new Screen[]{
      new NewGraph(), 
      new NodeDistributing(), new GraphGenerating(), new SmallestLastOrdering(), new SmallestLastColoring(), new Partitioning(), new RelayColoring(), new SLPartite(), new RLPartite(), new SLBipartite(), new RLBipartite(), 
      new Clique(), new PrimarySet(), new RelaySet(), new Backbone(), new Surplus(), 
      new DegreeDistribution(), new VertexDegreePlot(), new ColorSizePlot(), 
      new NewDeployment(), 
      new ColorSettings(this), new SystemSettings(this), new FontSettings(this), 
      new About(), 
      new Scene()
    };
    gui.load=true;
  }
}
