import java.util.Stack;
import java.util.Random;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.ListIterator;
GUI gui=new GUI();
Error error=new Error();
Graph graph;
Screen[] screen=new Screen[16];
Navigation navigation=new Navigation();
void settings() {
  size(gui.getWidth(), gui.getHeight(), P3D);
}
void setup() {
  gui.initialize();
  thread("loadScreens");
}
void draw() {
  if (gui.load) {
    background(gui.backgroundColor.value);
    screen[navigation.page].display();
  }
  gui.display();
}
void loadScreens() {
  screen[0]=new NewGraph();
  screen[1]=new NodeDistributing();
  screen[2]=new GraphGenerating();
  screen[3]=new SmallestLastOrdering();
  screen[4]=new SmallestLastColoring();
  screen[5]=new Partitioning();
  screen[6]=new RelayColoring();
  screen[7]=new SLPartite();
  screen[8]=new RLPartite();
  screen[9]=new SLBipartite();
  screen[10]=new RLBipartite();
  screen[11]=new Clique();
  screen[12]=new PrimarySet();
  screen[13]=new RelaySet();
  screen[14]=new Backbone();
  screen[15]=new Scene();
  gui.load=true;
}
void keyPressed() {
  if (gui.active())
    gui.keyPress();
  else
    screen[navigation.page].keyPress();
}
void keyReleased() {
  if (!gui.active())
    screen[navigation.page].keyRelease();
}
void keyTyped() {
  if (!gui.active())
    screen[navigation.page].keyType();
}
void mousePressed() {
  if (gui.active())
    gui.mousePress();
  else
    screen[navigation.page].mousePress();
}
void mouseReleased() {
  if (gui.active())
    gui.mouseRelease();
  else
    screen[navigation.page].mouseRelease();
}
void mouseDragged() {
  if (gui.active())
    gui.mouseDrag();
  else
    screen[navigation.page].mouseDrag();
}
void mouseWheel(MouseEvent event) {
  if (!gui.active())
    screen[navigation.page].mouseScroll(event);
}
void exit() {
  error.clean();
  super.exit();
}
