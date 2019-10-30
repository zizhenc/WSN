import processing.video.Movie;
import java.util.Stack;
import java.util.Arrays;
import java.util.Random;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Comparator;
import java.util.ListIterator;
import java.awt.Desktop;
GUI gui=new GUI();
Graph graph;
Screen[] screen;
IO io;
DialogBox box;
Error error;
Navigation navigation;
Capture capture;
void settings() {
  size(gui.getWidth(), gui.getHeight(), P3D);
}
void setup() {
  gui.initialize();
  thread("daemon");
}
void draw() {
  if (gui.thread>0) {
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
  if (gui.thread>0&&!capture.active)
    if (box.active)
      box.keyPress();
    else
      screen[navigation.page].keyPress();
}
void keyReleased() {
  if (gui.thread>0)
    if (capture.active)
      capture.keyRelease();
    else if (!box.active)
      screen[navigation.page].keyRelease();
}
void keyTyped() {
  if (gui.thread>0&&!capture.active&&!box.active)
    screen[navigation.page].keyType();
}
void mousePressed() {
  if (gui.thread>0)
    if (capture.active)
      capture.mousePress();
    else if (box.active)
      box.mousePress();
    else
      screen[navigation.page].mousePress();
}
void mouseReleased() {
  if (gui.thread>0&&!capture.active)
    if (box.active)
      box.mouseRelease();
    else
      screen[navigation.page].mouseRelease();
}
void mouseDragged() {
  if (gui.thread>0)
    if (capture.active)
      capture.mouseDrag();
    else if (box.active)
      box.mouseDrag();
    else
      screen[navigation.page].mouseDrag();
}
void mouseWheel(MouseEvent event) {
  if (gui.thread>0)
    screen[navigation.page].mouseScroll(event);
}
void exit() {
  error.clean();
  super.exit();
}
void movieEvent(Movie movie) {
  if (navigation.page>20&&navigation.page<24)
    movie.read();
}
void daemon() {
  if (gui.thread>0) {
    switch(gui.thread) {
    case 2:
      graph.compute();
      io.record();
      break;
    case 3:
      io.graphInfo();
      break;
    case 4:
      io.graphSummary();
      break;
    case 5:
      io.primarySetSummary();
      break;
    case 6:
      io.relaySetSummary();
      break;
    case 7:
      io.backboneSummary();
      break;
    case 8:
      io.kCoverage();
    }
  } else {
    error=new Error();
    io=new IO();
    navigation=new Navigation();
    capture=new Capture();
    box=new DialogBox();
    screen=new Screen[]{
      new NewGraph(), 
      new NodeDistributing(), new GraphGenerating(), new SmallestLastOrdering(), new SmallestLastColoring(), new Partitioning(), new RelayColoring(), new SLPartite(), new RLPartite(), new SLBipartite(), new RLBipartite(), 
      new Clique(), new PrimarySet(), new RelaySet(), new Backbone(), new Surplus(), 
      new DegreeDistribution(), new VertexDegreePlot(), new ColorSizePlot(), 
      new NewComputation(), new NewDemonstration(), 
      new ColorSettings(this), new SystemSettings(this), new FontSettings(this), 
      new About(), 
      new Scene()
    };
    gui.thread=1;
  }
}
