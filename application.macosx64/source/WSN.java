import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.Movie; 
import java.util.Stack; 
import java.util.Arrays; 
import java.util.Random; 
import java.util.HashSet; 
import java.util.LinkedList; 
import java.util.Comparator; 
import java.util.ListIterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class WSN extends PApplet {









GUI gui=new GUI();
Graph graph;
Screen[] screen;
IO io;
DialogBox box;
Error error;
Navigation navigation;
Capture capture;
public void settings() {
  size(gui.getWidth(), gui.getHeight(), P3D);
}
public void setup() {
  gui.initialize();
  thread("daemon");
}
public void draw() {
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
public void keyPressed() {
  if (gui.thread>0&&!capture.active)
    if (box.active)
      box.keyPress();
    else
      screen[navigation.page].keyPress();
}
public void keyReleased() {
  if (gui.thread>0)
    if (capture.active)
      capture.keyRelease();
    else if (!box.active)
      screen[navigation.page].keyRelease();
}
public void keyTyped() {
  if (gui.thread>0&&!capture.active&&!box.active)
    screen[navigation.page].keyType();
}
public void mousePressed() {
  if (gui.thread>0)
    if (capture.active)
      capture.mousePress();
    else if (box.active)
      box.mousePress();
    else
      screen[navigation.page].mousePress();
}
public void mouseReleased() {
  if (gui.thread>0&&!capture.active)
    if (box.active)
      box.mouseRelease();
    else
      screen[navigation.page].mouseRelease();
}
public void mouseDragged() {
  if (gui.thread>0)
    if (capture.active)
      capture.mouseDrag();
    else if (box.active)
      box.mouseDrag();
    else
      screen[navigation.page].mouseDrag();
}
public void mouseWheel(MouseEvent event) {
  if (gui.thread>0)
    screen[navigation.page].mouseScroll(event);
}
public void exit() {
  error.clean();
  super.exit();
}
public void movieEvent(Movie movie) {
  if (navigation.page>19&&navigation.page<23)
    movie.read();
}
public void daemon() {
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
class About implements Screen {
  Tree tree;
  Animation motion=new GIF("Motion", 72);
  LinkedList<Rocket> rockets=new LinkedList<Rocket>();
  Image forest=new Image("Forest.png"), moon=new Image("Moon.png");
  String info="Author: Zizhen Chen\nWeb name: DragonZ\nZodiac: Aries\nChinese zodiac: Dragon\nEmail: zizhenc@smu.edu\nWebsite: http://lyle.smu.edu/~zizhenc\nAlma mater: Southern Methodist University\nHometown: Shanghai, China";
  float angle;
  public void setting() {
    tree=new Stem(0, 0, PI, height/7);
    rockets.clear();
  }
  public void display() {
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
    tint(255, sin(angle+1.5f*PI)*255);
    forest.display(GUI.HEIGHT, 0, navigation.barHeight-height/2, height);
    rotate(angle);
    noStroke();
    fill(255, 216, 0, 200);
    circle(0, height*3/4, height/7);
    fill(255, 216, 0, 90);
    circle(0, height*3/4, height/5);
    tint(255, sin(angle-1.5f*PI)*255);
    moon.display(GUI.WIDTH, 0, -height*3/4, height/7);
    popMatrix();
    navigation.display();
    popStyle();
    angle+=0.01f;
  }
  public void keyPress() {
    navigation.keyPress();
  }
  public void keyRelease() {
    navigation.keyRelease();
  }
  public void keyType() {
  }
  public void mousePress() {
    navigation.mousePress();
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (navigation.active())
      rockets.addLast(new Rocket());
  }
  public void mouseDrag() {
  }
  public void mouseScroll(MouseEvent event) {
  }
}
interface Action {
  public void go();
}
abstract class Animation {
  float animeWidth, animeHeight;
  boolean isPlaying;
  public abstract void play();
  public abstract void pause();
  public abstract void repeat();
  public abstract void end();
  public abstract void jump(float percent);
  public abstract void display(int mode, float x, float y, float factor);
  public abstract int hours();
  public abstract int minutes();
  public abstract int seconds();
  public abstract float position();
  public void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
}
class Backbone extends Result implements Screen {
  int _N, _E;
  Color primary, relay;
  SysColor[] plotColor=new SysColor[3];
  Radio modes=new Radio("Table", "Bar chart");
  Region region=new Region();
  Slider backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  BarChart barChart=new BarChart("Degree", "Vertex", plotColor, "Primary", "Relay", "Total");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  Backbone () {
    word=new String[13];
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
    parts.addLast(giantBlock);
    switches.addLast(showRegion);
    tunes.addLast(backbone);
    table=new ExTable(8, "Degree", "Primary", "Relay", "Total");
    plotColor[2]=gui.partColor[0];
    barChart.setX(0, 7);
    barChart.setPoints();
    for (int i=0; i<8; i++)
      table.setInt(7-i, 0, i);
    tails.value=showRegion.value=false;
  }
  public void setting() {
    initialize();
    setComponent(1);
    backbone.setPreference(1, graph.backbone.length);
  }
  public void setComponent(int index) {
    graph.initailizeBackbones();
    component=graph.getBackbone(index-1);
    primary=component.primary;
    relay=component.relay;
    plotColor[0]=primary;
    plotColor[1]=relay;
    barChart.setY(0, primary.vertices.size()+relay.vertices.size());
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    while (component.deleting());
  }
  public void show() {
    clearStatistics();
    if (giantBlock.value)
      for (Vertex nodeA : component.giant[0])
        if (nodeA.order[component.archive]!=-3)
          showNetwork(nodeA, gui.mainColor);
    if (minorBlocks.value)
      for (LinkedList<Vertex> list : component.blocks)
        if (component.giant[0]!=list)
          for (Vertex nodeA : list)
            if (nodeA.order[component.archive]!=-1&&nodeA.order[component.archive]!=-3)
              showNetwork(nodeA, gui.partColor[0]);
    if (!component.blocks.isEmpty())
      for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
        Vertex nodeA=i.previous().getLast();
        if (minorBlocks.value||giantBlock.value&&nodeA.order[component.archive]==-3) {
          if (showEdge.value) {
            int count=0;
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.links) {
              if (nodeB.order[component.archive]==-2&&!tails.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
                count++;
              else {
                if (nodeB.order[component.archive]==-2)
                  stroke(gui.partColor[1].value);
                else if (nodeB.order[component.archive]>-2)
                  stroke(gui.partColor[0].value);
                else if (nodeB.order[component.archive]<-3)
                  stroke(gui.mainColor.value);
                else if (nodeA.order[component.archive]==-1)
                  stroke(gui.partColor[0].value);
                else
                  stroke(gui.mainColor.value);
                displayEdge(nodeA, nodeB);
              }
            }
            analyze(nodeA, nodeA.links.size()-count);
          }
          showSensor(nodeA);
        }
      }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.links)
            if (nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
              count++;
            else
              displayEdge(nodeA, nodeB);
          analyze(nodeA, nodeA.links.size()-count);
        }
        showSensor(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              analyze(nodeA, nodeA.links.size());
              stroke(gui.partColor[2].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
            }
            showSensor(nodeA);
          }
  }
  public void showNetwork(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[component.archive]==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order[component.archive]==-2?gui.partColor[1].value:colour.value);
          displayEdge(nodeA, nodeB);
        }
      analyze(nodeA, nodeA.links.size()-count);
    }
    showSensor(nodeA);
  }
  public void showSensor(Vertex nodeA) {
    if (showNode.value||showRegion.value) {
      ++_N;
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
    }
    if (showNode.value) {
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode(nodeA);
    }
    if (showRegion.value) {
      strokeWeight(edgeWeight.value);
      region.display(_N, nodeA);
    }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Backbones...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0f/_N:0);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0f/graph.vertex.length);
    word[4]="Components: "+components();
    word[5]="Giant component blocks: "+component.blocks.size();
    int len=7;
    if (graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len+=2;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[len-3]="Faces: "+faces;
      word[len-2]=String.format("Average face size: %.2f", faces>0?_E*2.0f/faces:0);
    }
    word[len-1]="Primary partite #"+(primary.index+1)+" & relay partite #"+(relay.index+1);
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(16+i+1));
    if (modes.value==1) {
      barChart.showFrame(gui.thisFont.stepX(3), gui.thisFont.stepY(16+len)+gui.thisFont.gap(), gui.margin(), gui.margin());
      barChart.showLabels(gui.thisFont.stepX(2)+gui.margin()-textWidth("Degree"), gui.thisFont.stepY(18+len));
      strokeWeight(7.5f);
      barChart.drawPlot[0].display();
      barChart.showMeasurements();
    } else
      table.display(gui.thisFont.stepX(3), gui.thisFont.stepY(16+len)+gui.thisFont.gap());
  }
  public void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  public void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (modes.value==1) {
      fill(gui.headColor[2].value);
      text("Plots:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+gui.thisFont.gap()+modes.radioHeight);
      for (int i=0; i<plot.length; i++)
        plot[i].display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+gui.thisFont.gap(2)+modes.radioHeight+(plot[0].checkerHeight+gui.thisFont.gap())*i);
    }
  }
  public void moreMousePresses() {
    if (backbone.active())
      setComponent(round(backbone.value));
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  public void moreMouseReleases() {
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    modes.active();
    if (modes.value==1)
      for (int i=0; i<plot.length; i++)
        if (plot[i].active())
          barChart.setPlot(i, plot[i].value);
  }
  public void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (backbone.value==backbone.min)
        backbone.setValue(backbone.max);
      else
        backbone.decreaseValue();
      setComponent(round(backbone.value));
      break;
    case '.':
    case '>':
      if (backbone.value==backbone.max)
        backbone.setValue(backbone.min);
      else
        backbone.increaseValue();
      setComponent(round(backbone.value));
    }
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='t') {
      showRegion.value=!showRegion.value;
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    }
  }
  public int components() {
    int amount=0;
    if (giantBlock.value&&minorBlocks.value)
      amount=component.giant[0].isEmpty()?0:1;
    else if (giantBlock.value) {
      if (!component.giant[0].isEmpty())
        amount=1;
    } else if (minorBlocks.value) {
      amount=component.tails[4];
    }
    if (tails.value) {
      if (!giantBlock.value&&!minorBlocks.value)
        amount+=component.tails[0];
      else if (!giantBlock.value)
        amount+=component.tailsXMinors();
      else if (!minorBlocks.value)
        amount+=component.tailsXGiant();
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
  public void clearStatistics() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    domain.clear();
    switch(modes.value) {
    case 0:
      for (int i=0; i<8; i++)
        for (int j=0; j<plot.length; j++)
          table.setInt(i, j+1, 0);
      break;
    case 1:
      for (ArrayList<Float> point : barChart.points)
        for (int i=0; i<8; i++)
          point.set(i, 0f);
    }
  }
  public void analyze(Vertex node, int degree) {
    int category=node.primeColor==primary?0:1;
    switch(modes.value) {
    case 0:
      table.setInt(7-degree, category+1, table.getInt(7-degree, category+1)+1);
      table.setInt(7-degree, 3, table.getInt(7-degree, 3)+1);
      break;
    case 1:
      barChart.points[category].set(degree, barChart.points[category].get(degree)+1);
      barChart.points[2].set(degree, barChart.points[2].get(degree)+1);
    }
  }
}
 class Ball extends Topology {
  Ball() {
    range=xRange=yRange=zRange=2;
    value=8;
  }
  public double getAvg(double r, int n) {
    double avg=8*n*r*r*r/(xRange*yRange*zRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.pow((avg+1)/n, 1.0f/3)*range/2;
      return r>range?range:r;
    }
  }
  public String toString() {
    return "Ball";
  }
  public Vertex generateVertex(int value) {
    //return new Vertex(Math.pow(rnd.nextDouble(), 1/3.0), Math.sqrt(rnd.nextDouble())*Math.PI, rnd.nextDouble()*2*Math.PI, index);
    double u=Math.pow(rnd.nextDouble(), 1.0f/3), a=rnd.nextDouble()*xRange-xRange/2, b=rnd.nextDouble()*yRange-yRange/2, c=rnd.nextDouble()*zRange-zRange/2;
    return new Vertex(value, xRange*u*a/(2*Math.sqrt(a*a+b*b+c*c)), yRange*u*b/(2*Math.sqrt(a*a+b*b+c*c)), zRange*u*c/(2*Math.sqrt(a*a+b*b+c*c)), connectivity());
  }
}
class BarChart extends Chart {
  BarChart(String labelX, String labelY, SysColor[] colors, String...bar) {
    super(labelX, labelY, colors, bar);
    drawPlot=new DrawPlot[] {
      new DrawPlot() {
        public void display() {
          float barWidth=intervalX/plot.length*g.strokeWeight/10;
          pushStyle();
          strokeWeight(barWidth);
          strokeCap(SQUARE);
          for (int i=0, sequence=0; i<plot.length; i++)
          if (active[i]) {
            stroke(colour[i].value);
            for (int j=0; j<=maxX-minX; j++) {
              float value=points[i].get(j);
              if (value>0)
                line(xStart+gapX/2+j*intervalX-barWidth*plots/2+(sequence+0.5f)*barWidth, yStart, xStart+gapX/2+j*intervalX-barWidth*plots/2+(sequence+0.5f)*barWidth, yStart-value*intervalY);
            }
            sequence++;
          }
          popStyle();
        }
        public void display(int index) {
          display(index, minX);
        }
        public void display(int index, int beginIndex) {
          if (active[index]) {
            float barWidth=intervalX*g.strokeWeight/10;
            pushStyle();
            strokeWeight(barWidth);
            strokeCap(SQUARE);
            stroke(colour[index].value);
            for (int i=beginIndex-minX; i<=points[index].size(); i++) {
              float value=points[index].get(i-beginIndex+minX);
              if (value>0)
                line(xStart+gapX/2+i*intervalX, yStart, xStart+gapX/2+i*intervalX, yStart-value*intervalY);
            }
            popStyle();
          }
        }
      }
    };
  }
  public void showScaleX(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=beginIndex; i<=(endIndex-beginIndex)/stepX; i++)
      line(x+i*gapX+gapX/2, y+gui.thisFont.gap(), x+i*gapX+gapX/2, y);
    strokeWeight(gui.unit(2));
    line(x, y, x+(endIndex-beginIndex+1)*intervalX, y);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepX; i++)
      text(i*stepX+beginIndex, x+i*gapX+gapX/2, y+gui.thisFont.stepY());
    popStyle();
  }
  public void showScaleY(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=1; i<=(endIndex-beginIndex)/stepY; i++)
      line(x, y-gapY*i, x-gui.thisFont.gap(), y-gapY*i);
    strokeWeight(gui.unit(2));
    line(x, y, x, y-(endIndex-beginIndex)*intervalY);
    fill(gui.bodyColor[0].value);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepY; i++)
      text(i*stepY+beginIndex, x-gui.thisFont.stepX(), y-gapY*i);
    popStyle();
  }
  public float getX() {
    return min(max(minX, (mouseX-xStart-gapX/2)/intervalX), maxX);
  }
  public float getX(float index) {
    return xStart+gapX/2+index*intervalX;
  }
  public float getY() {
    return min(max(minY, (yStart-mouseY)/intervalY), maxY);
  }
  public float getY(float index) {
    return yStart-index*intervalY;
  }
}
abstract class Bipartite extends Procedure implements Screen {
  int _N, _E;
  boolean goOn;
  Color primary, relay;
  SysColor[] plotColor=new SysColor[3];
  Radio modes=new Radio("Table", "Bar chart");
  Region region=new Region();
  Slider edgeWeight=new Slider("Edge weight"), backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), giantComponent=new Checker("Giant component"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  BarChart barChart=new BarChart("Degree", "Vertex", plotColor, "Primary", "Relay", "Total");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  public abstract int getAmount();
  public abstract void setComponent(int index);//index starts from 1
  Bipartite() {
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(giantComponent);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    tunes.addLast(edgeWeight);
    tunes.addLast(backbone);
    table=new ExTable(8, "Degree", "Primary", "Relay", "Total");
    plotColor[2]=gui.partColor[0];
    for (int i=0; i<8; i++)
      table.setInt(7-i, 0, i);
    barChart.setX(0, 7);
    barChart.setPoints();
    tails.value=showRegion.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.001f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    setComponent(1);
    backbone.setPreference(1, getAmount());
  }
  public void resetParts() {
    goOn=true;
    if (parts.getLast()==giantBlock) {
      parts.removeLast();
      parts.removeLast();
      parts.addLast(giantComponent);
    }
  }
  public void reset() {
    resetParts();
    plotColor[0]=primary;
    plotColor[1]=relay;
    barChart.setY(0, primary.vertices.size()+relay.vertices.size());
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    interval.setPreference(1, ceil((primary.vertices.size()+relay.vertices.size())/3.0f), 1);
  }
  public void restart() {
    resetParts();
    component.restart();
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&!goOn) {
        if (parts.getLast()==giantComponent) {
          parts.removeLast();
          parts.addLast(minorBlocks);
          parts.addLast(giantBlock);
        }
        if (navigation.auto) {
          if (backbone.value<backbone.max) {
            backbone.increaseValue();
            setComponent(round(backbone.value));
          } else
            navigation.go(410);
        }
        play.value=navigation.auto;
      }
      if (play.value)
        goOn=component.deleting();
    }
  }
  public void show() {
    clearStatistics();
    if (goOn) {
      if (giantComponent.value)
        for (int i=1; i<component.degreeList.length; i++)
          for (Vertex nodeA=component.degreeList[i].next; nodeA!=null; nodeA=nodeA.next)
            showNetwork(nodeA, gui.mainColor);
    } else {
      if (giantBlock.value)
        for (Vertex nodeA : component.giant[0])
          if (nodeA.order[component.archive]!=-3)
            showNetwork(nodeA, gui.mainColor);
      if (minorBlocks.value)
        for (LinkedList<Vertex> list : component.blocks)
          if (component.giant[0]!=list)
            for (Vertex nodeA : list)
              if (nodeA.order[component.archive]!=-1&&nodeA.order[component.archive]!=-3)
                showNetwork(nodeA, gui.partColor[0]);
      if (!component.blocks.isEmpty())
        for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
          Vertex nodeA=i.previous().getLast();
          if (minorBlocks.value||giantBlock.value&&nodeA.order[component.archive]==-3) {
            if (showEdge.value) {
              int count=0;
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links) {
                if (nodeB.order[component.archive]==-2&&!tails.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
                  count++;
                else {
                  if (nodeB.order[component.archive]==-2)
                    stroke(gui.partColor[1].value);
                  else if (nodeB.order[component.archive]>-2)
                    stroke(gui.partColor[0].value);
                  else if (nodeB.order[component.archive]<-3)
                    stroke(gui.mainColor.value);
                  else if (nodeA.order[component.archive]==-1)
                    stroke(gui.partColor[0].value);
                  else
                    stroke(gui.mainColor.value);
                  displayEdge(nodeA, nodeB);
                }
              }
              analyze(nodeA, nodeA.links.size()-count);
            }
            showSensor(nodeA);
          }
        }
    }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.links)
            if (goOn) {
              if (nodeB.order[component.archive]!=-2&&!giantComponent.value)
                count++;
              else
                displayEdge(nodeA, nodeB);
            } else {
              if (nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
                count++;
              else
                displayEdge(nodeA, nodeB);
            }
          analyze(nodeA, nodeA.links.size()-count);
        }
        showSensor(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              analyze(nodeA, nodeA.links.size());
              stroke(gui.partColor[2].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
            }
            showSensor(nodeA);
          }
  }
  public void showNetwork(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[component.archive]==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order[component.archive]==-2?gui.partColor[1].value:colour.value);
          displayEdge(nodeA, nodeB);
        }
      analyze(nodeA, nodeA.links.size()-count);
    }
    showSensor(nodeA);
  }
  public void showSensor(Vertex nodeA) {
    if (showNode.value||showRegion.value) {
      ++_N;
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
    }
    if (showNode.value) {
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode(nodeA);
    }
    if (showRegion.value) {
      strokeWeight(edgeWeight.value);
      region.display(_N, nodeA);
    }
  }
  public void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0f/_N:0);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0f/graph.vertex.length);
    word[4]="Components: "+components();
    if (!goOn)
      word[5]="Giant component blocks: "+component.blocks.size();
    int len=goOn?6:7;
    if (graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len+=2;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[len-3]="Faces: "+faces;
      word[len-2]=String.format("Average face size: %.2f", faces>0?_E*2.0f/faces:0);
    }
    word[len-1]="Primary partite #"+(primary.index+1)+" & relay partite #"+(relay.index+1);
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+i+1));
    if (modes.value==1) {
      barChart.showFrame(gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+len)+gui.thisFont.gap(), gui.margin(), gui.margin());
      barChart.showLabels(gui.thisFont.stepX(2)+gui.margin()-textWidth("Degree"), gui.thisFont.stepY(startHeight+len+2));
      strokeWeight(7.5f);
      barChart.drawPlot[0].display();
      barChart.showMeasurements();
    } else
      table.display(gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+len)+gui.thisFont.gap());
  }
  public void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  public void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (modes.value==1) {
      fill(gui.headColor[2].value);
      text("Plots:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+gui.thisFont.gap()+modes.radioHeight);
      for (int i=0; i<plot.length; i++)
        plot[i].display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+gui.thisFont.gap(2)+modes.radioHeight+(plot[0].checkerHeight+gui.thisFont.gap())*i);
    }
  }
  public void moreMousePresses() {
    edgeWeight.active();
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  public void moreMouseReleases() {
    showEdge.active();
    modes.active();
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (modes.value==1)
      for (int i=0; i<plot.length; i++)
        if (plot[i].active())
          barChart.setPlot(i, plot[i].value);
    if (backbone.active())
      setComponent(round(backbone.value));
  }
  public void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (backbone.value==backbone.min)
        backbone.setValue(backbone.max);
      else
        backbone.decreaseValue();
      setComponent(round(backbone.value));
      break;
    case '.':
    case '>':
      if (backbone.value==backbone.max)
        backbone.setValue(backbone.min);
      else
        backbone.increaseValue();
      setComponent(round(backbone.value));
    }
  }
  public void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    }
  }
  public int components() {
    int amount=0;
    if (goOn) {
      if (giantComponent.value)
        amount=component.giant[1].isEmpty()?0:1;
      else if (tails.value) {
        component.countTails();
        amount=component.tails[0];
      }
    } else {
      if (giantBlock.value&&minorBlocks.value)
        amount=component.giant[0].isEmpty()?0:1;
      else if (giantBlock.value) {
        if (!component.giant[0].isEmpty())
          amount=1;
      } else if (minorBlocks.value) {
        amount=component.tails[4];
      }
      if (tails.value) {
        if (!giantBlock.value&&!minorBlocks.value)
          amount+=component.tails[0];
        else if (!giantBlock.value)
          amount+=component.tailsXMinors();
        else if (!minorBlocks.value)
          amount+=component.tailsXGiant();
      }
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
  public void clearStatistics() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    domain.clear();
    switch(modes.value) {
    case 0:
      for (int i=0; i<8; i++)
        for (int j=0; j<plot.length; j++)
          table.setInt(i, j+1, 0);
      break;
    case 1:
      for (ArrayList<Float> point : barChart.points)
        for (int i=0; i<8; i++)
          point.set(i, 0f);
    }
  }
  public void analyze(Vertex node, int degree) {
    int category=node.primeColor==primary?0:1;
    switch(modes.value) {
    case 0:
      table.setInt(7-degree, category+1, table.getInt(7-degree, category+1)+1);
      table.setInt(7-degree, 3, table.getInt(7-degree, 3)+1);
      break;
    case 1:
      barChart.points[category].set(degree, barChart.points[category].get(degree)+1);
      barChart.points[2].set(degree, barChart.points[2].get(degree)+1);
    }
  }
}
class Bottle extends Topology {
  Bottle() {
    range=4.58f;
    yRange=4.4f;
    xRange=3.712f;
    zRange=22.0f/15;
    value=6;
  }
  public double getAvg(double r, int n) {
    double avg=n*r*r/(2*Math.PI)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(2*Math.PI*(avg+1)/n);
      return r>range?range:r;
    }
  }
  public String toString() {
    return "Bottle";
  }
  public Vertex generateVertex(int index) {
    double[] u={rnd.nextDouble()*Math.PI, rnd.nextDouble()*2*Math.PI};
    return new Vertex(index, 2*Math.cos(u[0])*(30*Math.sin(u[0])+60*Math.sin(u[0])*Math.pow(Math.cos(u[0]), 6)-3*Math.cos(u[1])-5*Math.sin(u[0])*Math.cos(u[0])*Math.cos(u[1])-90*Math.sin(u[0])*Math.pow(Math.cos(u[0]), 4))/15, 
      -2+Math.sin(u[0])*(3*Math.cos(u[0])*Math.cos(u[0])*Math.cos(u[1])+48*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 4)+60*Math.sin(u[0])+5*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 3)+80*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 5)-3*Math.cos(u[1])-48*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 6)-5*Math.sin(u[0])*Math.cos(u[0])*Math.cos(u[1])-80*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 7))/15, 
      Math.sin(u[1])*2*(3+5*Math.sin(u[0])*Math.cos(u[0]))/15, connectivity());
  }
}
class Branch extends Tree {
  Branch(Tree parent, float x, float y, float angleOffset, float tall) {
    super(x, y, tall);
    branch=new Tree[3];
    branch[2]=parent;//null
    angle=parent.angle+angleOffset;
    this.angleOffset = angleOffset;
    birth();
  }
  public void display() {
    x=branch[2].x+sin(branch[2].angle)*gui.unit(branch[2].tall)*branch[2].growth;
    y=branch[2].y+cos(branch[2].angle)*gui.unit(branch[2].tall)*branch[2].growth;
    windForce=branch[2].windForce*(1.0f+5.0f/tall)+blastForce;
    blastForce=(blastForce+sin(x/2+windAngle)*0.01f/tall)*0.98f;
    angle=branch[2].angle+angleOffset+windForce+blastForce;
    if (growth<1)
      growth+=0.02f*branch[2].growth;
    show();
  }
  public void drawBranch() {
    for (int i=0; i!=2; i++)
      if (branch[i]!=null)
        drawBranch(branch[i]);
  }
  public void drawBranch(Tree child) {
    float xB=x+gui.unit(x-branch[2].x)*0.4f, yB=y+gui.unit(y-branch[2].y)*0.4f;
    stroke(floor(2000/tall));
    strokeWeight(gui.unit(tall/5));
    noFill();
    bezier(x, y, xB, yB, xB, yB, child.x, child.y);
    child.display();
  }
}
class Button {
  int alignment;//CORNER or CENTER
  float x, y, buttonHeight, buttonWidth;//x and y is real coordinates
  String label;
  Button() {
  }
  Button(String label) {
    this.label=label;
  }
  public boolean active() {
    if (alignment==CENTER)
      return mouseX>x-buttonWidth/2&&mouseX<x+buttonWidth/2&&mouseY>y-buttonHeight/2&&mouseY<y+buttonHeight/2;
    else
      return mouseX>x&&mouseX<x+buttonWidth&&mouseY>y&&mouseY<y+buttonHeight;
  }
  public void display(float x, float y) {
    display(x, y, textWidth(label)+gui.thisFont.stepX(2), gui.thisFont.stepY(2));
  }
  public void display(int mode, float x, float y, float factor) {
    if (mode==GUI.WIDTH)
      display(x, y, factor, gui.thisFont.stepY(2));
    else if (mode==GUI.HEIGHT)
      display(x, y, textWidth(label)+gui.thisFont.stepX(2), factor);
  }
  public void display(float x, float y, float buttonWidth, float buttonHeight) {
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.buttonWidth=buttonWidth;
    this.buttonHeight=buttonHeight;
    pushStyle();
    rectMode(alignment);
    textAlign(CENTER, CENTER);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    noFill();
    rect(x, y, buttonWidth, buttonHeight, gui.unit(8), 0, gui.unit(8), 0);
    if (active()) {
      fill(gui.colour[2].value, 70);
      noStroke();
      rect((alignment==CENTER?0:gui.unit(3))+x, (alignment==CENTER?0:gui.unit(3))+y, buttonWidth-gui.unit(6), buttonHeight-gui.unit(6), gui.unit(10), 0, gui.unit(10), 0);
      fill(gui.bodyColor[mousePressed?0:2].value);
    } else
      fill(gui.bodyColor[2].value);
    text(label, (alignment==CENTER?0:buttonWidth/2)+x, (alignment==CENTER?0:buttonHeight/2)+y);
    popStyle();
  }
}
 class Capture {
  int x, y, captureWidth, captureHeight, time;
  StringBuffer path=new StringBuffer("Screenshots");
  boolean active, finish, mode;
  public void store() {
    active=true;
    finish=!mode;
    x=y=captureWidth=captureHeight=0;
    if (finish) {
      saveFrame(path+System.getProperty("file.separator")+"WSN-"+frameCount+".png");
      time=millis();
    }
  }
  public void display() {
    pushStyle();
    gui.body.initialize();
    rectMode(CORNER);
    if (mode) {
      stroke(gui.colour[1].value);
      strokeWeight(gui.unit(2));
      dottedLine(0, mouseY, width, mouseY);
      dottedLine(mouseX, 0, mouseX, height);
      if (captureWidth!=0&&captureHeight!=0) {
        fill(gui.bodyColor[2].value);
        String prompt="Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to crop.";
        textAlign(RIGHT);
        text(prompt, x-gui.thisFont.stepX()+(captureWidth>0?captureWidth:0), y+gui.thisFont.stepY()+(captureHeight>0?captureHeight:0));
      } 
      noFill();
      rect(x, y, captureWidth, captureHeight);
    }
    if (finish) {
      fill(gui.colour[2].value);
      noStroke();
      if (millis()-time<200)
        rect(0, 0, width, height);
      else
        active=false;
    }
    popStyle();
  }
  public void dottedLine(float x1, float y1, float x2, float y2) {
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
  }
  public void keyRelease() {
    if (mode&&(key==ENTER||key==RETURN)&&captureWidth!=0&&captureHeight!=0) {
      get(x+(captureWidth>0?0:captureWidth), y+(captureHeight>0?0:captureHeight), abs(captureWidth), abs(captureHeight)).save(path+System.getProperty("file.separator")+"WSN-"+frameCount+".png");
      x=y=captureWidth=captureHeight=0;
      finish=true;
      time=millis();
    }
  }
  public void mousePress() {
    if (mode) {
      x=mouseX;
      y=mouseY;
      captureWidth=captureHeight=0;
    }
  }
  public void mouseDrag() {
    if (mode) {
      captureWidth=mouseX-x;
      captureHeight=mouseY-y;
    }
  }
}
class CartesianCell extends CellSystem {
  int xN=graph.r==0?0:(int)Math.floor(graph.topology.xRange/graph.r)+1, yN=graph.r==0?0:(int)Math.floor(graph.topology.yRange/graph.r)+1, zN=graph.r==0?0:(int)Math.floor(graph.topology.zRange/graph.r)+1, x, y, z;
  LinkedList<Vertex>[][][] cell;
  ListIterator<Vertex> i;
  CartesianCell() {
    cell=new LinkedList[xN][yN][zN];
    for (int a=0; a<xN; a++)
      for (int b=0; b<yN; b++)
        for (int c=0; c<zN; c++)
          cell[a][b][c]=new LinkedList<Vertex>(); 
    if (graph.r==0)
      for (Vertex node : graph.vertex)
        cell[0][0][0].addLast(node);
    else
      for (Vertex node : graph.vertex)
        cell[(int)Math.floor((node.x+graph.topology.xRange/2)/graph.r)][(int)Math.floor((node.y+graph.topology.yRange/2)/graph.r)][(int)Math.floor((node.z+graph.topology.zRange/2)/graph.r)].addLast(node);
  }
  public void initialize() {
    x=y=z=0;
    i=cell[x][y][z].listIterator();
  }
  public boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    if (i.hasNext()) {
      count++;
      Vertex nodeA=i.next();
      nodeA.lowpoint=0;
      for (ListIterator<Vertex> j=cell[x][y][z].listIterator(i.nextIndex()); j.hasNext(); )
        link(nodeA, j.next());
      if (x+1!=xN) {
        if (y-1!=-1)
          for (Vertex nodeB : cell[x+1][y-1][z])
            link(nodeA, nodeB);
        for (Vertex nodeB : cell[x+1][y][z])
          link(nodeA, nodeB);
        if (y+1!=yN)
          for (Vertex nodeB : cell[x+1][y+1][z])
            link(nodeA, nodeB);
      }
      if (y+1!=yN)
        for (Vertex nodeB : cell[x][y+1][z])
          link(nodeA, nodeB);
      if (z+1!=zN) {
        if (x-1!=-1) {
          if (y-1!=-1)
            for (Vertex nodeB : cell[x-1][y-1][z+1])
              link(nodeA, nodeB);
          for (Vertex nodeB : cell[x-1][y][z+1])
            link(nodeA, nodeB);
          if (y+1!=yN)
            for (Vertex nodeB : cell[x-1][y+1][z+1])
              link(nodeA, nodeB);
        }
        if (y-1!=-1)
          for (Vertex nodeB : cell[x][y-1][z+1])
            link(nodeA, nodeB);
        for (Vertex nodeB : cell[x][y][z+1])
          link(nodeA, nodeB);
        if (y+1!=yN)
          for (Vertex nodeB : cell[x][y+1][z+1])
            link(nodeA, nodeB);
        if (x+1!=xN) {
          if (y-1!=-1)
            for (Vertex nodeB : cell[x+1][y-1][z+1])
              link(nodeA, nodeB);
          for (Vertex nodeB : cell[x+1][y][z+1])
            link(nodeA, nodeB);
          if (y+1!=yN)
            for (Vertex nodeB : cell[x+1][y+1][z+1])
              link(nodeA, nodeB);
        }
      }
    } else {
      y++;
      if (y==yN) {
        y=0;
        x++;
        if (x==xN) {
          x=0;
          z++;
        }
      }
      i=cell[x][y][z].listIterator();
    }
    return true;
  }
}
class Cell extends Method {
  CellSystem[] coordinate=new CellSystem[3];
  public boolean connecting() {
    return coordinate[index].connecting();
  }
  public void reset() {
    if (coordinate[index]==null)
      switch(index) {
      case 0:
        coordinate[0]=new CartesianCell();
        break;
      case 1:
        coordinate[1]=new CylindricalCell();
        break;
      case 2:
        coordinate[2]=new SphericalCell();
      }
    coordinate[index].reset();
  }
}
abstract class CellSystem {
  int count;
  public abstract boolean connecting();
  public abstract void initialize();
  public void reset() {
    count=0;
    initialize();
  }
  public void link(Vertex nodeA, Vertex nodeB) {
    if (nodeA.distance(nodeB)<graph.r) {
      graph._E++;
      nodeB.lowpoint=0;
      nodeA.neighbors.addLast(nodeB);
      nodeB.neighbors.addLast(nodeA);
    }
  }
}
abstract class Chart {
  int stepX, stepY, minX, maxX, minY, maxY, plots;
  float intervalX, intervalY, gapX, gapY, rangeX, rangeY, x, y, chartWidth, chartHeight, xStart, yStart;
  boolean[] active;
  String labelX, labelY;
  String[] plot;
  ArrayList<Float>[] points;
  DrawPlot[] drawPlot;
  SysColor[] colour;
  public abstract float getX();//return current mouseX index 
  public abstract float getY();//return current mouseY index
  public abstract float getX(float index);//return x position of index
  public abstract float getY(float index);//return y position of index
  public abstract void showScaleX(float x, float y, int beginIndex, int endIndex);
  public abstract void showScaleY(float x, float y, int beginIndex, int endIndex);
  Chart(String labelX, String labelY, SysColor[] colour, String...plot) {
    this.labelX=labelX;
    this.labelY=labelY;
    this.colour=colour;
    this.plot=plot;
    plots=plot.length;
    points=new ArrayList[plots];
    active=new boolean[plots];
    for (int i=0; i!=plots; i++) {
      points[i]=new ArrayList<Float>();
      active[i]=true;
    }
  }
  public void showFrame(float x, float y, float chartWidth, float chartHeight) {
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.chartWidth=chartWidth;
    this.chartHeight=chartHeight;
    rangeX=chartWidth-gui.thisFont.stepX(2)-textWidth(labelX+maxY+maxX);
    rangeY=chartHeight-gui.thisFont.stepY(2)-gui.thisFont.gap(2);
    xStart=x+textWidth(maxY+"")+gui.thisFont.stepX();
    yStart=y+gui.thisFont.stepY()+gui.thisFont.gap()+rangeY;
    stepX=stepY=1;
    intervalX=gapX=rangeX/(maxX-minX+1);
    intervalY=gapY=rangeY/(maxY-minY);
    while (gapX<textWidth(maxX+" ")) {
      stepX++;
      gapX=rangeX*stepX/(maxX-minX+1);
    }
    while (gapY<gui.thisFont.stepY()) {
      stepY++;
      gapY=rangeY*stepY/(maxY-minY);
    }
    pushStyle();
    arrow(xStart, yStart-rangeY, xStart, y+gui.thisFont.stepY());
    arrow(xStart+rangeX, yStart, x+chartWidth-gui.thisFont.stepX()-textWidth(labelX), yStart);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    line(xStart, yStart, xStart-gui.thisFont.gap(0.5f), yStart);
    line(xStart, yStart, xStart, yStart+gui.thisFont.gap(0.5f));
    fill(gui.headColor[0].value);
    textAlign(LEFT, TOP);
    text(labelY, x, y);
    textAlign(LEFT, CENTER);
    text(labelX, x+chartWidth-textWidth(labelX), yStart);
    showScaleY(xStart, yStart, minY, maxY);
    showScaleX(xStart, yStart, minX, maxX);
    popStyle();
  }
  public void showLabels(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    noStroke();
    for (int i=0, sequence=0; i<plot.length; i++)
      if (active[i]) {
        fill(colour[i].value);
        rect(x, y+gui.thisFont.stepY(sequence-0.5f), gui.thisFont.gap(), gui.thisFont.gap());
        text(plot[i], x+gui.thisFont.gap(2), y+gui.thisFont.stepY(sequence-0.5f)+gui.thisFont.gap(0.5f));
        sequence++;
      }
    popStyle();
  }
  public boolean active() {
    return mouseX>x+textWidth(maxY+"")&&mouseX<x+chartWidth-textWidth(labelX)&&mouseY>=y&&mouseY<=y+chartHeight-gui.thisFont.stepY();
  }
  public void showMeasurements() {
    if (active()) {
      pushStyle();
      dottedLine(x, mouseY, x+chartWidth, mouseY);
      dottedLine(mouseX, y, mouseX, y+chartHeight);
      fill(gui.headColor[1].value);
      float xPos, yPos;
      int alignX, alignY;
      if (mouseX<x+chartWidth/2) {
        alignX=LEFT;
        xPos=mouseX+gui.thisFont.stepX();
      } else {
        alignX=RIGHT;
        xPos=mouseX-gui.thisFont.stepX();
      }
      if (mouseY>y+chartHeight/2) {
        alignY=BOTTOM;
        yPos=mouseY-gui.thisFont.gap();
      } else {
        alignY=TOP;
        yPos=mouseY+gui.thisFont.gap();
      }
      textAlign(alignX, alignY);
      text(String.format("(%.2f, %.2f)", getX(), getY()), xPos, yPos);
      popStyle();
    }
  }
  public void setPlot(int index, boolean onOff) {
    if (active[index]!=onOff) {
      if (onOff)
        plots++;
      else
        plots--;
      active[index]=onOff;
    }
  }
  public void setPoints() {
    for (ArrayList<Float> point : points) {
      while (point.size()<=maxX-minX)
        point.add(0f);
      while (point.size()>maxX-minX+1)
        point.remove(point.size()-1);
    }
  }
  public void setPoints(int index) {
    setPoints(index, minX, maxX);
  }
  public void setPoints(int index, int minX, int maxX) {
    while (points[index].size()<=maxX-minX)
      points[index].add(0f);
    while (points[index].size()>maxX-minX+1)
      points[index].remove(points[index].size()-1);
  }
  public void setX(int minX, int maxX) {
    this.minX=minX;
    this.maxX=maxX;
  }
  public void setY(int minY, int maxY) {
    this.minY=minY;
    this.maxY=maxY;
  }
  public void arrow(float x1, float y1, float x2, float y2) {
    push();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    line(x1, y1, x2, y2);
    translate(x2, y2);
    rotate(atan2(x1-x2, y2-y1));
    line(0, 0, -gui.unit(3), -gui.unit(6));
    line(0, 0, gui.unit(3), -gui.unit(6));
    pop();
  }
  public void dottedLine(float x1, float y1, float x2, float y2) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
    popStyle();
  }
}
abstract class Charts {
  float centralX, centralY, centralZ, eyeX, eyeY, eyeZ;
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  Switcher showMeasurement=new Switcher("Measurement", "Measurement");
  Slider edgeWeight=new Slider("Edge weight");
  Button[] button={new Button("Restore"), new Button("Screenshot")};
  Chart chart;
  Charts() {
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
  }
  public abstract void show();
  public abstract void moreKeyReleases();
  public void display() {
    pushStyle();
    gui.body.initialize();
    controls();
    pushMatrix();
    camera(width/2+eyeX, height/2+eyeY, (height/2)/tan(PI/6.0f)+eyeZ, centralX+width/2, centralY+height/2, centralZ, 0, 1, 0);
    chart.showFrame(gui.thisFont.gap(), gui.thisFont.gap(), width-gui.margin()-gui.thisFont.gap(), height-gui.thisFont.gap(2)-navigation.barHeight);
    if (showMeasurement.value)
      chart.showMeasurements();
    show();
    popMatrix();
    navigation.display();
    popStyle();
  }
  public void controls() {
    fill(gui.headColor[1].value);
    text("Welcome to DragonZ-WSN world!", width-gui.margin(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Controls:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(2));
    for (int i=0; i<button.length; i++)
      button[i].display(GUI.WIDTH, width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(2)+gui.thisFont.gap(i+1)+button[0].buttonHeight*i, gui.margin()-gui.thisFont.stepX(3));
    fill(gui.headColor[2].value);
    text("Switches:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap()));
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+showMeasurement.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
    fill(gui.headColor[2].value);
    text("Labels:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(6)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*tunes.size());
    chart.showLabels(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(7)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*tunes.size());
  }
  public void relocate() {
    centralX=centralY=centralZ=eyeX=eyeY=eyeZ=0;
  }
  public void keyPress() {
    navigation.keyPress();
    if (!navigation.active())
      switch(Character.toLowerCase(key)) {
      case 'a':
        eyeX-=40;
        break;
      case 'd':
        eyeX+=40;
        break;
      case 's':
        eyeZ+=10;
        break;
      case 'w':
        eyeZ-=10;
        break;
      case CODED:
        switch(keyCode) {
        case DOWN:
          eyeY-=10;
          centralY-=10;
          break;
        case UP:
          eyeY+=10;
          centralY+=10;
          break;
        case RIGHT:
          eyeX-=10;
          centralX-=10;
          break;
        case LEFT:
          eyeX+=10;
          centralX+=10;
        }
      }
  }
  public void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'x':
        capture.store();
        break;
      case 'g':
        relocate();
        break;
      case 'm':
        showMeasurement.value=!showMeasurement.value;
      }
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker part=i.next();
        if (key==PApplet.parseChar(i.previousIndex()+48)) {
          part.value=!part.value;
          chart.setPlot(i.previousIndex(), part.value);
        }
      }
      moreKeyReleases();
    }
  }
  public void keyType() {
  }
  public void mousePress() {
    navigation.mousePress();
    if (!navigation.active())
      for (Slider slider : tunes)
        slider.active();
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      for (Switcher switcher : switches)
        switcher.active();
      if (button[0].active())
        relocate();
      if (button[1].active())
        capture.store();
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker checker=i.next();
        if (checker.active())
          chart.setPlot(i.previousIndex(), checker.value);
      }
    }
  }
  public void mouseDrag() {
    if (mouseButton==RIGHT) {
      eyeX-=mouseX-pmouseX;
      eyeY-=mouseY-pmouseY;
    }
  }
  public void mouseScroll(MouseEvent event) {
    eyeZ+=event.getCount()*10;
  }
}
class Checker {
  float x, y, checkerWidth, checkerHeight;
  String label;
  boolean value=true;
  Checker(String label) {
    this.label=label;
  }
  public void display(float x, float y) {
    pushStyle();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    checkerWidth=textWidth(label)+gui.thisFont.stepY()+gui.thisFont.stepX();
    checkerHeight=gui.thisFont.stepY();
    rectMode(CORNER);
    textAlign(LEFT, CENTER);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    if (inBox())
      fill(gui.colour[2].value, 70);
    else
      noFill();
    square(x, y, checkerHeight);
    fill(gui.bodyColor[2].value);
    text(label, x+checkerHeight+gui.thisFont.stepX(), y+checkerHeight/2);
    if (value) {
      strokeWeight(gui.unit(2));
      if (mousePressed&&inBox())
        stroke(gui.colour[3].value);
      else
        stroke(gui.mainColor.value);
      line(x+gui.unit(3), y+gui.unit(3), x+checkerHeight-gui.unit(3), y+checkerHeight-gui.unit(3));
      line(x+checkerHeight-gui.unit(3), y+gui.unit(3), x+gui.unit(3), y+checkerHeight-gui.unit(3));
    }
    popStyle();
  }
  public boolean inBox() {
    return mouseX>x&&mouseX<x+checkerHeight&&mouseY>y&&mouseY<y+checkerHeight;
  }
  public boolean active() {
    if (inBox()) {
      value=!value;
      return true;
    } else
      return false;
  }
}
abstract class CircularCell extends CellSystem {
  ArrayList<LinkedList<Vertex>>[][] ring;
  public int mod(int value, int size) {
    if (value<0) {
      int x=value%size; 
      if (x==0)
        return x; 
      else
        return size+x;
    } else
      return value%size;
  }
  public void checkNeighbors(Vertex nodeA, int z, int pho, int index, int number) {
    int k=-(number-1)/2;
    for (int j=mod(index+k, ring[z][pho].size()); k<=number/2&&j<ring[z][pho].size(); k++, j++)
      for (Vertex nodeB : ring[z][pho].get(j))
        link(nodeA, nodeB);
    for (int j=0; k<=number/2; k++, j++)
      for (Vertex nodeB : ring[z][pho].get(j))
        link(nodeA, nodeB);
  }
}
class Clique extends Result implements Screen {
  Checker showClique=new Checker("Clique");
  Clique() {
    word=new String[8];
    parts.addLast(showClique);
  }
  public void setting() {
    initialize();
  }
  public void show() {
    if (showClique.value) {
      stroke(gui.mainColor.value);
      if (showNode.value)
        for (Vertex node : graph.clique)
          displayNode(node);
      if (showEdge.value) {
        strokeWeight(edgeWeight.value);
        for (ListIterator<Vertex> i=graph.clique.listIterator(); i.hasNext(); ) {
          Vertex nodeA=i.next();
          for (ListIterator<Vertex> j=graph.clique.listIterator(i.previousIndex()+1); j.hasNext(); ) {
            Vertex nodeB=j.next();
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
        }
      }
    }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Terminal clique...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(11));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]="Vertices: "+(showClique.value&&showNode.value?graph.clique.size():0);
    word[1]="Edges: "+(showClique.value&&showEdge.value?graph.clique.size()*(graph.clique.size()-1)/2:0);
    for (int i=0; i<2; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(12+i));
  }
}
class Color extends SysColor {//Color set has 3 status:0. no change, 1. reset, 2. restart
  int index, domination, deploy;//0: nochange, -1 algorithm stop ready to restart, 1 deploy
  int[] cycles={-1, -1};//cycles[0]==-1 means caculating cycles, cycles[1]==-1 means reset status
  double distance, maxDistance, minDistance;
  LinkedList<Vertex> vertices=new LinkedList<Vertex>();
  ListIterator<Vertex> nodeIterator;
  Color(int v, int index) {
    super(v);
    this.index=index;
  }
  Color(int r, int g, int b, int index) {
    super(r, g, b);
    this.index=index;
  }
  public boolean deployed() {
    return cycles[1]>-1&&deploy==1&&nodeIterator.nextIndex()>0;
  }
  public void deploying() {
    if (deploy==1)
      if (nodeIterator.hasNext()) {
        Vertex nodeA=nodeIterator.next();
        for (ListIterator<Vertex> i=vertices.listIterator(nodeIterator.nextIndex()); i.hasNext(); ) {
          Vertex nodeB=i.next();
          boolean connect=true;
          double squaredDistance=nodeA.squaredDistance(nodeB);
          for (Vertex nodeC : vertices)
            if (nodeC!=nodeA&&nodeC!=nodeB)
              if (nodeA.squaredDistance(nodeC)+nodeB.squaredDistance(nodeC)<=squaredDistance) {
                connect=false;
                break;
              }
          if (connect) {
            double d=Math.sqrt(squaredDistance);
            distance+=d;
            if (d>maxDistance)
              maxDistance=d;
            if (d<minDistance)
              minDistance=d;
            nodeA.arcs.addLast(nodeB);
            nodeB.arcs.addLast(nodeA);
          }
        }
      } else {
        if (cycles[0]==-1) {
          cycles[0]=0;
          while (nodeIterator.hasPrevious()) {
            Vertex nodeA=nodeIterator.previous();
            for (ListIterator<Vertex> i=nodeA.arcs.listIterator(); i.hasNext(); ) {
              Vertex nodeI=i.next();
              if (nodeI.value>nodeA.value)
                for (ListIterator<Vertex> j=nodeA.arcs.listIterator(i.nextIndex()); j.hasNext(); ) {
                  Vertex nodeJ=j.next();
                  if (nodeJ.value>nodeA.value)
                    if (nodeI.arcs.contains(nodeJ))
                      cycles[0]++;
                    else {
                      boolean getOut=false;
                      for (Vertex nodeB : nodeI.arcs) {
                        for (Vertex nodeC : nodeJ.arcs)
                          if (nodeB!=nodeA&&nodeB==nodeC&&!nodeA.arcs.contains(nodeC)) {
                            cycles[1]++;
                            getOut=true;
                            break;
                          }
                        if (getOut)
                          break;
                      }
                    }
                }
            }
          }
        }
        deploy=0;
      }
  }
  public void initialize() {
    deploy=1;
    for (Vertex node : vertices)
      if (node.arcs==null)
        node.arcs=new LinkedList<Vertex>();
      else
        node.arcs.clear();
    distance=maxDistance=0;
    minDistance=Integer.MAX_VALUE;
  }
  public void initialize(HashSet<Vertex> domain) {
    if (cycles[1]==-1) {
      cycles[1]=0;
      nodeIterator=vertices.listIterator();
      domain.clear();
      for (Vertex nodeA : vertices) {
        domain.add(nodeA);
        for (Vertex nodeB : nodeA.neighbors)
          domain.add(nodeB);
      }
      domination=domain.size();
      initialize();
    } else if (deploy==-1)
      restart();
  }
  public void restart() {
    initialize();
    while (nodeIterator.hasPrevious())
      nodeIterator.previous();
  }
  public void clean() {
    for (Vertex node : vertices)
      node.clearColor(this);
    vertices.clear();
    cycles[0]=cycles[1]=-1;
  }
}
class ColorSettings extends Setting implements Screen {
  Slider r=new Slider("Red", 0, 255, 1), g=new Slider("Green", 0, 255, 1), b=new Slider("Blue", 0, 255, 1);
  Radio colors=new Radio("Main", "Background", "Frame", "Base", "Highlight", "Text header 0", "Text header 1", "Text header 2", "Text body 0", "Text body 1", "Text body 2", "Graph part 0", "Graph part 1", "Graph part 2", "Graph part 3");
  Button reset=new Button("Reset");
  ColorSettings(WSN wsn) {
    label="Colors";
    reset.alignment=CENTER;
    video=new Video(wsn, "Colors.mov");
  }
  public void initialize() {
    r.setValue(getColor().r);
    g.setValue(getColor().g);
    b.setValue(getColor().b);
  }
  public void show(float x, float y, float panelWidth, float panelHeight) {
    r.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1f, y+panelHeight/2+gui.thisFont.gap(), (panelWidth*3/4-colors.radioWidth/2)*0.8f);
    g.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1f, y+panelHeight/2+r.sliderHeight+gui.thisFont.gap(2), (panelWidth*3/4-colors.radioWidth/2)*0.8f);
    b.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1f, y+panelHeight/2+r.sliderHeight+b.sliderHeight+gui.thisFont.gap(3), (panelWidth*3/4-colors.radioWidth/2)*0.8f);
    colors.display(x+panelWidth*3/4-colors.radioWidth/2, y+panelHeight/2-colors.radioHeight/2);
    fill(r.value, g.value, b.value);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    float diameter=panelWidth<panelHeight?panelWidth/3:panelHeight/3;
    circle(x+panelWidth*3/8-colors.radioWidth/4, y+panelHeight/2-diameter/2, diameter);
    reset.display(x+panelWidth*3/8-colors.radioWidth/4, y+panelHeight/2+r.sliderHeight+b.sliderHeight+g.sliderHeight+gui.thisFont.gap(2)+reset.buttonHeight);
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='r') {
      gui.resetColor();
      initialize();
    }
  }
  public void moreMousePresses() {
    if (r.active()||g.active()||b.active())
      getColor().setValue(round(r.value), round(g.value), round(b.value));
  }
  public void moreMouseReleases() {
    if (colors.active())
      initialize();
    if (reset.active()) {
      gui.resetColor();
      initialize();
    }
    if (navigation.nextPage!=20)
      video.pause();
  }
  public SysColor getColor() {
    if (colors.value==0)
      return gui.mainColor;
    else if (colors.value<5)
      return gui.colour[colors.value-1];
    else if (colors.value<8)
      return gui.headColor[colors.value-5];
    else if (colors.value<11)
      return gui.bodyColor[colors.value-8];
    else
      return gui.partColor[colors.value-11];
  }
}
class ColorSizePlot extends Plots implements Screen {
  Checker _SLColors=new Checker("Smallest-last color sets"), primarySets=new Checker("Primary sets"), relayCandidates=new Checker("Relay candidates"), relaySets=new Checker("Relay sets");
  ExTable[] table={new ExTable(1, "Part", "Covered graph"), new ExTable(3, "Part", "Covered graph"), new ExTable(4, "Part", "Covered graph")};
  ColorSizePlot() {
    chart=new Plot("Color", "Vertex", gui.partColor, "Smallest-last-colored sets", "Selected sets", "Relay candidates", "Relay-colored sets");
    chart.setPlot(0, true);
    parts.addLast(_SLColors);
    table[0].setString(0, 0, "SL-colored");
    table[1].setString(0, 0, "SL-colored");
    table[1].setString(1, 0, "Selected");
    table[1].setString(2, 0, "Candidates");
    table[2].setString(0, 0, "SL-colored");
    table[2].setString(1, 0, "Selected");
    table[2].setString(2, 0, "Candidates");
    table[2].setString(3, 0, "RL-colored");
  }
  public void moreSettings() {
    chart.setX(0, graph._SLColors.size()-1);
    chart.setPoints(0);
    int maxSize=0;
    for (int i=0; i<graph._SLColors.size(); i++) {
      int size=graph._SLColors.get(i).vertices.size();
      if (maxSize<size)
        maxSize=size;
      chart.points[0].set(i, size+0f);
    }
    chart.setY(0, maxSize);
    if (navigation.end==4) {
      primarySets.value=relayCandidates.value=relaySets.value=false;
      for (int i=1; i<4; i++)
        chart.setPlot(i, false);
      if (parts.getLast()==relayCandidates) {
        parts.removeLast();
        parts.removeLast();
      } else if (parts.getLast()==relaySets) {
        for (int i=0; i<3; i++)
          parts.removeLast();
      }
    } else {
      chart.setPoints(1, 0, graph._PYColors.size()-1);
      chart.setPoints(2, graph._PYColors.size(), graph._SLColors.size()-1);
      for (int i=0; i<graph._PYColors.size(); i++) 
        chart.points[1].set(i, graph._PYColors.get(i).vertices.size()+0f);
      for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++) 
        chart.points[2].set(i-graph._PYColors.size(), graph._SLColors.get(i).vertices.size()+0f);
      if (navigation.end==5) {  
        relaySets.value=false;
        chart.setPlot(3, false);
        if (parts.getLast()==_SLColors) {
          primarySets.value=relayCandidates.value=true;
          chart.setPlot(1, true);
          chart.setPlot(2, true);
          parts.addLast(primarySets);
          parts.addLast(relayCandidates);
        } else if (parts.getLast()==relaySets)
          parts.removeLast();
      } else {
        chart.setPoints(3, 0, graph._RLColors.size()-1);
        for (int i=0; i<graph._RLColors.size(); i++) 
          chart.points[3].set(graph._RLColors.get(i).index-graph._SLColors.size(), graph._RLColors.get(i).vertices.size()+0f);
        if (parts.getLast()==_SLColors) {
          parts.addLast(primarySets);
          parts.addLast(relayCandidates);
          parts.addLast(relaySets);
          primarySets.value=relaySets.value=true;
          chart.setPlot(1, true);
          chart.setPlot(3, true);
        } else if (parts.getLast()==relayCandidates) {
          parts.addLast(relaySets);
          relaySets.value=true;
          chart.setPlot(3, true);
        }
      }
    }
  }
  public void show() {
    if (_SLColors.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(0);
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(0);
    }
    if (primarySets.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(1);
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(1);
    }
    if (relayCandidates.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(2, graph._PYColors.size());
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(2, graph._PYColors.size());
    }
    if (relaySets.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(3, graph._PYColors.size());
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(3, graph._PYColors.size());
      chart.showScaleX(chart.getX(graph._PYColors.size()), chart.yStart-gui.thisFont.stepY(2), graph._SLColors.size(), graph._SLColors.size()+graph._RLColors.size()-1);
      chart.arrow(chart.getX(graph._PYColors.size()), chart.yStart-gui.thisFont.stepY(2), chart.getX(graph._PYColors.size())-1, chart.yStart-gui.thisFont.stepY(2));
      chart.arrow(chart.getX(graph._PYColors.size()+graph._RLColors.size())-1, chart.yStart-gui.thisFont.stepY(2), chart.getX(graph._PYColors.size()+graph._RLColors.size()), chart.yStart-gui.thisFont.stepY(2));
    }
    if (showMeasurement.value) {
      chart.showMeasurements();
      if (chart.active()) {
        int amount=0, index=round(chart.getX());
        switch(navigation.end) {
        case 4:
          for (int i=0; i<=index; i++)
            amount+=chart.points[0].get(i);
          table[0].setString(0, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
          showTable(table[0]);
          break;
        case 5:
          if (index<graph._PYColors.size()) {
            for (int i=0; i<=index; i++)
              amount+=chart.points[1].get(i);
            table[1].setString(0, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[1].setString(1, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[1].setString(2, 1, String.format("%.2f%%", 0f));
          } else {
            table[1].setString(1, 1, String.format("%.2f%%", graph.primaries*100.0f/graph.vertex.length));
            for (int i=0; i<=index-graph._PYColors.size(); i++)
              amount+=chart.points[2].get(i);
            table[1].setString(2, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[1].setString(0, 1, String.format("%.2f%%", (graph.primaries+amount)*100.0f/graph.vertex.length));
          }
          showTable(table[1]);
          break;
        default:
          if (index<graph._PYColors.size()) {
            for (int i=0; i<=index; i++)
              amount+=chart.points[1].get(i);
            table[2].setString(0, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[2].setString(1, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[2].setString(2, 1, String.format("%.2f%%", 0f));
            table[2].setString(3, 1, String.format("%.2f%%", 0f));
          } else {
            table[2].setString(1, 1, String.format("%.2f%%", graph.primaries*100.0f/graph.vertex.length));
            for (int i=0; i<=index-graph._PYColors.size(); i++)
              amount+=chart.points[2].get(i);
            table[2].setString(2, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
            table[2].setString(0, 1, String.format("%.2f%%", (graph.primaries+amount)*100.0f/graph.vertex.length));
            amount=0;
            for (int i=0; i<=index-graph._PYColors.size()&&i<graph._RLColors.size(); i++)
              amount+=chart.points[3].get(i);
            table[2].setString(3, 1, String.format("%.2f%%", amount*100.0f/graph.vertex.length));
          }
          showTable(table[2]);
        }
      }
      if (!_SLColors.value&&primarySets.value&&relayCandidates.value)
        chart.dottedLine(chart.getX(graph._PYColors.size()-1), chart.getY(chart.points[0].get(graph._PYColors.size()-1)), chart.getX(graph._PYColors.size()), chart.getY(chart.points[0].get(graph._PYColors.size())));
      if (primarySets.value&&relaySets.value)
        chart.dottedLine(chart.getX(graph._PYColors.size()-1), chart.getY(chart.points[0].get(graph._PYColors.size()-1)), chart.getX(graph._PYColors.size()), chart.getY(chart.points[3].get(0)));
    }
  }
  public void showTable(ExTable table) {
    table.display(mouseX<chart.x+chart.chartWidth/2?mouseX+textWidth(" ("):mouseX-table.tableWidth()-textWidth(" ("), mouseY<chart.y+chart.chartHeight/2?mouseY+gui.thisFont.stepY()+gui.thisFont.gap(2):mouseY-table.tableHeight()-gui.thisFont.stepY()-gui.thisFont.gap(2));
  }
}
class Component {
  int order, archive;//order for block determination (dfs for block selection), archive is for indicating random combination or aimed backbones (if archive==-1 then need reset)
  Color primary, relay;
  Vertex[] degreeList;
  Stack<Vertex> stack=new Stack<Vertex>();
  LinkedList<Vertex>[] giant=new LinkedList[2];//giant[0]->giant block; giant[1]->giant component
  LinkedList<LinkedList<Vertex>> blocks=new LinkedList<LinkedList<Vertex>>(), components=new LinkedList<LinkedList<Vertex>>();//first component is for singletons
  int[] tails=new int[5];//0->tails, 1->tailsTouchGiantBlock, 2->tailsTouchMinorBlocks, 3->tailsTouchBothBlocks, 4->block components
  Component(Color primary, Color relay) {
    degreeList=new Vertex[8];
    initialize(primary, relay);
  }
  Component(Color primary, Color relay, int maxDegree) {
    archive=1;
    degreeList=new Vertex[maxDegree+1];
    initialize(primary, relay);
  }
  public void initialize(Color primary, Color relay) {
    components.addLast(new LinkedList<Vertex>());
    for (int i=0; i<degreeList.length; i++)
      degreeList[i]=new Vertex(i);
    setPartites(primary, relay);
  }
  public void reset(Color primary, Color relay) {
    tails[4]=order=0;
    stack.clear();
    blocks.clear();
    for (Vertex list : degreeList)
      list.clean();
    while (components.size()>1)
      components.removeLast();
    components.getFirst().clear();
    setPartites(primary, relay);
  }
  public void restart() {
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      node.order[archive]=0;
    for (Vertex list : degreeList)
      list.clean();
    generateDegreeList();
  }
  public boolean deleting() {
    if (degreeList[1].value==0) {
      if (order==0) {
        for (int i=2; i<degreeList.length; i++)
          for (Vertex node=degreeList[i].next; node!=null; node=node.next)
            node.setEdgeIndicator();
        int index=2;
        while (index<degreeList.length&&degreeList[index].value==0)
          index++;
        if (index<degreeList.length) {
          depthFirstSearch(degreeList[index].next, null);
          for (LinkedList<Vertex> block : blocks)
            if (giant[0].size()<block.size())
              giant[0]=block;
          for (ListIterator<LinkedList<Vertex>> j=blocks.listIterator(blocks.size()-1); j.hasPrevious(); )
            j.previous().getLast().order[archive]=-1;//separating vertex in minor blocks indicator
          for (Vertex node : giant[0])
            if (node.order[archive]==-1) {
              node.order[archive]=-3;
              tails[4]++;
            } else
              node.order[archive]=-4;//-3: separating vertex in giant block indicator, -4: giant block indicator
        }
        countTails();
      }
      return false;
    } else {
      Vertex nodeA=degreeList[1].pop();
      nodeA.order[archive]=-2;//tail indicator
      degreeList[0].push(nodeA);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[archive]!=-2) {
          nodeB.solo(degreeList[nodeB.lowpoint]);
          nodeB.lowpoint--;
          degreeList[nodeB.lowpoint].push(nodeB);
          if (nodeB.lowpoint==0)
            nodeB.order[archive]=-2;
          break;
        }
      return true;
    }
  }
  public void setPartites(Color primary, Color relay) {
    giant[0]=giant[1]=gui.mainColor.vertices;
    this.primary=primary;
    this.relay=relay;
    initialMarks(primary);
    initialMarks(relay);
    for (Vertex nodeA : relay.vertices) {
      for (Vertex nodeB : nodeA.linksAt(primary)) {
        nodeA.links.addLast(nodeB);
        nodeB.links.addLast(nodeA);
      }
      if (nodeA.links.isEmpty()) {
        nodeA.order[archive]=0;//minor components indicator
        components.getFirst().addLast(nodeA);
      }
    }
    for (Vertex nodeA : primary.vertices)
      if (nodeA.links.isEmpty()) {
        nodeA.order[archive]=0;//minor components indicator
        components.getFirst().addLast(nodeA);
      } else if (nodeA.order[archive]==1) {
        components.addLast(new LinkedList<Vertex>());
        depthFirstSearch(nodeA);
      }
    for (ListIterator<LinkedList<Vertex>> i=components.listIterator(1); i.hasNext(); ) {
      LinkedList<Vertex> component=i.next();
      if (giant[1].size()<component.size())
        giant[1]=component;
    }
    generateDegreeList();
  }
  public void generateDegreeList() {
    for (Vertex node : giant[1]) {
      node.mark=true;
      node.lowpoint=node.links.size();
      degreeList[node.lowpoint].push(node);
    }
  }
  public void initialMarks(Color colour) {
    for (Vertex node : colour.vertices) {
      node.order[archive]=1;//temporary mark for dfs to determine components
      if (node.links==null)
        node.links=new LinkedList<Vertex>();
      else
        node.links.clear();
    }
  }
  public void countTails() {
    tails[0]=tails[1]=tails[2]=tails[3]=0;
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      node.mark=true;
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      if (node.mark) {
        tails[0]++;
        tailTraverse(node);
      }
  }
  public void tailTraverse(Vertex nodeA) {//determine # of tail components
    switch(nodeA.order[archive]) {
    case -2://tail
      nodeA.mark=false;
      for (Vertex nodeB : nodeA.links)
        if (nodeB.mark)
          tailTraverse(nodeB);
      break;
    case -3://touch separating vertices in the giant block (it touches both blocks)
      tails[3]++;
      break;
    case -4://touch the giant block
      tails[1]++;
      break;
    default://touch minor blocks
      tails[2]++;
    }
  }
  public int tailsXGiant() {//tails exclude gianttails
    return tails[0]-tails[1]-tails[3];
  }
  public int tailsXMinors() {//tails exclude minortails
    return tails[0]-tails[2]-tails[3];
  }
  public void depthFirstSearch(Vertex nodeA) {
    nodeA.order[archive]=0;//minor component indicator
    components.getLast().addLast(nodeA);
    for (Vertex nodeB : nodeA.links)
      if (nodeB.order[archive]==1)
        depthFirstSearch(nodeB);
  }
  public void depthFirstSearch(Vertex nodeA, Vertex precessor) {
    if (nodeA.order[archive]==0) {
      nodeA.order[archive]=nodeA.lowpoint=++order;
      stack.push(nodeA);
      while (nodeA.edgeIndicator.hasNext()) {
        Vertex nodeB=nodeA.edgeIndicator.next();
        if (nodeB!=precessor&&nodeB.order[archive]!=-2)
          depthFirstSearch(nodeB, nodeA);
      }
      if (precessor!=null)
        if (precessor.order[archive]==1)
          seperate(nodeA, precessor); 
        else if (nodeA.lowpoint<precessor.order[archive])
          precessor.lowpoint=min(precessor.lowpoint, nodeA.lowpoint);
        else
          seperate(nodeA, precessor);
    } else
      precessor.lowpoint=min(precessor.lowpoint, nodeA.order[archive]);
  }
  public void seperate(Vertex node, Vertex precessor) {
    blocks.addLast(new LinkedList<Vertex>());
    Vertex s=stack.pop();
    while (s!=node) {
      blocks.getLast().addLast(s);
      s=stack.pop();
    }
    blocks.getLast().addLast(s);
    blocks.getLast().addLast(precessor);
  }
}
class Cube extends Topology {
  Cube() {
    value=7;
    xRange=yRange=zRange=1;
    range=Math.sqrt(2);
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.pow((avg+1)*3*xRange*yRange*zRange/(4*n*Math.PI), 1.0f/3);
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=4*n*Math.PI*r*r*r/(3*xRange*yRange*zRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public Vertex generateVertex(int value) {
    return new Vertex(value, rnd.nextDouble()*xRange-xRange/2, rnd.nextDouble()*yRange-yRange/2, rnd.nextDouble()*zRange-zRange/2, connectivity());
  }
  public String toString() {
    return "Cube";
  }
}
class CylindricalCell extends CircularCell {
  int phoN=graph.r==0?0:(int)Math.floor(graph.topology.range/(2*graph.r))+1, zN=graph.r==0?0:(int)Math.floor(graph.topology.zRange/graph.r)+1, z, pho, phi;
  ListIterator<Vertex> i;
  CylindricalCell() {
    ring=new ArrayList[zN][phoN];
    for (int a=0; a!=zN; a++) {
      int size=6;
      ring[a][0]=new ArrayList<LinkedList<Vertex>>();
      for (int b=0; b!=size; b++)
        ring[a][0].add(new LinkedList<Vertex>());
      for (int b=1; b!=phoN; b++) {
        ring[a][b]=new ArrayList<LinkedList<Vertex>>();
        if (Math.sin(Math.PI/size)*b>1)
          size*=2;
        for (int c=0; c!=size; c++)
          ring[a][b].add(new LinkedList<Vertex>());
      }
    }
    if (graph.r==0)
      for (Vertex node : graph.vertex)
        ring[0][0].get((int)Math.floor(node.phi*3/Math.PI)).addLast(node);
    else
      for (Vertex node : graph.vertex) {
        z=(int)Math.floor((node.z+graph.topology.zRange/2)/graph.r);
        pho=(int)Math.floor(node.pho/graph.r);
        ring[z][pho].get((int)Math.floor(node.phi*ring[z][pho].size()/(2*Math.PI))).addLast(node);
      }
  }
  public void initialize() {
    z=pho=phi=0;
    i=ring[0][0].get(0).listIterator();
  }
  public boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    if (i.hasNext()) {
      count++;
      Vertex nodeA=i.next();
      nodeA.lowpoint=0;
      for (ListIterator<Vertex> j=ring[z][pho].get(phi).listIterator(i.nextIndex()); j.hasNext(); )
        link(nodeA, j.next());
      if (pho==0) {
        for (int j=phi+1; j<ring[z][0].size(); j++)
          for (Vertex nodeB : ring[z][0].get(j))
            link(nodeA, nodeB);
        if (phoN>1)
          checkNeighbors(nodeA, z, 1, phi, 5);
        if (z+1!=zN) {
          for (LinkedList<Vertex> list : ring[z+1][0])
            for (Vertex nodeB : list)
              link(nodeA, nodeB);
          if (phoN>1)
            checkNeighbors(nodeA, z+1, 1, phi, 5);
        }
      } else if (pho==1) {
        for (Vertex nodeB : ring[z][1].get (mod (phi+1, ring[z][1].size())))
          link(nodeA, nodeB);
        if (phoN>2)
          checkNeighbors(nodeA, z, 2, phi, 3);
        if (z+1!=zN) {
          checkNeighbors(nodeA, z+1, 0, phi, 5);
          checkNeighbors(nodeA, z+1, 1, phi, 3);
          if (phoN>2)
            checkNeighbors(nodeA, z+1, 2, phi, 3);
        }
      } else {
        for (Vertex nodeB : ring[z][pho].get (mod (phi+1, ring[z][pho].size())))
          link(nodeA, nodeB);
        int index, number;
        if (pho+1!=phoN) {
          if (ring[z][pho].size()<ring[z][pho+1].size()) {
            index=phi*2;
            number=4;
          } else {
            index=phi;
            number=3;
          }
          checkNeighbors(nodeA, z, pho+1, index, number);
        }
        if (z+1!=zN) {
          index=ring[z+1][pho-1].size()<ring[z+1][pho].size()?phi/2:phi;
          checkNeighbors(nodeA, z+1, pho-1, index, 3);
          checkNeighbors(nodeA, z+1, pho, phi, 3);
          if (pho+1!=phoN) {
            if (ring[z+1][pho].size()<ring[z+1][pho+1].size()) {
              index=phi*2;
              number=4;
            } else {
              index=phi;
              number=3;
            }
            checkNeighbors(nodeA, z+1, pho+1, index, number);
          }
        }
      }
    } else {
      if (++phi==ring[z][pho].size()) {
        phi=0;
        if (++pho==phoN) {
          pho=0;
          z++;
        }
      }
      i=ring[z][pho].get(phi).listIterator();
    }
    return true;
  }
}
class DegreeDistribution extends Charts implements Screen {
  Switcher showBar=new Switcher("Bar", "Bar");
  Checker degreeHistogram=new Checker("Degree histogram"), inDegreeHistogram=new Checker("Indegree histogram"), outDegreeHistogram=new Checker("Outdegree histogram");
  DegreeDistribution() {
    switches.addLast(showBar);
    parts.addLast(inDegreeHistogram);
    parts.addLast(degreeHistogram);
    parts.addLast(outDegreeHistogram);
    chart=new BarChart("Degree", "Vertex", gui.partColor, "Indegree", "Degree", "Outdegree");
  }
  public void setting() {
    chart.setX(0, graph.maxDegree);
    chart.setPoints();
    for (int i=0; i<chart.points[0].size(); i++)
      chart.points[0].set(i, 0f);
    for (int i=0; i<chart.points[2].size(); i++)
      chart.points[2].set(i, 0f);
    for (Vertex node : graph.vertex) {
      chart.points[0].set(node.degree, chart.points[0].get(node.degree)+1);
      chart.points[2].set(node.neighbors.size()-node.degree, chart.points[2].get(node.neighbors.size()-node.degree)+1);
    }
    float maxSize=0;
    for (int i=0; i<=graph.maxDegree; i++) {
      chart.points[1].set(i, graph.degreeDistribution[i]+0f);
      float value=max(chart.points[0].get(i), chart.points[1].get(i), chart.points[2].get(i));
      if (maxSize<value)
        maxSize=value;
    }
    chart.setY(0, round(maxSize));
    edgeWeight.setPreference(7, 0, 10, 1);
  }
  public void show() {
    if (showBar.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[0].display();
    }
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='b')
      showBar.value=!showBar.value;
  }
}
class DialogBox {
  Action action;
  int option;//reuse attribute, when box is active, it stores the number of options, otherwise it stores which option.
  boolean active, mode;//mode true has entry, mode false is messagebox
  float boxWidth, boxHeight, moveX, moveY, x, y;
  String[] message=new String[2];
  Button[] choice={new Button(), new Button(), new Button()};
  Radio entry=new Radio();
  DialogBox() {
    for (int i=0; i<choice.length; i++)
      choice[i].alignment=CENTER;
  }
  public void display() {
    pushStyle();
    gui.body.initialize();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    fill(gui.colour[2].value, 50);
    rectMode(CENTER);
    boxHeight=mode?max(entry.radioHeight+gui.thisFont.stepY(2)+choice[0].buttonHeight+gui.thisFont.gap(2), gui.thisFont.stepY(10)):gui.thisFont.stepY(10);
    boxWidth=boxHeight*1920/1080;
    rect(x, y, boxWidth, boxHeight, gui.unit(8), 0, gui.unit(8), 0);
    if (mode)
      entry.display(x-entry.radioWidth/2, y-boxHeight/2+gui.thisFont.stepY(2));
    else {
      if (textWidth(message[0]+"  ")>boxWidth) {
        String[] word=message[0].split(" ");
        float count=gui.thisFont.stepX();
        message[0]="";
        for (String str : word) {
          count+=textWidth(str+' ');
          if (count>boxWidth) {
            message[0]+=System.getProperty("line.separator");
            count=gui.thisFont.stepX()+textWidth(str+' ');
          }
          message[0]+=str+' ';
        }
      }
      textAlign(LEFT, CENTER);
      fill(gui.bodyColor[0].value);
      text(message[0], x-boxWidth/2+gui.thisFont.stepX(), y);
    }
    switch(option) {
    case 1:
      choice[0].display(x, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      break;
    case 2:
      choice[0].display(x-boxWidth/6, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[1].display(x+boxWidth/6, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      break;
    case 3:
      choice[0].display(x-boxWidth/4, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[1].display(x, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[2].display(x+boxWidth/4, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
    }
    textAlign(CENTER);
    fill(gui.headColor[2].value);
    text(message[1], x, y-boxHeight/2+gui.thisFont.stepY());
    popStyle();
  }
  public void pop(LinkedList<String> items, String metaMessage, String...label) {
    pop(items, metaMessage, null, label);
  }
  public void pop(LinkedList<String> items, String metaMessage, Action action, String...label) {
    mode=true;
    entry.setLabels(items);
    initialize(metaMessage, action, label);
  }
  public void pop(String mainMessage, String metaMessage, Action action, String...label) {
    mode=false;
    message[0]=mainMessage;
    initialize(metaMessage, action, label);
  }
  public void pop(String mainMessage, String metaMessage, String...label) {
    pop(mainMessage, metaMessage, null, label);
  }
  public void initialize(String metaMessage, Action action, String...label) {
    x=width/2;
    y=height/2;
    this.action=action;
    message[1]=metaMessage;
    option=label.length;
    for (int i=0; i<label.length; i++)
      choice[i].label=label[i];
    active=true;
  }
  public void keyPress() {
    if (option==1)
      if (key==ENTER||key==RETURN||key==' ') {
        if (action!=null)
          action.go();
        active=false;
      }
  }
  public void mousePress() {
    entry.active();
    moveX=mouseX-x;
    moveY=mouseY-y;
  }
  public void mouseRelease() {
    for (int i=0; active&&i<option; i++)
      if (choice[i].active()) {
        option=i;
        if (action!=null)
          action.go();
        active=false;
      }
  }
  public void mouseDrag() {
    if (mouseX>x-boxWidth/2&&mouseX<x+boxWidth/2&&mouseY>y-boxHeight/2&&mouseY<y+boxHeight/2) {
      x=mouseX-moveX;
      y=mouseY-moveY;
    }
  }
}
class Disk extends Topology {
  Disk() {
    range=xRange=yRange=value=2;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt((avg+1)*xRange*yRange/n)/2;
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=4*n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public String toString() {
    return "Disk";
  }
  public Vertex generateVertex(int index) {
    return new Vertex(Math.sqrt(rnd.nextDouble()*range/2), Math.PI/2, rnd.nextDouble()*2*Math.PI, index, connectivity());
  }
}
interface DrawPlot {
  public void display();
  public void display(int index);
  public void display(int index, int beginIndex);
}
class Error {
  StringBuffer path=new StringBuffer("Logs");
  PrintWriter out;
  public void clean() {
    if (out!=null)
      out.close();
  }
  public void logOut(String message) {
    if (out==null) {
      String timeStamp=month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second();
      out=createWriter(path+System.getProperty("file.separator")+"WSN-"+timeStamp+".log");
    }
    String timeStamp=month()+"/"+day()+"/"+year()+" "+hour()+":"+minute()+":"+second()+":"+millis();
    println("["+timeStamp+"]: "+message+"!");
    out.println("["+timeStamp+"]: "+message+".");
    box.pop(message+"!", "Error Alert", "Nevermind");
  }
}
class ExTable extends Table {
  String maxString;
  float gapX, gapY;
  ExTable(int rows, String...column) {
    for (String c : column)
      addColumn(c);
    for (int i=0; i<rows; i++)
      addRow();
    maxString=column[0];
    for (int i=1; i<column.length; i++)
      if (column[i].length()>maxString.length())
        maxString=column[i];
  }
  public float tableWidth() {
    return getColumnCount()*gapX;
  }
  public float tableHeight() {
    return (getRowCount()+1)*gapY;
  }
  public void display(float x, float y) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    gapX=textWidth(maxString)+gui.thisFont.stepX();
    gapY=gui.thisFont.stepY()+gui.thisFont.gap();
    line(x, y, x+getColumnCount()*gapX, y);
    line(x, y+(getRowCount()+1)*gapY, x+getColumnCount()*gapX, y+(getRowCount()+1)*gapY);
    line(x, y, x, y+(getRowCount()+1)*gapY);
    line(x+getColumnCount()*gapX, y, x+getColumnCount()*gapX, y+(getRowCount()+1)*gapY);
    strokeWeight(gui.unit());
    for (int i=1; i<getColumnCount(); i++)
      line(x+i*gapX, y, x+i*gapX, y+(getRowCount()+1)*gapY);
    for (int i=1; i<=getRowCount(); i++)
      line(x, y+i*gapY, x+getColumnCount()*gapX, y+i*gapY);
    fill(gui.headColor[0].value);
    textAlign(CENTER, CENTER);
    for (int i=0; i<getColumnCount(); i++)
      text(getColumnTitle(i), x+i*gapX+gapX/2, y+gapY/2);
    fill(gui.bodyColor[1].value);
    for (int i=0; i<getRowCount(); i++)
      for (int j=0; j<getColumnCount(); j++)
        if (getString(i, j)!=null)
          text(getString(i, j), x+j*gapX+gapX/2, y+(i+1)*gapY+gapY/2);
    popStyle();
  }
}
class Exhaustive extends Method {
  public boolean connecting() {
    graph.vertex[index].lowpoint=0;
    if (index==graph.vertex.length-1)
      return false;
    for (int i=index+1; i<graph.vertex.length; i++)
      if (graph.vertex[index].distance(graph.vertex[i])<graph.r) {
        graph.vertex[index].neighbors.addLast(graph.vertex[i]);
        graph.vertex[i].neighbors.addLast(graph.vertex[index]);
        graph._E++;
        graph.vertex[i].lowpoint=0;
      }
    index++;
    return true;
  }
  public void reset() {
    index=0;
  }
}
class Firework {
  LinkedList<Particle> particles=new LinkedList<Particle>();
  float x, y;
  int colour;
  Firework(float x, float y, int colour) {
    this.x=x;
    this.y=y;
    this.colour=colour;
    for (float angle = PI; angle < TWO_PI; angle += PI/7)
      particles.addLast(new Particle(x, y, angle, colour));
  }
  public void display() {
    for (Particle particle : particles)
      particle.display();
  }
}
class Font {
  int size;
  PFont font;
  Font(String fontFile, int size) {
    font=loadFont(fontFile);
    this.size=size;
  }
  public float gap() {
    return gap(1);
  }
  public float gap(float factor) {
    if (this==gui.thisFont)
      return 2*textDescent()*factor;
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=2*textDescent()*factor;
      popStyle();
      return value;
    }
  }
  public float stepX() {
    return stepX(1);
  }
  public float stepX(float factor) {
    if (this==gui.thisFont)
      return textWidth('x')*factor;
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=textWidth('x')*factor;
      popStyle();
      return value;
    }
  }
  public float stepY() {
    return stepY(1);
  }
  public float stepY(float factor) {
    if (this==gui.thisFont)
      return factor*(textAscent()+2*textDescent());
    else {
      float value;
      pushStyle();
      textFont(font, gui.unit(size));
      value=factor*(textAscent()+2*textDescent());
      popStyle();
      return value;
    }
  }
  public void initialize() {
    gui.thisFont=this;
    textFont(font, gui.unit(size));
  }
}
public class FontSettings extends Setting implements Screen {
  Slider[] size={new Slider("Size", 2, 72, 1), new Slider("Size", 1, 36, 1)};
  Button[] font={new Button("Choose font..."), new Button("Choose font...")};
  Button reset=new Button("Reset");
  int index;
  FontSettings (WSN wsn) {
    video=new Video(wsn, "Fonts.mov");
    label="Fonts";
    font[0].alignment=CENTER;
    font[1].alignment=CENTER  ;
    reset.alignment=CENTER;
  }
  public void initialize() {
    size[0].setValue(gui.head.size);
    size[1].setValue(gui.body.size);
  }
  public void show(float x, float y, float panelWidth, float panelHeight) {
    fill(gui.headColor[2].value);
    textAlign(CENTER, BOTTOM);
    gui.head.initialize();
    text("Head", x+panelWidth/4, y+panelHeight/2-gui.body.gap(2)-font[0].buttonHeight);
    float textLength=textWidth("Head");
    textAlign(CENTER, TOP);
    gui.body.initialize();
    text("Body", x+panelWidth/4, y+panelHeight/2+size[1].sliderHeight/2+gui.thisFont.gap());
    if (textWidth("Body")>textLength)
      textLength=textWidth("Body");
    size[0].display(x+panelWidth/2, y+panelHeight/2-gui.thisFont.gap(2)-font[0].buttonHeight-size[0].sliderHeight, panelWidth/4+textLength/2);
    font[0].display(x+panelWidth*5/8+textLength/4, y+panelHeight/2-gui.thisFont.gap()-font[0].buttonHeight/2);
    size[1].display(x+panelWidth/2, y+panelHeight/2+gui.thisFont.gap(), panelWidth/4+textLength/2);
    font[1].display(x+panelWidth*5/8+textLength/4, y+panelHeight/2+gui.thisFont.gap(2)+size[1].sliderHeight+font[1].buttonHeight/2);
    reset.display(x+panelWidth/2, y+panelHeight*3/4);
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='r') {
      gui.head.size=54;
      gui.head.font=loadFont("ColonnaMT-60.vlw");
      gui.body.size=18;
      gui.body.font=loadFont("AmericanTypewriter-Bold-24.vlw");
      initialize();
    }
  }
  public void moreMousePresses() {
    if (size[0].active())
      gui.head.size=round(size[0].value);
    if (size[1].active())
      gui.body.size=round(size[1].value);
  }
  public void moreMouseReleases() {
    for (int i=0; i<font.length; i++)
      if (font[i].active()) {
        index=i;
        selectInput("Choose a font file:", "setFont", new File(System.getProperty("user.dir")+System.getProperty("file.separator")+'.'), this);
      }
    if (reset.active()) {
      gui.head.size=54;
      gui.head.font=loadFont("ColonnaMT-60.vlw");
      gui.body.size=18;
      gui.body.font=loadFont("AmericanTypewriter-Bold-24.vlw");
      initialize();
    }
    if (navigation.nextPage!=22)
      video.pause();
  }
  public void setFont(File selection) {
    if (selection!=null)
      if (index==0)
        gui.head.font=loadFont(selection.getAbsolutePath());
      else
        gui.body.font=loadFont(selection.getAbsolutePath());
  }
}
class GIF extends Animation {
  int count, index, slowDown=1;
  PImage[] frame;
  boolean loop=true;
  GIF(String filename, int count) {
    this.count=count;
    isPlaying=true;
    frame=new PImage[count];
    for (int i=0; i<count; i++)
      frame[i]=loadImage(filename+System.getProperty("file.separator")+filename+" ("+i+").gif");
  }
  GIF(String filename, int count, int slowDown) {
    this(filename, count);
    this.slowDown=slowDown;
  }
  public void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      animeWidth=gui.unit(frame[0].width)*factor;
      animeHeight=gui.unit(frame[0].height)*factor;
      break;
    case GUI.WIDTH:
      animeWidth=factor;
      animeHeight=frame[0].height*factor/frame[0].width;
      break;
    case GUI.HEIGHT:
      animeWidth=frame[0].width*factor/frame[0].height;
      animeHeight=factor;
    }
    image(frame[index%count], x, y, animeWidth, animeHeight);
    if (isPlaying)
      if (loop) {
        if (frameCount%slowDown==0)
          index++;
      } else if (frameCount%slowDown==0&&index<count)
        index++;
  }
  public void play() {
    isPlaying=true;
  }
  public void repeat() {
    loop=true;
    isPlaying=true;
  }
  public void pause() {
    isPlaying=false;
  }
  public void end() {
    index=0;
    isPlaying=false;
  }
  public void jump(float percent) {
    index=round(count*percent);
  }
  public int hours() {
    return round(slowDown*(index)/frameRate)/3600;
  }
  public int minutes() {
    return round((slowDown*(index)/frameRate)%3600)/60;
  }
  public int seconds() {
    return round(slowDown*(index)/frameRate)%60;
  }
  public float position() {
    return (index%count)*1f/count;
  }
}
class GUI {
  static final int SCALE=0, WIDTH=1, HEIGHT=2;
  volatile int thread;
  float angle;
  String _V="3.1415926";
  boolean mode;
  String[] loadText={"Loading", "Loading.", "Loading..", "Loading..."};
  Font body, head, thisFont;
  Image title;
  Image[] cover=new Image[2];
  Color mainColor=new Color(255, 255, 0, -1);
  SysColor[] colour={new SysColor(), new SysColor(255, 165, 0), new SysColor(255, 255, 255), new SysColor(0, 255, 255)}, headColor={new SysColor(255, 255, 0), new SysColor(255, 0, 0), new SysColor(0, 255, 0)}, bodyColor={new SysColor(0, 255, 255), new SysColor(200, 200, 200), new SysColor(255, 165, 0)}, partColor={new SysColor(240, 247, 212), new SysColor(255, 0, 255), new SysColor(0, 255, 0), new SysColor(138, 43, 226)};
  public int getWidth() {
    return 0.86f*displayHeight*1920/1080>displayWidth?round(0.86f*displayWidth):round(0.86f*displayHeight*1920/1080);
  }
  public int getHeight() {
    return 0.86f*displayHeight*1920/1080>displayWidth?round(0.86f*displayWidth*1080/1920):round(0.86f*displayHeight);
  }
  public float margin() {
    return thisFont.stepX(3)+textWidth("Welcome to DragonZ-WSN world!");
  }
  public float logo() {
    pushStyle();
    imageMode(CENTER);
    cover[gui.thread>0?1:0].display(GUI.HEIGHT, width/2, height/5, height/2.5f);
    fill(gui.thread>0?bodyColor[0].value:headColor[1].value);
    text("DragonZ", width/2, height/2.5f-unit(40));
    title.display(GUI.HEIGHT, width/2, height/2.5f-unit(10), unit(40));
    popStyle();
    return height/2.5f;
  }
  public float unit() {
    return unit(1);
  }
  public float unit(float factor) {
    return height*factor/1080;
  }
  public void initialize() {
    surface.setLocation((displayWidth-width)/2, round(0.035f*displayHeight));
    surface.setResizable(true);
    surface.setTitle("Wireless Sensor Networks");
    body=new Font("AmericanTypewriter-Bold-24.vlw", 18);
    head=new Font("ColonnaMT-60.vlw", 54);
    cover[0]=new Image("RedDragon.jpg");
    cover[1]=new Image("BlueDragon.jpg");
    title=new Image("Title.png");
    background(colour[0].value);
  }
  public void resetColor() {
    if (mode) {
      mainColor.setValue(84, 84, 159);
      colour[0].setValue(255, 247, 217 );
      colour[1].setValue(51, 35, 5);
      colour[2].setValue(199, 175, 189);
      colour[3].setValue(45, 196, 166);
      headColor[0].setValue(111, 39, 45);
      headColor[2].setValue(26, 135, 0);
      bodyColor[0].setValue(51, 35, 5);
      bodyColor[1].setValue(107, 140, 106);
      bodyColor[2].setValue(51, 35, 5);
      partColor[0].setValue(0, 126, 255);
      partColor[1].setValue(255, 0, 255);
      partColor[2].setValue(252, 79, 115);
    } else {
      mainColor.setValue(255, 255, 0);
      colour[0].setValue(0);
      colour[1].setValue(255, 165, 0);
      colour[2].setValue(255, 255, 255);
      colour[3].setValue(0, 255, 255);
      headColor[0].setValue(255, 255, 0);
      headColor[1].setValue(255, 0, 0);
      headColor[2].setValue(0, 255, 0);
      bodyColor[0].setValue(0, 255, 255);
      bodyColor[1].setValue(200, 200, 200);
      bodyColor[2].setValue(255, 165, 0);
      partColor[0].setValue(240, 247, 212);
      partColor[1].setValue(255, 0, 255);
      partColor[2].setValue(0, 255, 0);
      partColor[3].setValue(138, 43, 226);
    }
  }
  public void display() {
    push();
    body.initialize();
    translate(width/2, logo());
    noStroke();
    fill(colour[0].value);
    rect(-width/2, 0, width, thisFont.stepY(2)+thisFont.gap());
    fill(headColor[2].value);
    textAlign(CENTER);
    text("Ver. "+_V, 0, thisFont.stepY());
    angle+=0.1f;
    fill(0, 8);
    rect(-unit(15), thisFont.stepY(3), unit(30), unit(30));
    fill(32, 32, 255);
    ellipse(cos(angle)*unit(10), sin(angle)*unit(10)+thisFont.stepY(3)+unit(15), unit(10), unit(10));
    fill(bodyColor[2].value);
    text(loadText[frameCount/15%4], 0, thisFont.stepY(2));
    pop();
  }
}
class Graph {
  int index, _E, maxDegree, minDegree, maxMinDegree, methodIndex, connectivity=2, coordinateIndex, primaries=-1;//primaries is order of selected graph adjusted back 1 for mark when the algorithm stopped or continue.
  int[] degreeDistribution;
  float breakpoint;
  double r;
  String timeStamp;
  boolean mode;//partitioning mode, true means auto mode, false means manual mode
  ArrayList<Color> colorLibrary=new ArrayList<Color>(), _SLColors=new ArrayList<Color>(), _RLColors=new ArrayList<Color>(), _PYColors=new ArrayList<Color>();
  ArrayList<Vertex> degreeList=new ArrayList<Vertex>();
  Vertex[] vertex;
  Method[] method=new Method[3];
  Topology topology;
  Component[] backbone;
  LinkedList<Vertex> clique=new LinkedList<Vertex>();
  LinkedList<Vertex>[] relayList;
  Graph(Topology topology, int _N, double r) {
    this.topology=topology;
    this.r=r;
    relayList=new LinkedList[topology.connectivity()];//2D possible max degree=5, 3D is 7
    for (int i=0; i<relayList.length; i++)
      relayList[i]=new LinkedList<Vertex>();
    vertex=new Vertex[_N];
  }
  Graph(Topology topology, int _N, double r, int methodIndex, int coordinateIndex, boolean mode, float breakpoint, int connectivity) {
    this(topology, _N, r);
    this.methodIndex=methodIndex;
    this.coordinateIndex=coordinateIndex;
    this.mode=mode;
    this.breakpoint=breakpoint;
    this.connectivity=connectivity;
  }
  Graph(int index, Topology topology, int _N, double r, int methodIndex, int coordinateIndex, boolean mode, float breakpoint, int connectivity) {
    this(topology, _N, r, methodIndex, coordinateIndex, mode, breakpoint, connectivity);
    this.index=index;
  }
  public void compute() {
    for (int i=0; i<vertex.length; i++)
      vertex[i]=topology.generateVertex(i);
    initialize();
    while (method[methodIndex].connecting());
    generateDegreeList();
    int[] degree={_E, 2*_E};
    Vertex[] list=new Vertex[2];
    list[1]=degreeList.get(maxDegree);
    int amount=vertex.length;
    while (amount>0) {
      order(amount, degree, list);
      amount--;
    }
    boolean[] slot=new boolean[maxMinDegree+1];
    while (amount<vertex.length) {
      colour(amount, slot);
      amount++;
    }
    while (primaries<0)
      selectPrimarySet();
    generateRelayList(connectivity);
    for (amount=relayList.length; amount>=connectivity; amount=colour(slot, amount));
    navigation.end=7;
    box.pop("Graph "+index+" computation acomplished!", "Information", "Gotcha");
  }
  public void initialize() {
    if (method[methodIndex]==null)
      switch(methodIndex) {
      case 0:
        method[0]=new Exhaustive();
        break;
      case 1:
        method[1]=new Sweep();
        break;
      case 2:
        method[2]=new Cell();
      }
    method[methodIndex].setCoordinate(coordinateIndex);
  }
  public void generateDegreeList() {
    for (Vertex node : vertex) {
      node.degree=node.neighbors.size();
      while (node.degree>=degreeList.size())
        degreeList.add(new Vertex(degreeList.size()));
      degreeList.get(node.degree).push(node);
    }
    maxDegree=degreeList.size()-1;
    while (degreeList.get(minDegree).value==0)
      minDegree++;
    degreeDistribution=new int[maxDegree+1];
    for (int i=minDegree; i<=maxDegree; i++)
      degreeDistribution[i]=degreeList.get(i).value;
  }
  public void order(int vertices, int[] degree, Vertex[] list) {
    list[0]=degreeList.get(0);//list[0] means minDegreeList
    while (list[0].value==0)
      list[0]=degreeList.get(list[0].degree+1);
    while (list[1].value==0)
      list[1]=degreeList.get(list[1].degree-1);
    if (list[0]==list[1]&&clique.isEmpty())
      for (Vertex node=list[0].next; node!=null; node=node.next)
        clique.addLast(node);
    if (maxMinDegree<list[0].degree)
      maxMinDegree=list[0].degree;
    Vertex nodeA=list[0].pop();
    if (nodeA.value!=vertices-1) {
      Vertex nodeB=vertex[vertices-1];
      vertex[vertices-1]=nodeA;
      vertex[nodeA.value]=nodeB;
      nodeB.value=nodeA.value;
      nodeA.value=vertices-1;
    }
    nodeA.avgDegree=degree[0]*2f/vertices;
    nodeA.avgOrgDegree=degree[1]*1f/vertices;
    for (Vertex nodeB : nodeA.neighbors)
      if (nodeB.value<nodeA.value) {
        nodeB.solo(degreeList.get(nodeB.degree));
        nodeB.degree--;
        degreeList.get(nodeB.degree).push(nodeB);
      }
    degree[1]-=nodeA.neighbors.size();
    degree[0]-=nodeA.degree;//degree when deleted
  }
  public void colour(int index, boolean[] slot) {//smallest-last coloring
    for (int i=0; i<=maxMinDegree; i++)
      slot[i]=false;
    for (Vertex node : vertex[index].neighbors)
      if (node.value<vertex[index].value&&node.primeColor!=null)
        slot[node.primeColor.index]=true;
    int i=0;
    for (; slot[i]; i++);
    vertex[index].primeColor=getColor(i);
    if (vertex[index].primeColor.vertices.isEmpty())
      _SLColors.add(vertex[index].primeColor);
    for (Vertex node : vertex[index].neighbors)
      node.categorize(vertex[index]);
    vertex[index].primeColor.vertices.addLast(vertex[index]);
  }
  public void selectPrimarySet() {
    if (primaries<0) {
      if (mode) {
        if ((primaries+1)*-100.0f/vertex.length<breakpoint)
          addPrimaryColor();
        else {
          primaries=-(primaries+1);
          int offset=_PYColors.get(_PYColors.size()-1).vertices.size();
          if (primaries*100.0f/vertex.length-breakpoint>breakpoint-(primaries-offset)*100.0f/vertex.length) {
            primaries-=offset;
            _PYColors.remove(_PYColors.size()-1);
          }
        }
      } else if (_PYColors.size()==round(breakpoint))
        primaries=-primaries-1;
      else
        addPrimaryColor();
    }
  }
  public void addPrimaryColor() {
    Color colour=_SLColors.get(_PYColors.size());
    primaries-=colour.vertices.size();
    _PYColors.add(colour);
  }
  public void generateRelayList(int connectivity) {
    for (int i=_PYColors.size(); i<_SLColors.size(); i++)
      for (Vertex node : _SLColors.get(i).vertices) {
        for (Color colour : _PYColors) {
          int size=node.linksAt(colour).size();
          if (size>=connectivity)
            node.colorList[size-2].addLast(colour);
        }
        pushRelayList(relayList.length, node);
      }
  }
  public int colour(boolean[] slot, int connection) {//relay coloring //connection is the index+1
    if (relayList[connection-1].isEmpty())
      connection--;
    else {
      Vertex nodeA=relayList[connection-1].removeFirst();
      for (int i=0; i<_PYColors.size(); i++)
        slot[i]=false;
      for (int i=_PYColors.size(); i<_SLColors.size(); i++)
        for (Vertex nodeB : nodeA.linksAt(_SLColors.get(i)))
          if (nodeB.relayColor!=null)
            slot[nodeB.relayColor.index-_SLColors.size()]=true;
      for (Color colour : nodeA.colorList[connection-2])
        if (!slot[colour.index]) {
          nodeA.relayColor=getColor(colour.index+_SLColors.size());
          if (nodeA.relayColor.vertices.isEmpty())
            _RLColors.add(nodeA.relayColor);
          nodeA.relayColor.vertices.addLast(nodeA);
          break;
        }
      if (nodeA.relayColor==null)
        pushRelayList(connection-1, nodeA);
    }
    return connection;
  }
  public void initailizeBackbones() {
    if (backbone==null||backbone.length<_RLColors.size())
      backbone=new Component[_RLColors.size()];
  }
  public Component getBackbone(int index) {
    if (backbone[index]==null)
      if (_RLColors.isEmpty())
        backbone[index]=new Component(gui.mainColor, gui.mainColor, topology.connectivity());
      else
        backbone[index]=new Component(_PYColors.get(_RLColors.get(index).index-_SLColors.size()), _RLColors.get(index), topology.connectivity());
    else if (backbone[index].archive==-1)
      if (_RLColors.isEmpty())
        backbone[index].reset(gui.mainColor, gui.mainColor);
      else
        backbone[index].reset(_PYColors.get(_RLColors.get(index).index-_SLColors.size()), _RLColors.get(index));
    return backbone[index];
  }
  public void calculateBackbones() {
    initailizeBackbones();
    for (int i=0; i<_RLColors.size(); i++)
      while (getBackbone(i).deleting());
  }
  public void pushRelayList(int index, Vertex node) {
    while (--index>0&&node.colorList[index-1].isEmpty());
    relayList[index].addLast(node);
    if (index<connectivity-1)
      node.order[1]=-5;//surplus indicator
  }
  public Color getColor(int index) {
    while (index>=colorLibrary.size())
      colorLibrary.add(generateColor(colorLibrary.size()));
    return colorLibrary.get(index);
  }
  public Color generateColor(int index) {
    float division=11184810.6667f/(maxMinDegree+1);
    int value=floor(random(16777216-division*(index+1), 16777216-division*index));
    return new Color(value, index);
  }
  public int surplus() {
    int order=0;
    for (int i=0; i<connectivity-1; i++)
      order+=relayList[i].size();
    return order;
  }
}
class GraphGenerating extends Procedure implements Screen {
  int _N;
  Radio methods=new Radio("Exhaustive method", "Sweep method", "Cell method"), coordinates=new Radio("Cartesian system", "Cylindrical system", "Spherical system");
  Slider edgeWeight=new Slider("Edge weight");
  Checker remainingVertices=new Checker("Remaining vertices"), generatedGraph=new Checker("Generated graph");
  Switcher showEdge=new Switcher("Edge", "Edge");
  GraphGenerating() {
    word=new String[3];
    parts.addLast(remainingVertices);
    parts.addLast(generatedGraph);
    switches.addLast(showEdge);
    tunes.addLast(edgeWeight);
    remainingVertices.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.0002f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    if (navigation.end==1) {
      navigation.end=-2;
      interval.setPreference(ceil(graph.vertex.length*7.0f/3200), ceil(graph.vertex.length/3.0f), ceil(graph.vertex.length*7.0f/3200));
      if (navigation.auto) {
        methods.value=graph.methodIndex;
        coordinates.value=graph.coordinateIndex;
      } else {
        graph.methodIndex=methods.value;
        graph.coordinateIndex=coordinates.value;
      }
      updateCoordinates();
    } else if (navigation.auto)
      restart();
  }
  public void restart() {
    reset();
    graph.method[methods.value].reset();
  }
  public void reset() {
    navigation.end=-2;
    for (Vertex node : graph.vertex) {
      node.neighbors.clear();
      node.lowpoint=-1;
    }
    graph._E=0;
  }
  public void updateCoordinates() {//update coodinates when methods changed
    if (methods.value==2&&graph.topology.value!=4&&coordinates.labels.size()==3)
      coordinates.labels.removeLast();
    else if (coordinates.labels.size()==2)
      coordinates.labels.addLast("Spherical system");
    graph.initialize();
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&!graph.method[methods.value].connecting()) {
        navigation.end=2;
        if (navigation.auto)
          navigation.go(408);
        play.value=false;
      }
    }
  }
  public void show() {
    _N=0;
    for (Vertex nodeA : graph.vertex) {
      if (nodeA.lowpoint<0) {
        if (remainingVertices.value) {
          stroke(gui.partColor[0].value);
          if (showNode.value) {
            displayNode(nodeA);
            _N++;
          }
        }
      } else if (generatedGraph.value) {
        stroke(gui.mainColor.value);
        if (showEdge.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeA.value<nodeB.value)
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
        if (showNode.value) {
          displayNode(nodeA);
          _N++;
        }
      }
    }
  }
  public void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Methods:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    methods.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.gap()+gui.thisFont.stepY());
    if (methods.value>0) {
      fill(gui.headColor[2].value);
      text("Coordinates:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap());
      coordinates.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap(2));
    }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Graph gernerating...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(6));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0f/graph.vertex.length);
    word[1]="Edges: "+(generatedGraph.value&&showEdge.value?graph._E:0);
    word[2]=String.format("Average degree: %.2f", generatedGraph.value&&showEdge.value?graph._E*2.0f/_N:0);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(7+i));
  }
  public void moreMousePresses() {
    edgeWeight.active();
  }
  public void moreMouseReleases() {
    showEdge.active();
    if (methods.active()) {
      reset();
      graph.methodIndex=methods.value;
      graph.coordinateIndex=coordinates.value=0;
      updateCoordinates();
    }
    if (coordinates.active()) {
      reset();
      graph.coordinateIndex=coordinates.value;
      graph.initialize();
    }
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
}
public class IO {
  ArrayList<Graph> results=new ArrayList<Graph>();
  LinkedList<String> resultLabels=new LinkedList<String>();
  StringBuffer path=new StringBuffer("Results");
  boolean mode, load;
  String[] info;
  String nodes, file;
  int[] size=new int[8];//0->bipartite, 1->giant component, 2->two-core, 3->giant block, 4->surplus I, 5->surplus II, 6->surplus III, 7->surplus IV
  Action loadAction=new Action() {
    public void go() {
      switch(box.option) {
      case 0:
        if (navigation.page==0)
          screen[0].setting();
        else
          navigation.go(103);
        break;
      case 1:
        if (navigation.page==19)
          screen[19].setting();
        navigation.go(102);
        break;
      case 2:
        if (navigation.page==20)
          screen[20].setting();
        navigation.go(101);
      }
    }
  }
  , recordAction=new Action() {
    public void go() {
      if (box.option==0) {
        graph=results.get(box.entry.value);
        if (navigation.page>11&&navigation.page<19&&navigation.page!=15)
          screen[navigation.page].setting();
      }
    }
  };
  public void record() {
    results.add(graph);
    resultLabels.addLast("Graph #"+graph.index+": "+graph.topology);
  }
  public void selectGraph() {
    if (results.isEmpty())
      error.logOut("Graph selection error - No graph computed");
    else
      box.pop(resultLabels, "Records", recordAction, "Confirm", "Cancel");
  }
  public void saveAs(String name) {
    if (name.equals("graph"))
      gui.thread=3;
    else if (name.equals("graph summary"))
      gui.thread=4;
    if (mode)
      selectOutput("Save "+name+" to:", "graphFile", new File(path.toString()), this);
    else {
      file=path+System.getProperty("file.separator")+name+" ("+month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second()+").wsn";
      thread("daemon");
    }
  }
  public void graphFile(File selection) {
    if (selection!=null) {
      file=selection.getAbsolutePath();
      thread("daemon");
    }
  }
  public void graphInfo() {
    String text=graph.topology+": G("+graph.vertex.length+", "+graph.r+")"+System.getProperty("line.separator");
    for (Vertex node : graph.vertex)
      text+="("+node.value+", "+node.x+", "+node.y+", "+node.z+") ";
    output(text);
    box.pop("Graph saved!", "Information", "Great!");
  }
  public void graphSummary() {
    graph.initailizeBackbones();
    String separator=System.getProperty("line.separator");
    String text="Topology,"+graph.topology+separator;
    text+="N,"+graph.vertex.length+separator;
    text+="r,"+graph.r+separator;
    text+="Edge,"+graph._E+separator;
    text+="Average degree,"+graph._E*2.0f/graph.vertex.length+separator;
    text+="Maximum degree,"+graph.maxDegree+separator;
    text+="Minimum degree,"+graph.minDegree+separator;
    text+="Maximum minimum-degree,"+graph.maxMinDegree+separator;
    text+="Termial clique size,"+graph.clique.size()+separator;
    text+="Colors,"+graph._SLColors.size()+separator;
    text+="Primary colors,"+graph._PYColors.size()+separator;
    text+="Relay colors,"+graph._RLColors.size()+separator;
    text+=String.format("Partition percentile,%.2f%%", graph.primaries*100.0f/graph.vertex.length)+separator;
    text+="Surplus,"+graph.surplus();
    output(text);
    box.pop("Graph summary saved.", "Information", "Well done!");
  }
  public void output(String text) {
    PrintWriter out=createWriter(file);
    out.println(text);
    out.close();
  }
  public void loadGraph(File selection) {
    if (selection!=null) {
      BufferedReader reader = createReader(selection.getAbsolutePath());
      try {
        info=splitTokens( reader.readLine(), "G(,)");
        nodes=reader.readLine();
        reader.close();
      } 
      catch (IOException e) {
        error.logOut("File read error - "+e.getMessage());
      }
      load=true;
      box.pop("Load success! New graph, computation or demonstraction?", "Option", loadAction, "Graph", "Deploy", "Demo");
    }
  }
  public void loadVertices() {
    String[] coordinate=splitTokens(nodes, "(,) ");
    try {
      for (int i=0; i<graph.vertex.length; i++) {
        int value=PApplet.parseInt(coordinate[i*4]);
        double x=Double.parseDouble(coordinate[i*4+1]), y=Double.parseDouble(coordinate[i*4+2]), z=Double.parseDouble(coordinate[i*4+3]);
        graph.vertex[value]=new Vertex(value, x, y, z, graph.topology.connectivity());
      }
    }
    catch(NumberFormatException e) {
      error.logOut("Load graph error - "+e.getMessage());
      load=false;
    }
    load=false;
  }
}
class Image {
  PImage picture;
  float imageWidth, imageHeight;
  Image(String imageFile) {
    picture=loadImage(imageFile);
  }
  public void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
  public void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      imageWidth=gui.unit(picture.width)*factor;
      imageHeight=gui.unit(picture.height)*factor;
      break;
    case GUI.WIDTH:
      imageWidth=factor;
      imageHeight=picture.height*factor/picture.width;
      break;
    case GUI.HEIGHT:
      imageWidth=picture.width*factor/picture.height;
      imageHeight=factor;
    }
    image(picture, x, y, imageWidth, imageHeight);
  }
}
abstract class IndependentSet extends Result implements Screen {
  int _E;
  Color colour;
  Slider partiteIndex=new Slider("Partite #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Region region=new Region();
  Vertex nodeM=new Vertex();
  Checker partite=new Checker("Partite");
  Switcher showRegion=new Switcher("Region", "Region"), showMeasurement=new Switcher("Measurement", "Measurement"), arrow=new Switcher("Arrow", "Arrow");
  HashSet<Vertex> domain=new HashSet<Vertex>();
  ArrayList<Color> colorPool;
  public abstract void setColorPool();
  IndependentSet() {
    parts.addLast(partite);
    switches.addLast(showRegion);
    switches.addLast(showMeasurement);
    tunes.addLast(partiteIndex);
    showMeasurement.value=showRegion.value=false;
  }
  public void setting() {
    initialize();
    setColorPool();
    partiteIndex.setPreference(1, colorPool.size());
    setPartite();
  }
  public void show() {
    _E=0;
    for (ListIterator<Vertex> i=colour.vertices.listIterator(); i.hasNext(); ) {
      Vertex nodeA=i.next();
      if (showEdge.value)
        if (showMeasurement.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              nodeM.setCoordinates((nodeA.x+nodeB.x)/2, (nodeA.y+nodeB.y)/2, (nodeA.z+nodeB.z)/2);
              stroke(gui.partColor[nodeA.value<nodeB.value?1:2].value);
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeM.x, (float)nodeM.y, (float)nodeM.z);
              stroke(gui.partColor[nodeA.value<nodeB.value?2:1].value);
              line((float)nodeM.x, (float)nodeM.y, (float)nodeM.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              if (arrow.value)
                arrow((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        } else if (partite.value) {
          stroke(colour.value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        }
      if (partite.value) {
        if (showRegion.value) {
          strokeWeight(edgeWeight.value);
          region.display(i.nextIndex(), nodeA);
        }
        if (showNode.value) {
          stroke(colour.value);
          displayNode(nodeA);
        }
      }
    }
  }
  public void moreMousePresses() {
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
    if (partiteIndex.active())
      setPartite();
  }
  public void moreMouseReleases() {
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (showMeasurement.active())
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
    if (showMeasurement.value)
      arrow.active();
  }
  public void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
      break;
    case 'm':
      showMeasurement.value=!showMeasurement.value;
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
    }
  }
  public void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (partiteIndex.value==partiteIndex.min)
        partiteIndex.setValue(partiteIndex.max);
      else
        partiteIndex.decreaseValue();
      setPartite();
      break;
    case '.':
    case '>':
      if (partiteIndex.value==partiteIndex.max)
        partiteIndex.setValue(partiteIndex.min);
      else
        partiteIndex.increaseValue();
      setPartite();
    }
  }
  public void setPartite() {//start from 1
    if (colorPool.isEmpty())
      colour=gui.mainColor;
    else
      colour=colorPool.get(round(partiteIndex.value)-1);
    colour.initialize(domain);
    regionAmount.setPreference(1, colour.vertices.size());
    region.amount=round(regionAmount.value);
    while (colour.deploy==1)
      colour.deploying();
  }
  public void arrow(float x1, float y1, float z1, float x2, float y2, float z2) {
    noFill();
    PVector tangent=new PVector(x2-x1, y2-y1, z2-z1), yAxis=new PVector(0, 1, 0), normal=tangent.cross(yAxis);
    pushMatrix();
    translate((x1+x2)/2, (y1+y2)/2, (z1+z2)/2);
    rotate(-PVector.angleBetween(tangent, yAxis), normal.x, normal.y, normal.z);
    float angle = 0, angleIncrement = TWO_PI/4;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < 5; ++i) {
      vertex(0, -gui.unit(0.005f), 0);
      vertex(gui.unit(0.004f)*cos(angle), gui.unit(0.002f), gui.unit(0.004f)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    angle = 0;
    beginShape(TRIANGLE_FAN);
    vertex(0, gui.unit(0.003f), 0);
    for (int i = 0; i < 5; i++) {
      vertex(gui.unit(0.004f)*cos(angle), gui.unit(0.002f), gui.unit(0.004f)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    popMatrix();
  }
  public void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", (showNode.value&&partite.value)?colour.vertices.size():0, ((showNode.value&&partite.value)?colour.vertices.size():0)*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", (showNode.value&&partite.value)?_E*2.0f/colour.vertices.size():0);
    int domination=partite.value&&showNode.value?colour.domination:0;
    word[3]=String.format("Dominates: %d (%.2f%%)", domination, domination*100.0f/graph.vertex.length);
    word[4]=String.format("Maximum distance: %.3f", (_E==0)?0:colour.maxDistance);
    word[5]=String.format("Minimum distance: %.3f", (_E==0)?0:colour.minDistance);
    word[6]=String.format("Average distance: %.3f", (_E==0)?0:colour.distance/_E);
    int len=7;
    if (colour.cycles[0]>-1&&graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len=11;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=showEdge.value?_E-colour.vertices.size()+graph.topology.characteristic():0;
      word[7]="Faces: "+faces;
      word[8]=String.format("Average face size: %.2f", faces>0?_E*2.0f/faces:0);
      word[9]=showEdge.value?String.format("3-cycle faces: %d (%.2f%%)", colour.cycles[0], colour.cycles[0]*100.0f/faces):"3-cycle faces: 0 (0.00%)";
      word[10]=showEdge.value?String.format("4-cycle faces: %d (%.2f%%)", colour.cycles[1], colour.cycles[1]*100.0f/faces):"4-cycle faces: 0 (0.00%)";
    }
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+1+i));
  }
}
class Input {
  int position;
  float x, y, inputWidth, inputHeight, promptLength, wordLength;
  String prompt, value="";
  StringBuffer word;
  Input(String prompt) {
    this(prompt, new StringBuffer(""));
  }
  Input(String prompt, StringBuffer word) {
    this.prompt=prompt;
    this.word=word;
    value=word.toString();
    position=word.length();
  }
  public boolean active() {
    if (mouseX>x&&mouseX<x+inputWidth&&mouseY>y&&mouseY<y+inputHeight) {
      if (mouseX-x-promptLength>0)
        position=round((mouseX-x-promptLength)*word.length()/wordLength);
      return true;
    }
    return false;
  }
  public void setValue(String value) {
    this.value=value;
    position=value.length();
    word.delete(0, word.length());
    word.append(value);
  }
  public void cin(float x, float y) {
    pushStyle();
    initialize(x, y);
    text(prompt+word.substring(0, position)+(frameCount/10%2==0?' ':'|')+word.substring(position, word.length()), x, y+gui.thisFont.stepY());
    popStyle();
  }
  public void display(float x, float y) {
    pushStyle();
    initialize(x, y);
    text(prompt+value, x, y+gui.thisFont.stepY());
    popStyle();
  }
  public void initialize(float x, float y) {
    textAlign(LEFT);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    inputWidth=textWidth(prompt+value);
    inputHeight=gui.thisFont.stepY()+gui.thisFont.gap();
    wordLength=textWidth(word.toString());
    promptLength=textWidth(prompt);
  }
  public void commit() {
    value=word.toString();
  }
  public void abstain() {
    word.delete(0, word.length());
    word.append(value);
  }
  public void clean() {
    value="";
    word.delete(0, word.length());
    position=0;
  }
  public void keyType() {
    word.insert(position, key);
    position++;
  }
  public void keyPress() {
    switch(key) {
    case BACKSPACE:
      if (position>0) {
        position--;
        word.deleteCharAt(max(0, position));
      }
      break;
    case DELETE:
      if (position<word.length())
        word.deleteCharAt(position);
      break;
    case CODED:
      if (keyCode==RIGHT)
        if (word.length()>position)
          position++;
      if (keyCode==LEFT)
        if (position>0)
          position--;
    }
  }
}
abstract class Method {
  int index;//coordinateIndex
  public abstract boolean connecting();
  public abstract void reset();
  public void setCoordinate(int index) {
    this.index=index;
    reset();
  }
}
class Navigation {
  int page, nextPage, option, end=-420;
  int[] readyPage={-1, -1, -1};
  boolean ready, auto, lock;//lock item controled by keyboard
  float itemLength, subItemLength, barWidth, barHeight;
  LinkedList<String>[] items=new LinkedList[]{new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>()};
  String[] itemTarget={"New demonstration [3]", "Save primary set summary [4]", "Primary independent sets [3]", "Smallest-last coloring bipartites [7]", "Degree distribution histogram [1]", "System settings [2]", "Documentation [1]"};//itemTarget means the longest item (in text) among the whole menu list.
  Navigation() {
    items[0].addFirst("New graph [1]");//103
    items[0].addFirst("New computation [2]");//102
    items[0].addFirst("New demonstration [3]");//101
    items[0].addFirst("New [N]");//100
    items[1].addFirst("Load graph [1]");//207
    items[1].addFirst("Save graph [2]");//206
    items[1].addFirst("Save graph summary [3]");//205
    items[1].addFirst("Save primary set summary [4]");//204
    items[1].addFirst("Save relay set summary [5]");//203
    items[1].addFirst("Save backbone summary [6]");//202
    items[1].addFirst("Save domination degree [7]");//201
    items[1].addFirst("Files [F]");//200
    items[2].addFirst("Select graph [1]");//306
    items[2].addFirst("Terminal clique [2]");//305
    items[2].addFirst("Primary independent sets [3]");//304
    items[2].addFirst("Relay independent sets [4]");//303
    items[2].addFirst("Backbones [5]");//302
    items[2].addFirst("Surplus [6]");//301
    items[2].addFirst("Results [R]");//300
    items[3].addFirst("Node distribution [1]");//410
    items[3].addFirst("Graph generation [2]");//409
    items[3].addFirst("Smallest-last ordering [3]");//408
    items[3].addFirst("Smallest-last coloring [4]");//407
    items[3].addFirst("Partitioning [5]");//406
    items[3].addFirst("Relay coloring [6]");//405
    items[3].addFirst("Smallest-last coloring partites [7]");//404
    items[3].addFirst("Relay coloring partites [8]");//403
    items[3].addFirst("Smallest-last coloring bipartites [9]");//402
    items[3].addFirst("Relay coloring bipartites [10]");//401
    items[3].addFirst("Procedures [P]");//400
    items[4].addFirst("Degree distribution histogram [1]");//503
    items[4].addFirst("Vertex-degree plot [2]");//502
    items[4].addFirst("Color-size plot [3]");//501
    items[4].addFirst("Charts [C]");//500
    items[5].addFirst("Font settings [1]");//603
    items[5].addFirst("System settings [2]");//602
    items[5].addFirst("Color settings [3]");//601
    items[5].addFirst("Settings [S]");//600
    items[6].addFirst("Documentation [1]");//702
    items[6].addFirst("About [2]");//701
    items[6].addFirst("Help [H]");//700
  }
  public float getLength(String item) {
    return textWidth(item)+gui.thisFont.stepX(2);
  }
  public boolean active() {
    return option!=0;
  }
  public boolean itemRange(int i) {
    return mouseX>width/2+(i-items.length/2.0f)*itemLength&&mouseX<width/2+(i-items.length/2.0f+1)*itemLength&&mouseY>height-barHeight;
  }
  public boolean subItemRange(int i, int j) {
    return mouseX>width/2+(i-items.length/2.0f+0.5f)*itemLength-subItemLength/2&&mouseX<width/2+(i-items.length/2.0f+0.5f)*itemLength+subItemLength/2&&mouseY<height-barHeight*j-barHeight/2&&mouseY>height-barHeight*(1+j)-barHeight/2;
  }
  public void display() {
    push();
    translate(width/2, height);
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    barHeight=gui.thisFont.stepY(2.5f);
    itemLength=getLength("Procedures [P]");//longest main menu item
    barWidth=itemLength*items.length;
    fill(gui.colour[2].value, 50);
    noStroke();
    rect(0, -barHeight/2, barWidth, barHeight, gui.unit(10), gui.unit(10), 0, 0);
    strokeWeight(gui.unit());
    for (int i=0; i<items.length; i++) {
      noStroke();
      fill(gui.colour[2].value, 50);
      if (itemRange(i))
        rect(itemLength*(i-items.length/2.0f+0.5f), -barHeight/2, itemLength-gui.unit(6), barHeight-gui.unit(6), gui.unit(10), gui.unit(10), 0, 0);
      if (option>=100*(i+1)&&option<(i+2)*100) {
        ListIterator<String> itemIterator=items[i].listIterator(1);
        subItemLength=getLength(itemTarget[i]);
        quad((i-items.length/2.0f+0.5f)*itemLength-subItemLength/2, -1.5f*barHeight, (i-items.length/2.0f+0.5f)*itemLength+subItemLength/2, -1.5f*barHeight, (i-items.length/2.0f+1)*itemLength-gui.thisFont.stepX(), -barHeight, (i-items.length/2.0f)*itemLength+gui.thisFont.stepX(), -barHeight);
        rect((i-items.length/2.0f+0.5f)*itemLength, -(items[i].size()-1)*barHeight/2-1.5f*barHeight, subItemLength, (items[i].size()-1)*barHeight, gui.unit(10), gui.unit(10), 0, 0);
        for (int j=1; j<items[i].size(); j++) {
          fill(gui.colour[2].value, 50);
          if (subItemRange(i, j))
            rect(itemLength*(i-items.length/2.0f+0.5f), -barHeight*(1+j), subItemLength-gui.unit(6), barHeight-gui.unit(6), gui.unit(10), gui.unit(10), 0, 0);
          fill(gui.bodyColor[option==100*(i+1)+j?0:2].value);
          text(itemIterator.next(), (i-items.length/2.0f+0.5f)*itemLength, -barHeight*(j+1));
        }
        stroke(gui.colour[1].value);
        for (int j=2; j<items[i].size(); j++)
          line(itemLength*(i-items.length/2.0f+0.5f)-subItemLength/2+gui.unit(3), -barHeight*j-barHeight/2, itemLength*(i-items.length/2.0f+0.5f)+subItemLength/2-gui.unit(3), -barHeight*j-barHeight/2);
      }
      fill(gui.bodyColor[option==-100*(i+1)?0:2].value);
      text(items[i].getFirst(), (i-items.length/2.0f+0.5f)*itemLength, -barHeight/2);
    }
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    for (int i=1; i<items.length; i++)
      dottedLine(itemLength*(i-items.length/2.0f), 0, itemLength*(i-items.length/2.0f), -barHeight);
    pop();
  }
  public void releaseOption() {
    if (option<0) {
      option=-option;
      go(option);
    } else {
      go(option);
      option=0;
    }
  }
  public void go(int option) {//end from Node distribtuting to Relay coloring is 1 to 6, New graph is 0
    switch(option) {
    case 103://New graph
      nextPage=0;
      break;
    case 102://New computation
      nextPage=19;
      break;
    case 101://New demonstration
      nextPage=20;
      break;
    case 207://Load graph
      selectInput("Select WSN file:", "loadGraph", new File("Results"+System.getProperty("file.separator")+"."), io);
      break;
    case 206://Save graph
      if (end>=1)
        io.saveAs("graph");
      else
        error.logOut("File save error - No graph generated!");
      break;
    case 205://Save graph summary
      if (end>=6)
        io.saveAs("graph summary");
      else
        error.logOut("File save error - Computation not finished!");
      break;
    case 204://Save primary set summary
      if (end>=5)
        //io.savePrimarySetSummary();
        //else
        error.logOut("File save error - Computation not finished!");
      break;
    case 203://Save relay set summary
      if (end>=6)
        //io.saveRelaySetSummary();
        //else
        //error.logOut("File save error - Computation not finished!");
        break;
    case 202://Save backbone summary
      if (end>=6)
        //io.saveBackboneSummary();
        //else
        //error.logOut("File save error - Computation not finished!");
        break;
    case 201://Save domination degree
      if (end>=6)
        //io.saveDominationDegree();
        //else
        //error.logOut("File save error - Computation not finished!");
        break;
    case 306://Select graph
      io.selectGraph();
      break;
    case 305://Terminal clique
      if (end>=3)
        nextPage=11;
      break;
    case 304://Primary independent sets
      if (end>=5)
        nextPage=12;
      break;
    case 303://Relay independent sets
      if (end>=6)
        nextPage=13;
      break;
    case 302://Backbones
      if (end>=6)
        nextPage=14;
      break;
    case 301://Surplus
      if (end>=6)
        nextPage=15;
      break;
    case 410://Node distributing
      if (end>=0&&end<7)
        nextPage=1;
      break;
    case 409://Graph Generating
      if (end>=1&&end<7)
        nextPage=2;
      break;
    case 408://Smallest-last Ordering
      if (end>=2&&end<7)
        nextPage=3;
      break;
    case 407://Smallest-last Coloring
      if (end>=3&&end<7)
        nextPage=4;
      break;
    case 406://Partitioning
      if (end>=4&&end<7)
        nextPage=5;
      break;
    case 405://Relay coloring
      if (end>=5&&end<7)
        nextPage=6;
      break;
    case 404://Smallest-last coloring partites
      if (end>=4&&end<7)
        nextPage=7;
      break;
    case 403://Relay coloring partites
      if (end>=6&&end<7)
        nextPage=8;
      break;
    case 402://Smallest-last coloring bipartites
      if (end>=4&&end<7)
        nextPage=9;
      break;
    case 401://Relay coloring bipartites
      if (end>=6&&end<7)
        nextPage=10;
      break;
    case 503://Degree distribution histogram
      if (end>=3)
        nextPage=16;
      break;
    case 502://Vertex-degree plot
      if (end>=3)
        nextPage=17;
      break;
    case 501://Smallest-last Color-size plot
      if (end>=4)
        nextPage=18;
      break;
    case 601://Color settings
      if (end>=0||end==-420)
        nextPage=21;
      break;
    case 602://System settings
      if (end>=0||end==-420)
        nextPage=22;
      break;
    case 603://Font settings
      if (end>=0||end==-420)
        nextPage=23    ;
      break;
    case 702://Documentation
      //if (Desktop.isDesktopSupported())
      //try {
      //Desktop.getDesktop().open(new File(dataPath("Documentation.pdf")));
      //}
      //catch (IOException e) {
      //error.logOut("File open error - "+e.getMessage());
      //}
      break;
    case 701://About
      if (end>=0||end==-420)
        nextPage=24;
    }
    if (page!=nextPage) {
      page=screen.length-1;
      screen[page].setting();
      screen[nextPage].setting();
    }
  }
  public void dottedLine(float x1, float y1, float x2, float y2) {
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++) {
      float x = lerp(x1, x2, i/steps);
      float y = lerp(y1, y2, i/steps);
      point(x, y);
    }
  }
  public void keyPress() {
    if (key==CODED&&keyCode==ALT)
      lock=true;
    if (lock) {
      switch(Character.toLowerCase(key)) {
      case 'n':
        option=-100;
        break;
      case 'f':
        option=-200;
        break;
      case 'r':
        option=-300;
        break;
      case 'p':
        option=-400;
        break;
      case 'c':
        option=-500;
        break;
      case 's':
        option=-600;
        break;
      case 'h':
        option=-700;
      }
      if (option>0&&key>'0'&&key<'0'+items[option/100-1].size())
        option+=items[option/100-1].size()-PApplet.parseInt(key)+48;
    }
    if (option>0&&key==CODED) {
      if (keyCode==UP) {
        if (option%100==items[option/100-1].size())
          option-=option%100;
        option++;
      }
      if (keyCode==DOWN) {
        if (option%100==0)
          option+=items[option/100-1].size()-option%100;
        option--;
      }
    }
  }
  public void keyRelease() {
    if (lock) {
      releaseOption();
      lock=false;
    }
    if (option>0&&(key==ENTER||key==RETURN)) {
      go(option);
      option=0;
    }
  }
  public void mousePress() {
    for (int i=0; i<items.length; i++) {
      if (itemRange(i)) {
        option=option==100*(i+1)?0:-100*(i+1);
        break;
      }
      if (option==100*(i+1)&&!itemTarget[i].equals("")) {
        boolean out=false;
        for (int j=1; j<items[i].size(); j++)
          if (subItemRange(i, j)) {
            option+=j;
            out=true;
            break;
          }
        if (out)
          break;
      }
    }
  }
  public void mouseRelease() {
    releaseOption();
  }
}
abstract class New implements Screen {
  int index, _N;
  float logoSize;
  double r;
  ArrayList<Input> inputs=new ArrayList<Input>();
  HashMap<String, Input> inputLibrary=new HashMap<String, Input>();
  String theme;
  Topology topology;
  Animation animation;
  public abstract void enter()throws Exception;
  New() {
    inputLibrary.put("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue...", new Input("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."));
    inputLibrary.put("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ", new Input("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): "));
    inputLibrary.put("Enter vertex number: ", new Input("Enter vertex number: "));
    inputLibrary.put("Provide threshold (r or avg): ", new Input("Provide threshold (r or avg): "));
    inputLibrary.put("r=", new Input("r="));
    inputLibrary.put("avg≈", new Input("avg≈"));
    inputLibrary.put("Deploy algorithms now? (Yes or No): ", new Input("Deploy algorithms now? (Yes or No): "));
    inputs.add(inputLibrary.get("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."));
  }
  public void display() {
    push();
    gui.body.initialize();
    logoSize=gui.logo();
    translate(width/2, logoSize);
    fill(gui.bodyColor[2].value);
    for (int i=0; i<inputs.size(); i++)
      if (i!=index)
        inputs.get(i).display(-textWidth(inputs.get(i).prompt+inputs.get(i).word)/2, gui.thisFont.stepY(i));
    inputs.get(index).cin(-textWidth(inputs.get(index).prompt+inputs.get(index).word)/2, gui.thisFont.stepY(index));
    imageMode(CENTER);
    animation.display(GUI.HEIGHT, 0, height-logoSize-navigation.barHeight-height/10, height/5);
    textAlign(CENTER);
    fill(gui.bodyColor[1].value);
    text("<<- "+theme+": Ver. "+gui._V+" ->>", 0, height-navigation.barHeight-gui.thisFont.gap()-logoSize);
    popMatrix();
    navigation.display();
    popStyle();
  }
  public void setting() {
    for (int i=inputs.size()-1; i>0; i--)
      inputs.remove(i).clean();
    index=0;
    if (io.load) {
      try {
        enter();
        inputs.get(index).word.append(io.info[0]);
        enter();
        inputs.get(index).word.append(io.info[1]);
        enter();
        if (io.info.length>2) {
          inputs.get(index).word.append("r");
          enter();
          inputs.get(index).word.append(io.info[2]);
          enter();
        }
      }
      catch(Exception e) {
        io.load=false;
        setting();
      }
    }
  }
  public void defaultEnter(String prompt, String word, String nextPrompt) throws Exception {
    if (prompt.equals("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."))
      commit("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ");
    else if (prompt.equals("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ")) {
      if (word.contains("square"))
        topology=new Square();
      else if (word.contains("disk"))
        topology=new Disk();
      else if (word.contains("triangle"))
        topology=new Triangle();
      else if (word.contains("sphere"))
        topology=new Sphere();
      else if (word.contains("torus"))
        topology=new Torus();
      else if (word.contains("bottle"))
        topology=new Bottle();
      else if (word.contains("cube"))
        topology=new Cube();
      else if (word.contains("ball"))
        topology=new Ball();
      else
        throw new Exception('\"'+word+"\": No such topology");
      commit("Enter vertex number: ");
    } else if (prompt.equals("Enter vertex number: ")) {
      _N=Integer.parseInt(word);
      if (_N<=0)
        throw new NumberFormatException('\"'+word+"\": Invalid 'N' value"); 
      commit("Provide threshold (r or avg): ");
    } else if (prompt.equals("Provide threshold (r or avg): "))
      if (word.contains("r"))
        commit("r=");
      else if (word.contains("avg"))
        commit("avg≈");
      else
        throw new Exception('\"'+word+"\": No such threshold");
    else if (prompt.equals("r=")) {
      r=Double.parseDouble(word);
      if (r<0||r>topology.range)
        throw new NumberFormatException('\"'+word+"\": Invalid 'r' value");
      inputs.get(index).word.append(String.format(" (avg≈%.2f)", topology.getAvg(r, _N)));
      commit(nextPrompt);
    } else if (prompt.equals("avg≈")) {
      double avgDegree=Double.parseDouble(word);
      if (avgDegree<0||avgDegree>_N-1)
        throw new NumberFormatException('\"'+word+"\": Invalid average degree"); 
      r=topology.getR(avgDegree, _N);
      inputs.get(index).word.append(String.format(" (r=%.2f)", r));
      commit(nextPrompt);
    } else
      throw new Exception('\"'+prompt+"\": System error");
  }
  public void commit(String prompt) {
    for (int i=0; i<index; i++)
      inputs.get(i).abstain();
    inputs.get(index).commit();
    for (int i=inputs.size()-1; i>index; i--)
      inputs.remove(i).clean();
    inputs.add(inputLibrary.get(prompt));
    index++;
  }
  public void keyPress() {
    navigation.keyPress();
    if (!navigation.active()) {
      inputs.get(index).keyPress();
      switch(key) {
      case ENTER:
      case RETURN:
        try {
          enter();
        }
        catch (Exception e) {
          error.logOut("Menu input - "+e.getMessage());
        }
        break;
      case CODED:
        switch(keyCode) {
        case UP:
          if (index>0)
            index--;
          else
            index=inputs.size()-1;
          break;
        case DOWN:
          index=(index+1)%inputs.size();
        }
      }
    }
  }
  public void keyRelease() {
    navigation.keyRelease();
  }
  public void keyType() {
    if (!navigation.active())
      inputs.get(index).keyType();
  }
  public void mousePress() {
    navigation.mousePress();
    if (!navigation.active())
      for (Input input : inputs)
        input.active();
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active())
      for (int i=0; i<inputs.size(); i++)
        if (i!=index&&inputs.get(i).active())
          index=i;
  }
  public void mouseDrag() {
  }
  public void mouseScroll(MouseEvent event) {
  }
}
class NewComputation extends NewDeployment {
  int index;
  NewComputation() {
    animation=new GIF("Rasengan", 58);
    theme="New computation";
  }
  public void finish()throws Exception {
    graph=new Graph(index, topology, _N, r, method, coordinate, mode, breakpoint, connectivity);
    if (io.load)
      io.loadVertices();
    gui.thread=2;
    thread("daemon");
    setting();
    index++;
  }
}
class NewDemonstration extends NewDeployment {
  NewDemonstration() {
    animation=new GIF("Infinity", 91);
    theme="New demonstration";
  }
  public void finish()throws Exception {
    graph=new Graph(topology, _N, r, method, coordinate, mode, breakpoint, connectivity);
    if (io.load)
      io.loadVertices();
    navigation.auto=true;
    navigation.end=0;
    navigation.go(410);
  }
}
abstract class NewDeployment extends New {
  int method, coordinate, connectivity;
  float breakpoint;
  boolean mode;
  public abstract void finish()throws Exception;
  NewDeployment() {
    inputLibrary.put("Select graph generating method (Exhaustive, Sweep or Cell): ", new Input("Select graph generating method (Exhaustive, Sweep or Cell): "));
    inputLibrary.put("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ", new Input("Choose a coordinate system (Cartesian, Cylindrical or Spherical): "));
    inputLibrary.put("Choose a coordinate system (Cartesian or Cylindrical): ", new Input("Choose a coordinate system (Cartesian or Cylindrical): "));
    inputLibrary.put("Select primary sets: ", new Input("Select primary sets: "));
    inputLibrary.put("Enter connectivity: ", new Input("Enter connectivity: "));
  }
  public void enter() throws Exception {
    String prompt=inputs.get(index).prompt;
    String word=inputs.get(index).word.toString().toLowerCase();
    if (prompt.equals("Select graph generating method (Exhaustive, Sweep or Cell): ")) {
      if (word.contains("exhaustive")) {
        method=0;
        commit("Select primary sets: ");
      } else if (word.contains("sweep")) {
        method=1;
        commit("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ");
      } else if (word.contains("cell")) {
        method=2;
        commit(topology.value==4?"Choose a coordinate system (Cartesian, Cylindrical or Spherical): ":"Choose a coordinate system (Cartesian or Cylindrical): ");
      } else
        throw new Exception('\"'+word+"\": No such method");
    } else if (prompt.equals("Choose a coordinate system (Cartesian or Cylindrical): ")) {
      if (word.contains("cartesian"))
        coordinate=0;
      else if (word.contains("cylindrical"))
        coordinate=1;
      else
        throw new Exception('\"'+word+"\": No such coordinate system");
      commit("Select primary sets: ");
    } else if (prompt.equals("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ")) {
      if (word.contains("cartesian"))
        coordinate=0;
      else if (word.contains("cylindrical"))
        coordinate=1;
      else if (word.contains("spherical"))
        coordinate=2;
      else
        throw new Exception('\"'+word+"\": No such coordinate system");
      commit("Select primary sets: ");
    } else if (prompt.equals("Select primary sets: ")) {
      if (word.contains("%")) {
        breakpoint=Float.parseFloat(word.substring(0, word.indexOf("%")));
        if (breakpoint<=0||breakpoint>100)
          throw new NumberFormatException('\"'+word+"\": Invalid breakpoint");
        mode=true;
      } else {
        breakpoint=Integer.parseInt(word);
        if (breakpoint<=0)
          throw new NumberFormatException('\"'+word+"\": Invalid amount");
        mode=false;
      }
      commit("Enter connectivity: ");
    } else if (prompt.equals("Enter connectivity: ")) {
      connectivity=Integer.parseInt(word);
      if (connectivity<0||connectivity>topology.connectivity())
        throw new NumberFormatException('\"'+word+"\": Invalid connectivity");
      commit("Deploy algorithms now? (Yes or No): ");
    } else if (prompt.equals("Deploy algorithms now? (Yes or No): ")) {
      if (word.contains("n")) {
        io.load=false;
        setting();
      } else if (word.contains("y"))
        finish();
      else
        throw new Exception('\"'+word+"\": Nonsense message");
    } else
      defaultEnter(prompt, word, "Select graph generating method (Exhaustive, Sweep or Cell): ");
  }
}
class NewGraph extends New {
  NewGraph() {
    animation=new GIF("Tesseract", 48);
    theme="New graph";
  }
  public void enter() throws Exception {
    String prompt=inputs.get(index).prompt;
    String word=inputs.get(index).word.toString().toLowerCase();
    if (prompt.equals("Deploy algorithms now? (Yes or No): "))
      if (word.contains("n")) {
        io.load=false;
        setting();
      } else if (word.contains("y")) {
        graph=new Graph(topology, _N, r);
        if (io.load)
          io.loadVertices();
        navigation.end=0;
        io.load=navigation.auto=false;
        navigation.go(410);
      } else
        throw new Exception('\"'+word+"\": Nonsense message");
    else
      defaultEnter(prompt, word, "Deploy algorithms now? (Yes or No): ");
  }
}
class NodeDistributing extends Procedure implements Screen {
  int _N;
  Checker distributedNodes=new Checker("Distributed nodes");
  NodeDistributing() {
    word=new String[3];
    parts.addLast(distributedNodes);
  }
  public void setting() {
    initialize();
    if (navigation.end==0) {
      navigation.end=-1;
      interval.setPreference(ceil(graph.vertex.length*7.0f/3200), ceil(graph.vertex.length/3.0f), ceil(graph.vertex.length*7.0f/3200));
      _N=0;
    } else if (navigation.auto)
      _N=0;
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==graph.vertex.length) {
        if (navigation.end==-1)
          navigation.end=1;
        if (navigation.auto)
          navigation.go(409);
        play.value=false;
      }
      if (play.value) {
        if (graph.vertex[_N]==null)
          graph.vertex[_N]=graph.topology.generateVertex(_N);
        _N++;
      }
    }
  }
  public void show() {
    if (distributedNodes.value&&showNode.value) {
      stroke(gui.mainColor.value);
      for (int i=0; i<_N; i++)
        displayNode(graph.vertex[i]);
    }
  }
  public void restart() {
    _N=0;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Node distributing...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(6));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.4f", graph.r);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", distributedNodes.value&&showNode.value?_N:0, (distributedNodes.value&&showNode.value?_N:0)*100.0f/graph.vertex.length);
    word[1]=String.format("Complete: %.2f %%", _N*100.0f/graph.vertex.length);
    text(word[0], gui.thisFont.stepX(3), gui.thisFont.stepY(7));
    text(word[1], gui.thisFont.stepX(3), gui.thisFont.stepY(8));
  }
}
class Particle extends Star {
  float angle, distance;
  Particle(float x, float y, float angle, int colour) {
    this.x=x;
    this.y=y;
    this.colour=colour;
    this.angle=angle;
    destination=gui.unit(random(15));
  }
  public void update() {
    if (distance<destination) {
      x+=cos(angle)*distance;
      y+=sin(angle)*distance;
      distance+=0.1f;
    }
  }
}
abstract class Partite extends Procedure implements Screen {
  int _E;
  Color colour;
  Slider partiteIndex=new Slider("Partite #", 1, 1), regionAmount=new Slider("Region amount", 1, 1), edgeWeight=new Slider("Edge weight");
  Region region=new Region();
  Vertex nodeM=new Vertex();
  Checker partite=new Checker("Partite");
  Switcher showRegion=new Switcher("Region", "Region"), showEdge=new Switcher("Edge", "Edge"), showMeasurement=new Switcher("Measurement", "Measurement"), arrow=new Switcher("Arrow", "Arrow");
  HashSet<Vertex> domain=new HashSet<Vertex>();
  ArrayList<Color> colorPool;
  public abstract void setColorPool();
  Partite() {
    parts.addLast(partite);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
    tunes.addLast(partiteIndex);
    showMeasurement.value=showRegion.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.001f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    setColorPool();
    partiteIndex.setPreference(1, colorPool.size());
    setPartite();
  }
  public void restart() {
    colour.restart();
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&colour.deploy==0) {
        if (navigation.auto) {
          if (partiteIndex.value<partiteIndex.max) {
            partiteIndex.increaseValue();
            setPartite();
          } else
            navigation.go(401);
        }
        play.value=navigation.auto;
      }
      if (play.value)
        colour.deploying();
    }
  }
  public void show() {
    _E=0;
    for (ListIterator<Vertex> i=colour.vertices.listIterator(); i.hasNext(); ) {
      Vertex nodeA=i.next();
      if (showEdge.value)
        if (showMeasurement.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              nodeM.setCoordinates((nodeA.x+nodeB.x)/2, (nodeA.y+nodeB.y)/2, (nodeA.z+nodeB.z)/2);
              stroke(gui.partColor[nodeA.value<nodeB.value?1:2].value);
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeM.x, (float)nodeM.y, (float)nodeM.z);
              stroke(gui.partColor[nodeA.value<nodeB.value?2:1].value);
              line((float)nodeM.x, (float)nodeM.y, (float)nodeM.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              if (arrow.value)
                arrow((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        } else if (partite.value) {
          stroke(colour.value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        }
      if (partite.value) {
        if (showRegion.value) {
          strokeWeight(edgeWeight.value);
          region.display(i.nextIndex(), nodeA);
        }
        if (showNode.value) {
          stroke(colour.value);
          displayNode(nodeA);
        }
      }
    }
  }
  public void moreMousePresses() {
    edgeWeight.active();
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
    if (partiteIndex.active())
      setPartite();
  }
  public void moreMouseReleases() {
    showEdge.active();
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (showMeasurement.active())
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
    if (showMeasurement.value)
      arrow.active();
  }
  public void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
      break;
    case 'm':
      showMeasurement.value=!showMeasurement.value;
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
    }
  }
  public void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (partiteIndex.value==partiteIndex.min)
        partiteIndex.setValue(partiteIndex.max);
      else
        partiteIndex.decreaseValue();
      setPartite();
      break;
    case '.':
    case '>':
      if (partiteIndex.value==partiteIndex.max)
        partiteIndex.setValue(partiteIndex.min);
      else
        partiteIndex.increaseValue();
      setPartite();
    }
  }
  public void setPartite() {//start from 1
    if (colorPool.isEmpty())
      colour=gui.mainColor;
    else
      colour=colorPool.get(round(partiteIndex.value)-1);
    colour.initialize(domain);
    regionAmount.setPreference(1, colour.vertices.size());
    region.amount=round(regionAmount.value);
    interval.setPreference(1, ceil(colour.vertices.size()/3.0f), 1);
  }
  public void arrow(float x1, float y1, float z1, float x2, float y2, float z2) {
    noFill();
    PVector tangent=new PVector(x2-x1, y2-y1, z2-z1), yAxis=new PVector(0, 1, 0), normal=tangent.cross(yAxis);
    pushMatrix();
    translate((x1+x2)/2, (y1+y2)/2, (z1+z2)/2);
    rotate(-PVector.angleBetween(tangent, yAxis), normal.x, normal.y, normal.z);
    float angle = 0, angleIncrement = TWO_PI/4;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < 5; ++i) {
      vertex(0, -gui.unit(0.005f), 0);
      vertex(gui.unit(0.004f)*cos(angle), gui.unit(0.002f), gui.unit(0.004f)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    angle = 0;
    beginShape(TRIANGLE_FAN);
    vertex(0, gui.unit(0.003f), 0);
    for (int i = 0; i < 5; i++) {
      vertex(gui.unit(0.004f)*cos(angle), gui.unit(0.002f), gui.unit(0.004f)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    popMatrix();
  }
  public void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", (showNode.value&&partite.value)?colour.vertices.size():0, ((showNode.value&&partite.value)?colour.vertices.size():0)*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", (showNode.value&&partite.value)?_E*2.0f/colour.vertices.size():0);
    int domination=partite.value&&showNode.value?colour.domination:0;
    word[3]=String.format("Dominates: %d (%.2f%%)", domination, domination*100.0f/graph.vertex.length);
    word[4]=String.format("Maximum distance: %.3f", (_E==0)?0:colour.maxDistance);
    word[5]=String.format("Minimum distance: %.3f", (_E==0)?0:colour.minDistance);
    word[6]=String.format("Average distance: %.3f", (_E==0)?0:colour.distance/_E);
    int len=7;
    if (colour.cycles[0]>-1&&graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len=11;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=showEdge.value?_E-colour.vertices.size()+graph.topology.characteristic():0;
      word[7]="Faces: "+faces;
      word[8]=String.format("Average face size: %.2f", faces>0?_E*2.0f/faces:0);
      word[9]=showEdge.value?String.format("3-cycle faces: %d (%.2f%%)", colour.cycles[0], colour.cycles[0]*100.0f/faces):"3-cycle faces: 0 (0.00%)";
      word[10]=showEdge.value?String.format("4-cycle faces: %d (%.2f%%)", colour.cycles[1], colour.cycles[1]*100.0f/faces):"4-cycle faces: 0 (0.00%)";
    }
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+1+i));
  }
}
class Partitioning extends Procedure implements Screen {
  int _E, frame, pivot;
  Slider edgeWeight=new Slider("Edge weight"), breakpoint=new Slider("Selected percentile", 55, 1, 100, 1), selectColorSets=new Slider("Selected color sets", 1, 1);
  Switcher showEdge=new Switcher("Edge", "Edge");
  Checker remainingGraph=new Checker("Remaining graph"), selectedGraph=new Checker("Selected graph");
  LinkedList<String> modalLabels=new LinkedList<String>();
  Radio modes=new Radio(new String[]{"Auto select", "Manual select"});
  Partitioning() {
    word=new String[10];
    parts.addLast(remainingGraph);
    parts.addLast(selectedGraph);
    tunes.addLast(edgeWeight);
    switches.addLast(showEdge);
    remainingGraph.value=showEdge.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.0002f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    if (navigation.end==4) {
      selectColorSets.setMax(graph._SLColors.size()-1);
      interval.setPreference(1, frameRate, 1);
      navigation.end=-5;
      if (graph.primaries==-1) {
        selectColorSets.setValue(graph._SLColors.size()/2);
        if (navigation.auto) {
          modes.value=graph.mode?0:1;
          (graph.mode?breakpoint:selectColorSets).setValue(graph.breakpoint);
        } else {
          graph.mode=modes.value==0?true:false;
          graph.breakpoint=(graph.mode?breakpoint:selectColorSets).value;
        }
        updateSelection();
      } else
        clean();
    }
  }
  public void updateSelection() {//update selection after modal changed
    if (tunes.getLast()!=edgeWeight)
      tunes.removeLast();
    tunes.addLast(graph.mode?breakpoint:selectColorSets);
  }
  public void deploying() {
    if (play.value&&frameCount-frame>frameRate/interval.value) {
      if (pivot<graph._PYColors.size())
        pivot++;
      else if (graph.primaries<0) {
        graph.selectPrimarySet();
        pivot++;
      } else {
        pivot=min(pivot, graph._PYColors.size());
        if (navigation.end==-5)
          navigation.end=5;
        if (navigation.auto)
          navigation.go(405);
        play.value=false;
      }
      frame=frameCount;
    }
  }
  public void show() {
    _E=0;
    if (remainingGraph.value) {
      stroke(gui.mainColor.value);
      for (int i=pivot; i<graph._SLColors.size(); i++ )
        for (Vertex nodeA : graph._SLColors.get(i).vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&nodeB.primeColor.index>=pivot||selectedGraph.value&&nodeB.primeColor.index<pivot) {
                _E++;
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value)
            displayNode(nodeA);
        }
    }
    if (selectedGraph.value) {
      for (int i=0; i<pivot; i++) {
        Color colour=graph._SLColors.get(i);
        for (Vertex nodeA : colour.vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            stroke(gui.partColor[1].value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&nodeB.primeColor.index<pivot) {
                _E++;
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value) {
            stroke(colour.value);
            displayNode(nodeA);
          }
        }
      }
    }
  }
  public void restart() {
    pivot=0;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Partitioning...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(13));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int vertices=getN();
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0f/vertices);
    word[3]="Primary colors: "+pivot;
    if (modes.value==1)
      word[4]=String.format("Complete: %.2f%%", pivot*100/selectColorSets.value);
    for (int i=0; i<(modes.value==0?4:5); i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(14+i));
  }
  public void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Partition mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
  }
  public void moreMousePresses() {
    edgeWeight.active();
    if (tunes.getLast().active())
      reset();
  }
  public void moreMouseReleases() {
    showEdge.active();
    if (modes.active()) {
      graph.mode=modes.value==0?true:false;
      updateSelection();
      reset();
    }
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
  public void reset() {
    if (graph.breakpoint<tunes.getLast().value) {
      boolean resetColors=false;
      for (Color colour : graph._RLColors)
        if (colour.deployed()) {
          resetColors=true;
          break;
        }
      if (resetColors)
        for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++)
          graph._SLColors.get(i).deploy=-1;
    }
    graph.breakpoint=tunes.getLast().value;
    navigation.end=-5;
    clean();
  }
  public void clean() {
    graph._PYColors.clear();
    pivot=0;
    graph.primaries=-1;
  }
  public int getN() {
    if (selectedGraph.value&&remainingGraph.value)
      return graph.vertex.length;
    else if (selectedGraph.value)
      return getNodes(0, pivot);
    else if (remainingGraph.value)
      return getNodes(pivot, graph._SLColors.size());
    else
      return 0;
  }
  public int getNodes(int index, int len) {
    int sum=0;
    for (int i=index; i<len; i++)
      sum+=graph._SLColors.get(i).vertices.size();
    return sum;
  }
}
class PathBar {
  float x, y, barWidth, barHeight, pathHeight;
  boolean active;
  String label;
  Input path;
  PathBar(String label, StringBuffer path) {
    this.label=label;
    this.path=new Input("", path);
  }
  public void display(float x, float y, float barWidth) {
    pushStyle();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.barWidth=barWidth;
    barHeight=gui.thisFont.stepY(2)+gui.thisFont.gap(2);
    pathHeight=gui.thisFont.stepY()+gui.thisFont.gap();
    fill(gui.headColor[2].value);
    textAlign(LEFT);
    text(label+": ", x, y+gui.thisFont.stepY());
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(x, y+gui.thisFont.stepY()+gui.thisFont.gap(), barWidth, gui.thisFont.stepY()+gui.thisFont.gap());
    fill(gui.bodyColor[0].value);
    if (active)
      path.cin(x+gui.thisFont.stepX(), y+gui.thisFont.stepY()+gui.thisFont.gap());
    else
      path.display(x+gui.thisFont.stepX(), y+gui.thisFont.stepY()+gui.thisFont.gap());
    popStyle();
  }
  public void setPath(File selection) {
    if (selection!=null)
      path.value=selection.getAbsolutePath();
  }
  public void keyType() {
    if (active)
      path.keyType();
  }
  public void keyPress() {
    if (active) {
      path.keyPress();
      if (key==ENTER||key==RETURN) {
        path.commit();
        active=false;
      }
    }
  }
  public void mousePress() {
    path.active();
    if (mouseX>x&&mouseX<x+barWidth&&mouseY>y+pathHeight&&mouseY<y+barHeight)
      active=true;
    else {
      path.commit();
      active=false;
    }
  }
}
class Plot extends Chart {
  Plot(String labelX, String labelY, SysColor[] colors, String...bar) {
    super(labelX, labelY, colors, bar);
    drawPlot=new DrawPlot[] {
      new DrawPlot() {
        public void display() {
          pushStyle();
          for (int i=0; i<plot.length; i++)
            if (active[i]){
              stroke(colour[i].value);
              for (int j=0; j<=maxX-minX; j++)
                point(xStart+j*intervalX, yStart-intervalY*points[i].get(j));
            }
          popStyle();
        }
        public void display(int index){
          display(index, minX);
        }
        public void display(int index, int beginIndex) {
          if(active[index]) {
            pushStyle();
            stroke(colour[index].value);
            for (int i=0; i<points[index].size(); i++)
                point(xStart+(i+beginIndex-minX)*intervalX, yStart-intervalY*points[index].get(i));
            popStyle();
          }
        }
      },
      new DrawPlot() {
        public void display() {
          pushStyle();
          for (int i=0; i<plot.length; i++)
            if (active[i]) {
              stroke(colour[i].value);
              for (int j=0; j<maxX-minX; j++)
                line(xStart+j*intervalX, yStart-intervalY*points[i].get(j), xStart+(j+1)*intervalX, yStart-intervalY*points[i].get(j+1));
            }
          popStyle();
        }
        public void display(int index){
          display(index, minX);
        }
        public void display(int index, int beginIndex) {
          if(active[index]) {
            pushStyle();
            stroke(colour[index].value);
            for (int i=0; i<points[index].size()-1; i++)
              line(xStart+(i+beginIndex-minX)*intervalX, yStart-intervalY*points[index].get(i), xStart+(i+beginIndex-minX+1)*intervalX, yStart-intervalY*points[index].get(i+1));
            popStyle();
          }
        }
      }
    };
  }
  public void showScaleX(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=1; i<=(endIndex-beginIndex)/stepX; i++)
      line(x+i*gapX, y+gui.thisFont.gap(), x+i*gapX, y);
    strokeWeight(gui.unit(2));
    line(x, y, x+(endIndex-beginIndex+1)*intervalX, y);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepX; i++)
      text(i*stepX+beginIndex, x+i*gapX, y+gui.thisFont.stepY()+gui.thisFont.gap());
    popStyle();
  }
  public void showScaleY(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=1; i<=(endIndex-beginIndex)/stepY; i++)
      line(x, y-gapY*i, x-gui.thisFont.gap(), y-gapY*i);
    strokeWeight(gui.unit(2));
    line(x, y, x, y-(endIndex-beginIndex)*intervalY);
    fill(gui.bodyColor[0].value);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepY; i++)
      text(i*stepY+beginIndex, x-gui.thisFont.stepX(), y-gapY*i);
    popStyle();
  }
  public float getX() {
    return min(max(minX, (mouseX-xStart)/intervalX), maxX);
  }
  public float getX(float index) {
    return xStart+index*intervalX;
  }
  public float getY() {
    return min(max(minY, (yStart-mouseY)/intervalY), maxY);
  }
  public float getY(float index) {
    return yStart-index*intervalY;
  }
}
abstract class Plots extends Charts {
  Switcher showNode=new Switcher("Node", "Node"), showEdge=new Switcher("Edge", "Edge");
  Slider nodeWeight=new Slider("Node weight");
  public abstract void moreSettings();
  Plots() {
    switches.addLast(showNode);
    switches.addLast(showEdge);
    tunes.addFirst(nodeWeight);
  }
  public void setting() {
    nodeWeight.setPreference(gui.unit(6), gui.unit(), gui.unit(12), gui.unit(0.05f));
    edgeWeight.setPreference(gui.unit(2), gui.unit(0.1f), gui.unit(4), gui.unit(0.005f));
    moreSettings();
  }
  public void moreKeyReleases() {
    switch(Character.toLowerCase(key)) {
    case 'n':
      showNode.value=!showNode.value;
      break;
    case 'e':
      showEdge.value=!showEdge.value;
    }
  }
}
class PrimarySet extends IndependentSet {
  PrimarySet() {
    word=new String[11];
  }
  public void setColorPool() {
    colorPool=graph._PYColors;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Primary independent sets...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(14);
  }
}
abstract class Procedure {
  float centralX, centralY, centralZ, eyeX, eyeY, eyeZ, spinX, spinY, spinZ;
  String[] word;
  Slider nodeWeight=new Slider("Node weight"), interval=new Slider("Display interval", 1);
  Button[] button={new Button("Reset"), new Button("Restore"), new Button("Screenshot")};
  Switcher play=new Switcher("Stop", "Play"), spin=new Switcher("Spin", "Spin"), showNode=new Switcher("Node", "Node"), projection=new Switcher("Orthographic", "Perspective");
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  public abstract void data();
  public abstract void show();
  public abstract void restart();
  public abstract void deploying();
  Procedure() {
    switches.addLast(projection);
    switches.addLast(play);
    switches.addLast(spin);
    switches.addLast(showNode);
    tunes.addLast(interval);
    tunes.addLast(nodeWeight);
  }
  public void initialize() {
    play.value=navigation.auto;
    spin.value=graph.topology.value<4?false:true;
    nodeWeight.setPreference(gui.unit(0.005f), gui.unit(0.0005f), gui.unit(0.01f), gui.unit(0.00025f), gui.unit(1000));
  }
  public void display() {
    pushStyle();
    gui.body.initialize();
    data();
    controls();
    pushMatrix();
    camera(eyeX, eyeY, height*(float)graph.topology.yRange+eyeZ, centralX, centralY, centralZ, 0, 1, 0);
    scale(height);
    if (spin.value)
      spinY+=0.002f;
    rotateX(spinX);
    rotateY(spinY);
    rotateZ(spinZ);
    show();
    popMatrix();
    if (navigation.auto) {
      textAlign(CENTER);
      fill(gui.bodyColor[1].value);
      text("<<- Presentation mode: Ver. "+gui._V+" ->>", width/2, gui.thisFont.stepY());
    }
    navigation.display();
    popStyle();
    deploying();
  }
  public void controls() {
    fill(gui.headColor[1].value);
    text("Welcome to DragonZ-WSN world!", width-gui.margin(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Controls:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(2));
    for (int i=0; i<button.length; i++)
      button[i].display(GUI.WIDTH, width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(2)+gui.thisFont.gap(i+1)+button[0].buttonHeight*i, gui.margin()-gui.thisFont.stepX(3));
    fill(gui.headColor[2].value);
    text("Switches:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap()));
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+play.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+interval.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
    moreControls(gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+tunes.size()*interval.sliderHeight);
  }
  public void relocate() {
    spinX=spinY=spinZ=centralX=centralY=centralZ=eyeX=eyeY=eyeZ=0;
  }
  public void moreKeyPresses() {
  }
  public void moreKeyReleases() {
  }
  public void moreMousePresses() {
  }
  public void moreMouseReleases() {
  }
  public void moreControls(float y) {
  }
  public void displayNode(Vertex node) {
    if (projection.value)
      strokeWeight(nodeWeight.value+(modelZ((float)node.x, (float)node.y, (float)node.z)-modelZ(0, 0, 0))/height*nodeWeight.value);
    else
      strokeWeight(nodeWeight.value);
    point((float)node.x, (float)node.y, (float)node.z);
  }
  public void keyPress() {
    navigation.keyPress();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'a':
        eyeX-=40;
        break;
      case 'd':
        eyeX+=40;
        break;
      case 's':
        eyeZ+=10;
        break;
      case 'w':
        eyeZ-=10;
        break;
      case CODED:
        switch(keyCode) {
        case DOWN:
          eyeY-=10;
          centralY-=10;
          break;
        case UP:
          eyeY+=10;
          centralY+=10;
          break;
        case RIGHT:
          eyeX-=10;
          centralX-=10;
          break;
        case LEFT:
          eyeX+=10;
          centralX+=10;
        }
      }
      moreKeyPresses();
    }
  }
  public void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'p':
        play.value=!play.value;
        break;
      case 'r':
        restart();
        break;
      case 'x':
        capture.store();
        break;
      case 'g':
        relocate();
        break;
      case 'q':
        spin.value=!spin.value;
        break;
      case 'n':
        showNode.value=!showNode.value;
      }
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker part=i.next();
        if (key==PApplet.parseChar(i.previousIndex()+48))
          part.value=!part.value;
      }
      moreKeyReleases();
    }
  }
  public void keyType() {
  }
  public void mousePress() {
    navigation.mousePress();
    if (!navigation.active()) {
      nodeWeight.active();
      interval.active();
      moreMousePresses();
    }
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      projection.active();
      play.active();
      spin.active();
      showNode.active();
      for (Checker checker : parts)
        checker.active();
      if (button[0].active())
        restart();
      if (button[1].active())
        relocate();
      if (button[2].active())
        capture.store();
      moreMouseReleases();
    }
  }
  public void mouseDrag() {
    if (mouseButton==LEFT) {
      spinY+=(mouseX - pmouseX)*0.002f;
      spinX+=(pmouseY - mouseY)*0.002f;
    } else if (mouseButton==RIGHT) {
      eyeX-=mouseX-pmouseX;
      eyeY-=mouseY-pmouseY;
    }
  }
  public void mouseScroll(MouseEvent event) {
    eyeZ+=event.getCount()*10;
  }
}
class RLBipartite extends Bipartite {
  RLBipartite() {
    word=new String[13];
  }
  public void setComponent(int index) {
    graph.initailizeBackbones();
    component=graph.getBackbone(index-1);
    primary=component.primary;
    relay=component.relay;
    reset();
  }
  public int getAmount() {
    return graph._RLColors.size();
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(16);
  }
}
class RLPartite extends Partite {
  RLPartite() {
    word=new String[13];
  }
  public void setColorPool() {
    colorPool=graph._RLColors;
    boolean resetColors=false;
    for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++) {
      if (!resetColors&&graph._SLColors.get(i).deployed())
        resetColors=true;
      graph._SLColors.get(i).deploy=-1;
    }
    if (resetColors)
      for (Color colour : colorPool)
        colour.deploy=-1;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring partites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(16);
  }
}
class Radio {
  int value;
  float x, y, radioWidth, radioHeight, diameter, gap;
  LinkedList<String> labels=new LinkedList<String>();
  String maxLabel="";
  Radio(String...label) {
    for (String str : label) {
      labels.addLast(str);
      if (maxLabel.length()<str.length())
        maxLabel=str;
    }
  }
  public void setLabels(LinkedList<String> labels) {
    this.labels.clear();
    maxLabel="";
    for (String label : labels) {
      this.labels.addLast(label);
      if (maxLabel.length()<label.length())
        maxLabel=label;
    }
  }
  public boolean inCircle(int index) {
    return mouseX>x&&mouseY>y+(gap+diameter)*index&&mouseX<x+diameter&&mouseY<y+(gap+diameter)*(index+1);
  }
  public boolean active() {
    for (int i=0; i<labels.size(); i++)
      if (inCircle(i)) {
        value=i;
        return true;
      }
    return false;
  }
  public void display(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    diameter=gui.thisFont.stepY();
    radioWidth=textWidth(maxLabel)+diameter+gui.thisFont.stepX();
    radioHeight=gui.thisFont.stepY(labels.size())+gui.thisFont.gap(labels.size()-1);
    gap=gui.thisFont.gap();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    for (int i=0; i<labels.size(); i++) {
      if (inCircle(i))
        fill(gui.colour[2].value, 70);
      else
        noFill();
      circle(x+diameter/2, y+i*(diameter+gap)+diameter/2, diameter);
    }
    fill(gui.bodyColor[2].value);
    for (ListIterator<String> i=labels.listIterator(); i.hasNext(); )
      text(i.next(), x+diameter+gui.thisFont.stepX(), y+diameter*i.previousIndex()+diameter/2+gap*i.previousIndex());
    stroke(gui.mainColor.value);
    strokeWeight(diameter/3);
    point(x+diameter/2, y+(diameter+gap)*value+diameter/2);
    popStyle();
  }
}
class Region {
  int amount;
  PVector upVector=new PVector(0, 1, 0);
  public void display(int _N, Vertex vertex) {
    if (_N<=amount) {
      pushStyle();
      switch(graph.topology.value) {
      case 1:
      case 2:
      case 3:
        parallel(vertex);
        break;
      case 4:
        sphereTangency(vertex);
        break;
      case 5:
        torusTangency(vertex);
        break;
      case 6:
      case 7:
      case 8:
        space(vertex);
      }
      popStyle();
    }
  }
  public void sphereTangency(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    PVector node=new PVector((float)vertex.x, (float)vertex.y, (float)vertex.z);
    PVector axis=upVector.cross(node);
    pushMatrix();
    translate(node.x, node.y, node.z);
    rotate(PVector.angleBetween(upVector, node), axis.x, axis.y, axis.z);
    line(0, 0, 0, 0.05f);
    pushMatrix();
    rotateX(HALF_PI);
    circle(0, 0, (float)graph.r*2);
    popMatrix();
    popMatrix();
  }
  public void torusTangency(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    PVector origin=new PVector((float)vertex.x, (float)vertex.y, 0);
    origin.normalize();
    PVector node=new PVector((float)vertex.x, (float)vertex.y, (float)vertex.z);
    node.sub(origin);
    PVector axis=upVector.cross(node);
    pushMatrix();
    translate((float)vertex.x, (float)vertex.y, (float)vertex.z);
    rotate(PVector.angleBetween(upVector, node), axis.x, axis.y, axis.z);
    line(0, 0, 0, 0.05f);
    pushMatrix();
    rotateX(HALF_PI);
    circle(0, 0, (float)graph.r*2);
    popMatrix();
    popMatrix();
  }
  public void parallel(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    circle((float)vertex.x, (float)vertex.y, (float)graph.r*2);
  }
  public void space(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    sphereDetail(12);
    noFill();
    pushMatrix();
    translate((float)vertex.x, (float)vertex.y, (float)vertex.z);
    sphere((float)graph.r);
    popMatrix();
  }
}
class RelayColoring extends Procedure implements Screen {
  int connection, _N, _E;
  boolean[] slot;
  Slider connectivity=new Slider("Connectivity", 2, 1), edgeWeight=new Slider("Edge weight");
  Switcher showEdge=new Switcher("Edge", "Edge");
  Checker surplus=new Checker("Surplus"), coloredGraph=new Checker("Colored graph"), uncoloredGraph=new Checker("Uncolored graph"), primaryGraph=new Checker("Primary graph");
  RelayColoring() {
    parts.addLast(coloredGraph);
    parts.addLast(uncoloredGraph);
    parts.addLast(surplus);
    parts.addLast(primaryGraph);
    word=new String[11];
    tunes.addLast(edgeWeight);
    tunes.addLast(connectivity);
    switches.addLast(showEdge);
  }
  public void setting() {
    initialize();
    surplus.value=primaryGraph.value=uncoloredGraph.value=showEdge.value=false;
    coloredGraph.value=true;
    edgeWeight.setPreference(gui.unit(0.0002f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    if (navigation.end==5) {
      if (slot==null||slot.length<graph._PYColors.size())
        slot=new boolean[graph._PYColors.size()];
      if (graph._RLColors.isEmpty()) {
        interval.setPreference(ceil((graph.vertex.length-graph.primaries)*7.0f/3200), ceil((graph.vertex.length-graph.primaries)/3.0f), ceil((graph.vertex.length-graph.primaries)*7.0f/3200));
        connectivity.setPreference(graph.connectivity, graph.topology.connectivity());
        reset();
      } else
        restart();
    }
  }
  public void restart() {
    for (Component component : graph.backbone)
      component.archive=-1;
    for (Color colour : graph._RLColors)
      colour.clean();
    graph._RLColors.clear();
    for (LinkedList<Vertex> list : graph.relayList) {
      for (Vertex node : list)
        node.clearColor(null);//clear relay colors
      list.clear();
    }
    reset();
  }
  public void reset() {
    navigation.end=-6;
    connection=graph.relayList.length;
    graph.generateRelayList(2);
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&connection<connectivity.value) {
        if (navigation.end==-6)
          navigation.end=6;
        if (navigation.auto)
          navigation.go(403);
        play.value=false;
      }
      if (play.value)
        connection=graph.colour(slot, connection);
    }
  }
  public void show() {
    _N=_E=0;
    if (primaryGraph.value)
      for (Color colour : graph._PYColors)
        for (Vertex nodeA : colour.vertices) {
          if (showEdge.value) {
            stroke(gui.partColor[1].value);
            displayEdge(nodeA);
          }
          displayNode(nodeA, colour);
        }
    for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++)
      for (Vertex nodeA : graph._SLColors.get(i).vertices) {
        if (surplus.value&&nodeA.order[1]==-5) {
          stroke(gui.mainColor.value);
          if (showEdge.value)
            displayEdge(nodeA);
          if (showNode.value) {
            _N++;
            displayNode(nodeA);
          }
        }
        if (coloredGraph.value&&nodeA.relayColor!=null) {
          if (showEdge.value) {
            stroke(gui.partColor[2].value);
            displayEdge(nodeA);
          }
          displayNode(nodeA, nodeA.relayColor);
        }
        if (uncoloredGraph.value&&nodeA.order[1]==-6&&nodeA.relayColor==null) {
          stroke(gui.partColor[0].value);
          if (showEdge.value)
            displayEdge(nodeA);
          if (showNode.value) {
            _N++;
            displayNode(nodeA);
          }
        }
      }
  }
  public void displayNode(Vertex node, Color colour) {
    if (showNode.value) {
      _N++;
      stroke(colour.value);
      displayNode(node);
    }
  }
  public void displayEdge(Vertex nodeA) {
    strokeWeight(edgeWeight.value);
    for (Vertex nodeB : nodeA.neighbors)
      if (nodeA.value>nodeB.value)
        if (nodeB.primeColor.index<graph._PYColors.size()) {
          if (primaryGraph.value) {
            _E++;
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
        } else {
          if (coloredGraph.value&&nodeB.relayColor!=null||surplus.value&&nodeB.order[1]==-5||uncoloredGraph.value&&nodeB.order[1]==-6&&nodeB.relayColor==null) {
            _E++;
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
        }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(14));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int surplusOrder=graph.surplus();
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0f/_N);
    word[3]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[4]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    for (int i=0; i<5; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(15+i));
  }
  public void moreMousePresses() {
    edgeWeight.active();
    if (connectivity.active()&&round(connectivity.value)!=graph.connectivity) {
      if (connection<connectivity.value) {
        graph.connectivity=round(connectivity.value);
        restart();
      } else {
        graph.backbone=null;
        for (int i=graph.connectivity-1; i<connectivity.value-1; i++)
          for (Vertex node : graph.relayList[i])
            node.order[1]=-5;
        for (int i=round(connectivity.value)-1; i<graph.connectivity-1; i++)
          for (Vertex node : graph.relayList[i])
            node.order[1]=-6;
        graph.connectivity=round(connectivity.value);
      }
    }
  }
  public void moreMouseReleases() {
    showEdge.active();
  }
  public void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
}
class RelaySet extends IndependentSet {
  RelaySet() {
    word=new String[13];
  }
  public void setColorPool() {
    colorPool=graph._RLColors;
    boolean resetColors=false;
    for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++) {
      if (!resetColors&&graph._SLColors.get(i).deployed())
        resetColors=true;
      graph._SLColors.get(i).deploy=-1;
    }
    if (resetColors)
      for (Color colour : colorPool)
        colour.deploy=-1;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Relay independent sets...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(16);
  }
}
abstract class Result {
  float centralX, centralY, centralZ, eyeX, eyeY, eyeZ, spinX, spinY, spinZ;
  String[] word;
  Slider nodeWeight=new Slider("Node weight"), edgeWeight=new Slider("Edge weight");
  Button[] button={new Button("Restore"), new Button("Screenshot")};
  Switcher spin=new Switcher("Spin", "Spin"), showNode=new Switcher("Node", "Node"), showEdge=new Switcher("Edge", "Edge"), projection=new Switcher("Orthographic", "Perspective");
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  public abstract void data();
  public abstract void show();
  Result() {
    switches.addLast(projection);
    switches.addLast(spin);
    switches.addLast(showNode);
    switches.addLast(showEdge);
    tunes.addLast(nodeWeight);
    tunes.addLast(edgeWeight);
  }
  public void initialize() {
    spin.value=graph.topology.value<4?false:true;
    nodeWeight.setPreference(gui.unit(0.005f), gui.unit(0.0005f), gui.unit(0.01f), gui.unit(0.00025f), gui.unit(1000));
    edgeWeight.setPreference(gui.unit(0.0002f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
  }
  public void display() {
    pushStyle();
    gui.body.initialize();
    data();
    controls();
    pushMatrix();
    camera(eyeX, eyeY, height*(float)graph.topology.yRange+eyeZ, centralX, centralY, centralZ, 0, 1, 0);
    scale(height);
    if (spin.value)
      spinY+=0.002f;
    rotateX(spinX);
    rotateY(spinY);
    rotateZ(spinZ);
    show();
    popMatrix();
    navigation.display();
    popStyle();
  }
  public void controls() {
    fill(gui.headColor[1].value);
    text("Welcome to DragonZ-WSN world!", width-gui.margin(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Controls:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(2));
    for (int i=0; i<button.length; i++)
      button[i].display(GUI.WIDTH, width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(2)+gui.thisFont.gap(i+1)+button[0].buttonHeight*i, gui.margin()-gui.thisFont.stepX(3));
    fill(gui.headColor[2].value);
    text("Switches:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap()));
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+spin.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+nodeWeight.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
    moreControls(gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+tunes.size()*nodeWeight.sliderHeight);
  }
  public void relocate() {
    spinX=spinY=spinZ=centralX=centralY=centralZ=eyeX=eyeY=eyeZ=0;
  }
  public void moreKeyPresses() {
  }
  public void moreKeyReleases() {
  }
  public void moreMousePresses() {
  }
  public void moreMouseReleases() {
  }
  public void moreControls(float y) {
  }
  public void displayNode(Vertex node) {
    if (projection.value)
      strokeWeight(nodeWeight.value+(modelZ((float)node.x, (float)node.y, (float)node.z)-modelZ(0, 0, 0))/height*nodeWeight.value);
    else
      strokeWeight(nodeWeight.value);
    point((float)node.x, (float)node.y, (float)node.z);
  }
  public void keyPress() {
    navigation.keyPress();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'a':
        eyeX-=40;
        break;
      case 'd':
        eyeX+=40;
        break;
      case 's':
        eyeZ+=10;
        break;
      case 'w':
        eyeZ-=10;
        break;
      case CODED:
        switch(keyCode) {
        case DOWN:
          eyeY-=10;
          centralY-=10;
          break;
        case UP:
          eyeY+=10;
          centralY+=10;
          break;
        case RIGHT:
          eyeX-=10;
          centralX-=10;
          break;
        case LEFT:
          eyeX+=10;
          centralX+=10;
        }
      }
      moreKeyPresses();
    }
  }
  public void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'e':
        showEdge.value=!showEdge.value;
        break;
      case 'x':
        capture.store();
        break;
      case 'g':
        relocate();
        break;
      case 'q':
        spin.value=!spin.value;
        break;
      case 'n':
        showNode.value=!showNode.value;
      }
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker part=i.next();
        if (key==PApplet.parseChar(i.previousIndex()+48))
          part.value=!part.value;
      }
      moreKeyReleases();
    }
  }
  public void keyType() {
  }
  public void mousePress() {
    navigation.mousePress();
    if (!navigation.active()) {
      nodeWeight.active();
      edgeWeight.active();
      moreMousePresses();
    }
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      projection.active();
      spin.active();
      showNode.active();
      showEdge.active();
      for (Checker checker : parts)
        checker.active();
      if (button[0].active())
        relocate();
      if (button[1].active())
        capture.store();
      moreMouseReleases();
    }
  }
  public void mouseDrag() {
    if (mouseButton==LEFT) {
      spinY+=(mouseX - pmouseX)*0.002f;
      spinX+=(pmouseY - mouseY)*0.002f;
    } else if (mouseButton==RIGHT) {
      eyeX-=mouseX-pmouseX;
      eyeY-=mouseY-pmouseY;
    }
  }
  public void mouseScroll(MouseEvent event) {
    eyeZ+=event.getCount()*10;
  }
}
class Rocket extends Star {
  Firework firework;
  boolean explode=true;
  Rocket() {
    x=mouseX;
    y=height;
    destination=mouseY;
    colour=color(random(120, 255), random(120, 255), random(120, 255));
  }
  public void update() {
    if (firework!=null)
      firework.display();
    if (explode&&y<destination) {
      firework=new Firework(x, y, colour);
      explode=false;
    } else
      y-=3;
  }
}
class SLBipartite extends Bipartite {
  SLBipartite() {
    word=new String[10];
  }
  public int getAmount() {
    int size=graph._SLColors.size();
    return size*(size-1)/2;
  }
  public void setComponent(int index) {
    int size=graph._SLColors.size();
    if (size<2)
      primary=relay=gui.mainColor;
    else {
      int sum=--size, primaryIndex=0, relayIndex;
      while (sum<index) {
        sum+=--size;
        primaryIndex++;
      }
      for (sum=sum-size, relayIndex=primaryIndex; sum<index; sum++, relayIndex++);
      primary=graph._SLColors.get(primaryIndex);
      relay=graph._SLColors.get(relayIndex);
    }
    if (component==null)
      component=new Component(primary, relay);
    else
      component.reset(primary, relay);
    reset();
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique order: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(13);
  }
}
class SLPartite extends Partite {
  SLPartite() {
    word=new String[11];
  }
  public void setColorPool() {
    colorPool=graph._SLColors;
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring partites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<10; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(13);
  }
}
class Scene implements Screen {
  int time;
  Image image=new Image("Scene.png");
  String[] title={
    "New Graph...", 
    "Node Distributing...", "Graph Generating...", "Smallest-last Ordering...", "Smallest-last Coloring...", "Partitioning...", "Relay Coloring...", "Smallest-last Coloring Partites...", "Relay Coloring Partites...", "Smallest-last Coloring Bipartites...", "Relay Coloring Bipartites...", 
    "Terminal Clique...", "Primary Independent Sets...", "Relay Independent Sets...", "Backbones...", "Surplus...", 
    "Degree Distribution Histogram...", 
    "Vertex Degree Plot...", "Color-size Plot...", 
    "New computation...", "New demonstration...", 
    "Color settings...", "System settings...", "Font settings...", 
    "About..."
  };
  public void setting() {
    time=millis();
  }
  public void display() {
    pushStyle();
    image.display(width>height?GUI.WIDTH:GUI.HEIGHT, 0, 0, max(width, height));
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text(title[navigation.nextPage], gui.thisFont.stepX(), height-gui.thisFont.stepY());
    popStyle();
    if (millis()-time>1000)
      navigation.page=navigation.nextPage;
  }
  public void keyPress() {
  }
  public void keyType() {
  }
  public void keyRelease() {
  }
  public void mousePress() {
  }
  public void mouseRelease() {
  }
  public void mouseDrag() {
  }
  public void mouseScroll(MouseEvent event) {
  }
}
interface Screen {
  public void setting();
  public void display();
  public void keyPress();
  public void keyRelease();
  public void keyType();
  public void mousePress();
  public void mouseRelease();
  public void mouseDrag();
  public void mouseScroll(MouseEvent event);
}
abstract class Setting {
  Image box=new Image("Box.png");
  String label;
  Animation video;
  public abstract void initialize();
  public abstract void moreMousePresses();
  public abstract void moreMouseReleases();
  public abstract void moreKeyReleases();
  public void moreKeyPresses() {
  }
  public abstract void show(float x, float y, float panelWidth, float panelHeight);
  public void setting() {
    video.repeat();
    initialize();
  }
  public void display() {
    pushStyle();
    box.display(GUI.WIDTH, width/2, height-box.imageHeight, width/2);
    gui.head.initialize();
    fill(gui.headColor[0].value);
    text(label, gui.thisFont.stepX(), gui.thisFont.stepY());
    gui.body.initialize();
    video.display(GUI.WIDTH, width/2, height/6, width/2-width/12);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    noFill();
    rect(width/12, height/6, width/3, height*2/3, gui.unit(10));
    show(width/12, height/6, width/3, height*2/3);
    navigation.display();
    popStyle();
  }
  public void keyPress() {
    navigation.keyPress();
    if (!navigation.active())
      moreKeyPresses();
  }
  public void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active())
      moreKeyReleases();
  }
  public void keyType() {
  }
  public void mousePress() {
    navigation.mousePress();
    if (!navigation.active())
      moreMousePresses();
  }
  public void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active())
      moreMouseReleases();
  }
  public void mouseDrag() {
  }
  public void mouseScroll(MouseEvent event) {
  }
}
class Slider {
  float x, y, sliderLeft, sliderRight, sliderTop, sliderBottom, buttonLeft, buttonRight, min, max, value, step, scale=1, sliderWidth, sliderHeight;
  String label;
  Slider(String label) {
    this.label=label;
  }
  Slider(String label, float min) {
    this.label=label;
    this.min=min;
  }
  Slider(String label, float min, float step) {
    this.label=label;
    this.min=min;
    this.step=step;
  }
  Slider(String label, float min, float max, float step) {
    this.min=min;
    this.max=max;
    this.step=step;
    this.label=label;
  }
  Slider(String label, float value, float min, float max, float step) {
    this.min=min;
    this.max=max;
    this.value=constrain(value, min, max);
    this.step=step;
    this.label=label;
  }
  public boolean active() {
    if (inRange()) {
      if (mouseX<buttonRight) {
        decreaseValue();
        return true;
      }
      if (mouseX>buttonLeft) {
        increaseValue();
        return true;
      }
      if (mouseX>sliderLeft&&mouseX<sliderRight) {
        value=min+(mouseX-sliderLeft)*(max-min)/(sliderRight-sliderLeft);
        if (step%1==0)
          value=round(value);
        return true;
      }
    }
    return false;
  }
  public void increaseValue() {
    value=constrain(value+step, min, max);
  }
  public void decreaseValue() {
    value=constrain(value-step, min, max);
  }
  public boolean inRange() {
    return mouseX>x&&mouseX<x+sliderWidth&&mouseY>sliderTop&&mouseY<sliderBottom;
  }
  public void setValue(float value) {
    this.value=constrain(value, min, max);
  }
  public void setMax(float max) {
    this.max=max(min, max);
  }
  public void setPreference(float value, float max) {
    this.max=max(min, max);
    this.value=constrain(value, min, max);
  }
  public void setPreference(float value, float max, float step) {
    this.max=max(min, max);
    this.value=constrain(value, min, max);
    this.step=step;
  }
  public void setPreference(float value, float min, float max, float step) {
    this.min=min;
    this.max=max(min, max);
    this.value=constrain(value, min, max);
    this.step=step;
  }
  public void setPreference(float value, float min, float max, float step, float scale) {
    this.min=min;
    this.max=max(min, max);
    this.value=constrain(value, min, max);
    this.step=step;
    this.scale=scale;
  }
  public void display(float x, float y, float sliderWidth) {
    pushStyle();
    textAlign(LEFT);
    rectMode(CORNER);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.sliderWidth=sliderWidth;
    sliderHeight=gui.thisFont.stepY(2)+gui.thisFont.gap();
    buttonRight=this.x+gui.thisFont.stepY();
    sliderLeft=buttonRight+gui.thisFont.stepX();
    buttonLeft=this.x+sliderWidth-gui.thisFont.stepY();
    sliderRight=buttonLeft-gui.thisFont.stepX();
    sliderTop=this.y+gui.thisFont.stepY()+gui.thisFont.gap();
    sliderBottom=this.y+sliderHeight;
    fill(gui.bodyColor[0].value);
    text(String.format("%s: %.3f", label, value*scale), x, y+gui.thisFont.stepY());
    if (inRange()) {
      if (mouseX<buttonRight) {
        noStroke();
        if (mousePressed)
          fill(gui.mainColor.value);
        else
          fill(gui.colour[2].value, 70);
        triangle(x, y+sliderHeight-gui.thisFont.stepY(0.5f), x+gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY()+gui.unit(4), x+gui.thisFont.stepY(), y+sliderHeight-gui.unit(4));
      }
      if (mouseX>buttonLeft) {
        noStroke();
        if (mousePressed)
          fill(gui.mainColor.value);
        else
          fill(gui.colour[2].value, 70);
        triangle(x+sliderWidth, y+sliderHeight-gui.thisFont.stepY(0.5f), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY()+gui.unit(4), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight-gui.unit(4));
      }
    }
    stroke(gui.mainColor.value);
    strokeWeight(gui.unit(2));
    float position=(value-min)*(sliderRight-sliderLeft)/(max-min);
    line(x+gui.thisFont.stepX()+gui.thisFont.stepY(), y+gui.thisFont.stepY(1.5f)+gui.thisFont.gap(), x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+gui.thisFont.stepY(1.5f)+gui.thisFont.gap());
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    line(x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+sliderHeight-gui.thisFont.stepY()+gui.unit(), x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+sliderHeight-gui.unit());
    noFill();
    rect(x+gui.thisFont.stepX()+gui.thisFont.stepY(), y+gui.thisFont.stepY(1.25f)+gui.thisFont.gap(), sliderRight-sliderLeft, gui.thisFont.stepY(0.5f), gui.unit(3));
    triangle(x, y+sliderHeight-gui.thisFont.stepY(0.5f), x+gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+gui.thisFont.stepY(), y+sliderHeight);
    triangle(x+sliderWidth, y+sliderHeight-gui.thisFont.stepY(0.5f), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight);
    popStyle();
  }
}
class SmallestLastColoring extends Procedure implements Screen {
  int _N, _E;
  boolean[] slot;
  Switcher showEdge=new Switcher("Edge", "Edge"), showMeasurement=new Switcher("Measurement", "Measurement");
  Checker uncoloredGraph=new Checker("Uncolored graph"), coloredGraph=new Checker("Colored graph");
  Slider edgeWeight=new Slider("Edge weight");
  Vertex nodeM=new Vertex();
  SmallestLastColoring() {
    word=new String[9];
    parts.addLast(uncoloredGraph);
    parts.addLast(coloredGraph);
    tunes.addLast(edgeWeight);
    switches.addLast(showEdge);
    switches.addLast(showMeasurement);
    showMeasurement.value=uncoloredGraph.value=showEdge.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.0002f), gui.unit(0.000025f), gui.unit(0.002f), gui.unit(0.00025f), gui.unit(1000));
    if (navigation.end==3) {
      navigation.end=-4;
      _N=0;
      if (graph._SLColors.isEmpty()) {
        interval.setPreference(ceil(graph.vertex.length*7.0f/3200), ceil(graph.vertex.length/3.0f), ceil(graph.vertex.length*7.0f/3200));
        if (slot==null||slot.length<=graph.maxMinDegree)
          slot=new boolean[graph.maxMinDegree+1];
      } else {
        for (Color colour : graph._SLColors)
          colour.clean();
        graph._SLColors.clear();
      }
    }
  }
  public void restart() {
    _N=0;
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==graph.vertex.length) {
        if (navigation.end==-4)
          navigation.end=4;
        if (navigation.auto)
          navigation.go(406);
        play.value=false;
      }
      if (play.value) {
        if (graph.vertex[_N].primeColor==null)
          graph.colour(_N, slot);
        _N++;
      }
    }
  }
  public void show() {
    _E=0;
    if (showMeasurement.value&&showEdge.value) {
      strokeWeight(edgeWeight.value);
      for (int i=0; i<_N; i++)
        for (Vertex nodeB : graph.vertex[i].neighbors)
          if (graph.vertex[i].value>nodeB.value&&nodeB.value<_N) {
            _E++;
            nodeM.setCoordinates((graph.vertex[i].x+nodeB.x)/2, (graph.vertex[i].y+nodeB.y)/2, (graph.vertex[i].z+nodeB.z)/2);
            stroke(gui.partColor[graph.vertex[i].value<nodeB.value?1:2].value);
            line((float)graph.vertex[i].x, (float)graph.vertex[i].y, (float)graph.vertex[i].z, (float)nodeM.x, (float)nodeM.y, (float)nodeM.z);
            stroke(gui.partColor[graph.vertex[i].value<nodeB.value?2:1].value);
            line((float)nodeM.x, (float)nodeM.y, (float)nodeM.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
    }
    if (uncoloredGraph.value) {
      stroke(gui.partColor[0].value);
      for (int i=_N; i<graph.vertex.length; i++) {
        Vertex nodeA=graph.vertex[i];
        if (!showMeasurement.value&&showEdge.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeB.value<_N&&coloredGraph.value||nodeA.value>nodeB.value&&nodeB.value>=_N) {
              _E++;
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        }
        if (showNode.value)
          displayNode(nodeA);
      }
    }
    if (coloredGraph.value)
      for (int i=0; i<_N; i++) {
        Vertex nodeA=graph.vertex[i];
        if (!showMeasurement.value&&showEdge.value) {
          stroke(gui.mainColor.value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeA.value>nodeB.value&&nodeB.value<_N) {
              _E++;
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        }
        if (showNode.value) {
          stroke(nodeA.primeColor.value);
          displayNode(nodeA);
        }
      }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(12));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int vertices=0;
    if (showNode.value) {
      if (coloredGraph.value)
        vertices=_N;
      if (uncoloredGraph.value)
        vertices+=graph.vertex.length-_N;
    }
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0f/vertices);
    word[3]="Colors: "+graph._SLColors.size();
    word[4]=String.format("Complete: %.2f %%", _N*100.0f/graph.vertex.length);
    for (int i=0; i<5; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(13+i));
  }
  public void moreMousePresses() {
    edgeWeight.active();
  }
  public void moreMouseReleases() {
    showMeasurement.active();
    showEdge.active();
  }
  public void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 'm':
      showMeasurement.value=!showMeasurement.value;
    }
  }
}
class SmallestLastOrdering extends Procedure implements Screen {
  Slider edgeWeight=new Slider("Edge weight");
  Switcher showMeasurement=new Switcher("Measurement", "Measurement"), showEdge=new Switcher("Edge", "Edge");
  Checker deletedGraph=new Checker("Deleted graph"), remainingGraph=new Checker("Remaning graph");
  int[] degree=new int[2];//degree/2, degree;
  int _N, _E;
  Vertex[] degreeList=new Vertex[2];
  SmallestLastOrdering() {
    word=new String[7];
    parts.addLast(deletedGraph);
    parts.addLast(remainingGraph);
    switches.addLast(showEdge);
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
    deletedGraph.value=false;
  }
  public void setting() {
    initialize();
    edgeWeight.setPreference(gui.unit(0.0005f), gui.unit(0.00002f), gui.unit(0.002f), gui.unit(0.0005f), gui.unit(1000));
    if (graph.degreeList.isEmpty()) {
      interval.setPreference(ceil(graph.vertex.length*7.0f/3200), ceil(graph.vertex.length/3.0f), ceil(graph.vertex.length*7.0f/3200));
      graph.generateDegreeList();
      reset();
    } else if (navigation.end==2)
      restart();
  }
  public void restart() {
    graph.clique.clear();
    graph.maxMinDegree=0;
    for (Vertex list : graph.degreeList)
      list.clean();
    for (Vertex node : graph.vertex) {
      node.degree=node.neighbors.size();
      graph.degreeList.get(node.degree).push(node);
    }
    reset();
  }
  public void reset() {
    navigation.end=-3;
    degreeList[0]=graph.degreeList.get(graph.minDegree);
    degreeList[1]=graph.degreeList.get(graph.maxDegree);
    _N=graph.vertex.length;
    degree[0]=graph._E;
    degree[1]=degree[0]*2;
  }
  public void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==0) {
        if (navigation.end==-3)
          navigation.end=3;
        if (navigation.auto)
          navigation.go(407);
        play.value=false;
      }
      if (play.value) {
        graph.order(_N, degree, degreeList);
        _N--;
      }
    }
  }
  public void highlight(Vertex list, SysColor colour) {
    stroke(colour.value);
    for (Vertex nodeA=list.next; nodeA!=null; nodeA=nodeA.next) {
      if (showEdge.value) {
        strokeWeight(edgeWeight.value);
        for (Vertex nodeB : nodeA.neighbors)
          if (nodeB.value<_N)
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
      }
      if (showNode.value)
        displayNode(nodeA);
    }
  }
  public void show() {
    if (remainingGraph.value) {
      stroke(gui.mainColor.value); 
      for (int i=0; i<_N; i++) {
        Vertex nodeA=graph.vertex[i]; 
        if (showEdge.value&&!showMeasurement.value) {
          strokeWeight(edgeWeight.value); 
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeB.value<_N&&nodeA.value<nodeB.value)
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
        if (showNode.value)
          displayNode(nodeA);
      }
    }
    if (deletedGraph.value) {
      stroke(gui.partColor[0].value);
      _E=0;
      for (int i=_N; i<graph.vertex.length; i++) {
        Vertex nodeA=graph.vertex[i]; 
        if (showEdge.value&&!showMeasurement.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeB.value<_N) {
              if (remainingGraph.value)
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            } else if (nodeA.value<nodeB.value) {
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              ++_E;
            }
        }
        if (showNode.value)
          displayNode(nodeA);
      }
    }
    if (showMeasurement.value) {
      highlight(degreeList[1], gui.partColor[1]);
      highlight(degreeList[0], gui.partColor[2]);
    }
  }
  public void data() {
    fill(gui.headColor[1].value); 
    text("Smallest-last ordering...", gui.thisFont.stepX(), gui.thisFont.stepY()); 
    fill(gui.headColor[2].value); 
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(10)); 
    word[0]="Topology: "+graph.topology; 
    word[1]="N: "+graph.vertex.length; 
    word[2]=String.format("r: %.3f", graph.r); 
    word[3]="E: "+graph._E; 
    word[4]="Deg(Max.): "+graph.maxDegree; 
    word[5]="Deg(Min.): "+graph.minDegree; 
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length); 
    fill(gui.bodyColor[0].value); 
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int edges=0, vertices=0; 
    if (showNode.value) {
      if (remainingGraph.value)
        vertices=_N;
      else if (showMeasurement.value)
        vertices=degreeList[0].value+degreeList[1].value;
      if (deletedGraph.value)
        vertices+=graph.vertex.length-_N;
    }
    if (showEdge.value)
      if (showMeasurement.value)
        edges=degreeList[1].value*degreeList[1].degree+degreeList[0].value*degreeList[0].degree; 
      else if (deletedGraph.value&&remainingGraph.value)
        edges=graph._E;
      else if (remainingGraph.value)
        edges=degree[0];
      else if (deletedGraph.value)
        edges=_E;
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", edges, edges*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", edges*2.0f/vertices); 
    word[3]="Terminal clique size: "+graph.clique.size();
    word[4]="Maximum min-degree: "+graph.maxMinDegree;
    word[5]=String.format("Complete: %.2f%%", (1-_N*1.0f/graph.vertex.length)*100); 
    for (int i=0; i<6; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(11+i));
    if (showMeasurement.value) {
      fill(gui.partColor[1].value); 
      text("Max. degree: "+degreeList[1].degree+" ("+degreeList[1].value+(degreeList[1].value<2?" vertex)":" vertices)"), gui.thisFont.stepX(3), gui.thisFont.stepY(17)); 
      fill(gui.partColor[2].value);
      text("Min. degree: "+degreeList[0].degree+" ("+degreeList[0].value+(degreeList[0].value<2?" vertex)":" vertices)"), gui.thisFont.stepX(3), gui.thisFont.stepY(18));
    }
  }
  public void moreMousePresses() {
    edgeWeight.active();
  }
  public void moreMouseReleases() {
    showMeasurement.active();
    showEdge.active();
  }
  public void moreKeyReleases() {
    switch(Character.toLowerCase(key)) {
    case 'e' : 
      showEdge.value=!showEdge.value; 
      break; 
    case 'm' : 
      showMeasurement.value=!showMeasurement.value;
    }
  }
}
class Sphere extends Topology {
  Sphere() {
    value=4;
    range=xRange=yRange=zRange=2;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=range*Math.sqrt((avg+1)/n);
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public String toString() {
    return "Sphere";
  }
  public Vertex generateVertex(int index) {
    return new Vertex(range/2, Math.acos(2*rnd.nextDouble()-1), 2*Math.PI*rnd.nextDouble(), index, connectivity());
  }
}
class SphericalCell extends CircularCell {
  int[] theta=new int[2], phi=new int[2];
  ListIterator<Vertex>[] i=new ListIterator[2];
  int thetaN=(int)Math.floor(Math.PI/(4*Math.asin(graph.r/graph.topology.range)));
  SphericalCell() {
    if (thetaN==0)
      thetaN=1;
    ring=new ArrayList[2][thetaN];
    for (int category=0; category!=2; category++) {
      ring[category][0]=new ArrayList<LinkedList<Vertex>>();
      ring[category][0].add(new LinkedList<Vertex>());
    }
    double alpha=Math.PI/(2*thetaN);
    if (thetaN>1) {
      int size=(int)Math.floor(Math.PI/Math.asin(graph.r/(graph.topology.range*Math.sin(alpha))));
      double beta=2*Math.PI/size;
      for (int a=1; a<thetaN; a++) {
        if (graph.topology.range*Math.sin(a*alpha)*Math.sin(beta/2)>2*graph.r) {
          size*=2;
          beta=2*Math.PI/size;
        }
        for (int category=0; category<2; category++) {
          ring[category][a]=new ArrayList<LinkedList<Vertex>>();
          for (int b=0; b<size; b++)
            ring[category][a].add(new LinkedList<Vertex>());
        }
      }
    }
    for (Vertex node : graph.vertex) {
      int category=node.theta<Math.PI/2?0:1, index=(int)Math.floor((node.theta<Math.PI/2?node.theta:(Math.PI-node.theta))/alpha);
      if (index==thetaN)
        index--;
      ring[category][index].get((int)Math.floor(node.phi*ring[category][index].size()/(2*Math.PI))).addLast(node);
    }
  }
  public void initialize() {
    for (int category=0; category<2; category++) {
      theta[category]=phi[category]=0;
      i[category]=ring[category][0].get(0).listIterator();
    }
  }
  public boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    for (int category=0; category!=2; category++)
      if (i[category].hasNext())
        checkHemisphere(category, theta[category], phi[category], i[category], ring[category][theta[category]].get(phi[category]));
      else if (theta[category]<thetaN&&++phi[category]<ring[category][theta[category]].size())
        i[category]=ring[category][theta[category]].get(phi[category]).listIterator();
      else if (++theta[category]<thetaN) {
        phi[category]=0;
        i[category]=ring[category][theta[category]].get(0).listIterator();
      }
    return true;
  }
  public void checkHemisphere(int category, int theta, int phi, ListIterator<Vertex> i, LinkedList<Vertex> cell) {
    Vertex nodeA=i.next();
    nodeA.lowpoint=0;
    count++;
    for (ListIterator<Vertex> j=cell.listIterator(i.nextIndex()); j.hasNext(); )
      link(nodeA, j.next());
    if (theta>0)
      for (Vertex nodeB : ring[category][theta].get(mod(phi+1, ring[category][theta].size())))
        link(nodeA, nodeB);
    if (theta+1<thetaN) {
      if (theta==0)
        for (LinkedList<Vertex> list : ring[category][1])
          for (Vertex nodeB : list)
            link(nodeA, nodeB);
      else {
        int index, number;
        if (ring[category][theta].size()<ring[category][theta+1].size()) {
          index=phi*2;
          number=4;
        } else {
          index=phi;
          number=3;
        }
        checkNeighbors(nodeA, category, theta+1, index, number);
      }
    } else if (category==0) {
      if (thetaN==1)
        for (Vertex nodeB : ring[1][0].get(0))
          link(nodeA, nodeB);
      else
        checkNeighbors(nodeA, 1, theta, phi, 3);
    }
  }
}
class Square extends Topology {
  Square() {
    xRange=yRange=value=1;
    range=Math.sqrt(2);
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt((avg+1)*xRange*yRange/(n*Math.PI));
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=n*Math.PI*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public String toString() {
    return "Square";
  }
  public Vertex generateVertex(int index) {
    return new Vertex(index, rnd.nextDouble()*xRange-xRange/2, rnd.nextDouble()*yRange-yRange/2, zRange, connectivity());
  }
}
abstract class Star {
  float x, y, destination;
  float[] radius={gui.unit(random(5)), gui.unit(random(5, 10))};
  int points=round(random(3, 6));
  int colour;
  public abstract void update();
  public void display() {
    noStroke();
    fill(colour); 
    star(x, y, radius);
    update();
  }
  public void star(float x, float y, float[] radius) {
    float angle = TWO_PI / points;
    float halfAngle = angle/2.0f;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius[1];
      float sy = y + sin(a) * radius[1];
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius[0];
      sy = y + sin(a+halfAngle) * radius[0];
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
class Stem extends Tree {
  Stem(float x, float y, float angleOffset, float tall) {
    super(x, y, tall);
    angle=angleOffset;//PI
    this.angleOffset = random(-PI/12, PI/12);
    branch=new Branch[2];
    birth();
  }
  public void display() {
    pushStyle();
    windForce=sin(windAngle+=0.05f)*0.02f;
    if (growth<1)
      growth+=0.02f;
    show();
    popStyle();
  }
  public void drawBranch() {
    float xB=x+sin(angle+angleOffset)*gui.unit(tall)*0.3f, yB=y+cos(angle+angleOffset)*gui.unit(tall)*0.3f;
    stroke(floor(2000/tall));
    strokeWeight(gui.unit(tall/5));
    noFill();
    Tree b=branch[0]==null?branch[1]:branch[0];
    bezier(x, y, xB, yB, xB, yB, b.x, b.y);
    for (int i=0; i!=2; i++)
      if (branch[i]!=null)
        branch[i].display();
  }
}
class Surplus extends Result implements Screen {
  Checker surplus=new Checker("Surplus"), minorComponents=new Checker("+Minor components"), tails=new Checker("+Tails"), minorBlocks=new Checker("+Minor blocks"), giantBlocks=new Checker("+Giant blocks");
  int _N, _E;
  Surplus() {
    word=new String[13];
    parts.addLast(giantBlocks);
    parts.addLast(surplus);
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
    showEdge.value=tails.value=giantBlocks.value=minorComponents.value=minorBlocks.value=false;
  }
  public void setting() {
    initialize();
    graph.calculateBackbones();
  }
  public void show() {
    _N=_E=0;
    for (Vertex nodeA : graph.vertex)
      switch(nodeA.order[1]) {
      case -5:
        if (surplus.value) {
          stroke(gui.mainColor.value);
          showNetwork(nodeA);
        }
        break;
      case 0:
        if (minorComponents.value) {
          stroke(gui.partColor[0].value);
          showNetwork(nodeA);
        }
        break;
      case -2:
        if (tails.value) {
          stroke(gui.partColor[3].value);
          showNetwork(nodeA);
        }
        break;
      case -3:
        if (giantBlocks.value) {
          stroke(gui.partColor[1].value);
          showNetwork(nodeA);
        } else if (minorBlocks.value) {
          stroke(gui.partColor[2].value);
          showNetwork(nodeA);
        }
        break;
      case -4:
        if (giantBlocks.value) {
          stroke(gui.partColor[1].value);
          showNetwork(nodeA);
        }
        break;
      default:
        if (minorBlocks.value) {
          stroke(gui.partColor[2].value);
          showNetwork(nodeA);
        }
      }
  }
  public void showNetwork(Vertex nodeA) {
    if (showEdge.value) {
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.neighbors)
        if (nodeA.value<nodeB.value&&((nodeB.order[1]>0||nodeB.order[1]==-1)&&minorBlocks.value||nodeB.order[1]==0&&minorComponents.value||nodeB.order[1]==-2&&tails.value||nodeB.order[1]==-3&&(giantBlocks.value||minorBlocks.value)||nodeB.order[1]==-4&&giantBlocks.value)) {
          _E++;
          line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
    }
    if (showNode.value) {
      _N++;
      displayNode(nodeA);
    }
  }
  public void data() {
    fill(gui.headColor[1].value);
    text("Surplus...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0f/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0f/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0f/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0f/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0f/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0f/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0f/_N:0);
    for (int i=0; i<3; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(16+i+1));
  }
}
class Sweep extends Method {
  int i;
  SweepComparator comparator=new SweepComparator();
  public boolean connecting() {
    graph.vertex[i].lowpoint=0;
    if (i==graph.vertex.length-1)
      return false;
    for (int j=i+1; j<graph.vertex.length&&comparator.difference(graph.vertex[j], graph.vertex[i])<graph.r; j++)
      if (graph.vertex[i].distance(graph.vertex[j])<graph.r) {
        graph.vertex[i].neighbors.addLast(graph.vertex[j]);
        graph.vertex[j].neighbors.addLast(graph.vertex[i]);
        graph._E++;
        graph.vertex[j].lowpoint=0;
      }
    i++;
    return true;
  }
  public void reset() {
    i=0;
    comparator.setCoordinateIndex(index);
    Arrays.sort(graph.vertex, comparator);
    for (int i=0; i<graph.vertex.length; i++)
      graph.vertex[i].value=i;
  }
}
class SweepComparator implements Comparator<Vertex> {
  int index;//coordinate index
  public double difference(Vertex nodeA, Vertex nodeB) {
    switch(index) {
    case 0:
      return nodeA.x-nodeB.x;
    case 1:
      return nodeA.pho-nodeB.pho;
    case 2:
      return nodeA.rho-nodeB.rho;
    default:
      return 0;
    }
  }
  public int compare(Vertex nodeA, Vertex nodeB) {
    double result=difference(nodeA, nodeB);
    if (result>0)
      return 1;
    else if (result==0)
      return 0;
    else
      return -1;
  }
  public void setCoordinateIndex(int index) {
    this.index=index;
  }
}
class Switcher {
  float x, y, switchHeight;
  boolean value=true;
  String[] label=new String[2];
  Switcher(String labelI, String labelII) {
    label[0]=labelI;
    label[1]=labelII;
  }
  public boolean active() {
    if (mouseX>x&&mouseX<x+2*switchHeight&&mouseY>y&&mouseY<y+switchHeight) {
      value=!value;
      return true;
    } else
      return false;
  }
  public void display(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    rectMode(CORNER);
    switchHeight=gui.thisFont.stepY();
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    if (value)
      fill(gui.colour[2].value, 70);
    else
      noFill();
    rect(x, y, 2*switchHeight, switchHeight, switchHeight/2);
    fill(gui.bodyColor[2].value);
    text(label[value?1:0], x+2*switchHeight+gui.thisFont.stepX(), y+switchHeight/2);
    noStroke();
    fill(gui.mainColor.value);
    if (value)
      circle(x+1.5f*switchHeight, y+switchHeight/2, switchHeight-gui.unit(4));
    else
      circle(x+switchHeight/2, y+switchHeight/2, switchHeight-gui.unit(4));
    popStyle();
  }
}
class SysColor {
  int r, g, b;
  int value;
  SysColor() {
    setValue(0);
  }
  SysColor(int v) {
    setValue(v);
  }
  SysColor(int r, int g, int b) {
    setValue(r, g, b);
  }
  public void setValue(int v) {
    r=v/65536%256;
    g=v/256%256;
    b=v%256;
    setValue(r, g, b);
  }
  public void setValue(int r, int g, int b) {
    this.r=r;
    this.g=g;
    this.b=b;
    value=color(r, g, b);
  }
}
public class SystemSettings extends Setting implements Screen {
  int index;
  Switcher saveMode=new Switcher("Auto", "Manual"), colorMode=new Switcher("Demo", "Paper"), captureMode=new Switcher("Fullscreen", "Partial screen");
  Slider fps=new Slider("FPS", 1, 120, 1);
  Animation sonic=new GIF("Sonic", 8);
  PathBar[] bar={new PathBar("Default save path", io.path), new PathBar("Screenshot path", capture.path), new PathBar("Error log path", error.path)};
  Button[] button={new Button("Select"), new Button("Select"), new Button("Select")};
  SystemSettings(WSN wsn) {
    label="System";
    video=new Video(wsn, "System.mov");
  }
  public void initialize() {
    saveMode.value=io.mode;
    colorMode.value=gui.mode;
    captureMode.value=capture.mode;
    fps.setValue(frameRate);
  }
  public void show(float x, float y, float panelWidth, float panelHeight) {
    float contentHeight=saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[0].barHeight*bar.length+gui.thisFont.gap(3+bar.length);
    fill(gui.headColor[2].value);
    textAlign(LEFT, CENTER);
    text("Save mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight/2);
    saveMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2);
    text("Color mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+gui.thisFont.gap()+colorMode.switchHeight/2);
    colorMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+gui.thisFont.gap());
    text("Screenshot mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+gui.thisFont.gap(2)+captureMode.switchHeight/2);
    captureMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+gui.thisFont.gap(2));
    fps.display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+gui.thisFont.gap(3), panelWidth/2-gui.thisFont.stepX());
    sonic.display(GUI.HEIGHT, x+panelWidth/2+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+gui.thisFont.gap(3), fps.sliderHeight);
    for (int i=0; i<bar.length; i++) {
      bar[i].display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[i].barHeight*i+gui.thisFont.gap(4+i), panelWidth-gui.thisFont.stepX(3)-button[i].buttonWidth);
      button[i].display(GUI.HEIGHT, x+panelWidth-button[0].buttonWidth-gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[i].barHeight*i+gui.thisFont.gap(4+i)+bar[i].pathHeight, bar[i].pathHeight);
    }
  }
  public void moreKeyReleases() {
    if (!bar[0].active&&!bar[1].active&&!bar[2].active)
      switch(Character.toLowerCase(key)) {
      case 'c':
        colorMode.value=!colorMode.value;
        gui.mode=colorMode.value;
        gui.resetColor();
        break;
      case 's':
        saveMode.value=!saveMode.value;
        io.mode=saveMode.value;
        break;
      case 'x':
        captureMode.value=!captureMode.value;
        capture.mode=captureMode.value;
      }
  }
  public void moreKeyPresses() {
    for (PathBar path : bar)
      path.keyPress();
  }
  public void keyType() {
    for (PathBar path : bar)
      path.keyType();
  }
  public void moreMousePresses() {
    for (PathBar path : bar)
      path.mousePress();
    if (fps.active())
      frameRate(fps.value);
  }
  public void moreMouseReleases() {
    if (captureMode.active())
      capture.mode=captureMode.value;
    if (colorMode.active()) {
      gui.mode=colorMode.value;
      gui.resetColor();
    }
    if (saveMode.active())
      io.mode=saveMode.value;
    for (int i=0; i<button.length; i++)
      if (button[i].active()) {
        index=i;
        selectFolder("Select a folder", "setPath", new File(System.getProperty("user.dir")), this);
      }
    if (navigation.nextPage!=21)
      video.pause();
  }
  public void setPath(File selection) {
    if (selection != null)
      bar[index].path.setValue(selection.getAbsolutePath());
  }
}
abstract class Topology {
  int value;
  double range, xRange, yRange, zRange;//range means the max diameter for a cylinderal coordinate system.
  Random rnd=new Random();
  public abstract double getR(double avg, int n);
  public abstract double getAvg(double r, int n);
  public abstract Vertex generateVertex(int value);
  public int connectivity() {
    return value<6?5:7;
  }
  public int characteristic() {
    return (value==5||value==6)?0:2;
  }
}
class Torus extends Topology {
  Torus() {
    range=xRange=yRange=3;
    zRange=1;
    value=5;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(2*Math.PI*(avg+1)/n);
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=n*r*r/(2*Math.PI)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }

  public String toString() {
    return "Torus";
  }
  public Vertex generateVertex(int index) {
    double[] u={rnd.nextDouble()*2*Math.PI, rnd.nextDouble()*2*Math.PI};
    return new Vertex(index, (1+Math.cos(u[1])/2)*Math.cos(u[0]), (1+Math.cos(u[1])/2)*Math.sin(u[0]), Math.sin(u[1])/2, connectivity());
  }
}
abstract class Tree {
  float x, y, angle, angleOffset, tall, windForce, windAngle, blastForce, growth;
  Tree[] branch;
  public abstract void display();
  public abstract void drawBranch();
  Tree(float x, float y, float tall) {
    this.x = x;//width/2
    this.y = y;//height
    this.tall = tall;
  }
  public void birth() {
    float xB=x+sin(angle)*tall, yB=y+cos(angle)*tall;
    if (tall>10) {
      if (tall+random(tall)>40)
        branch[0]=new Branch(this, xB, yB, random(-0.5f, -0.1f)+((angle%TWO_PI)>PI?-1/tall:1/tall), tall*random(0.6f, 0.9f));
      if (tall+random(tall) > 40)
        branch[1]=new Branch(this, xB, yB, random(0.1f, 0.5f)+((angle%TWO_PI)>PI?-1/tall:1/tall), tall*random(0.6f, 0.9f));
    }
  }
  public void show() {
    if (branch[0]==null&&branch[1]==null) {
      pushMatrix();
      translate(x, y);
      rotate(-angle);
      stroke(0xff5d6800);
      strokeWeight(gui.unit(2));
      line(0, 0, 0, gui.unit(24));
      noStroke();
      fill(0xff749600);
      bezier(0, gui.unit(12), gui.unit(-12), gui.unit(24), gui.unit(-12), gui.unit(24), 0, gui.unit(36));
      bezier(0, gui.unit(36), gui.unit(12), gui.unit(24), gui.unit(12), gui.unit(24), 0, gui.unit(12));
      fill(0xff8bb800);
      bezier(0, gui.unit(18), 0, gui.unit(26), 0, gui.unit(26), 0, gui.unit(36));
      bezier(0, gui.unit(36), gui.unit(12), gui.unit(26), gui.unit(12), gui.unit(26), 0, gui.unit(18));
      stroke(0xff659000);
      noFill();
      bezier(0, gui.unit(18), gui.unit(-2), gui.unit(22), gui.unit(-2), gui.unit(24), 0, gui.unit(30));
      popMatrix();
    } else
      drawBranch();
  }
}
class Triangle extends Topology {
  Triangle() {
    xRange=1;
    yRange=Math.sqrt(3)/2;
    range=Math.sqrt(7)/2;
    value=3;
  }
  public double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(Math.sqrt(3)*(avg+1)/(n*Math.PI))/2;
      return r>range?range:r;
    }
  }
  public double getAvg(double r, int n) {
    double avg=2*Math.PI*n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  public String toString() {
    return "Triangle";
  }
  public Vertex generateVertex(int index) {
    double[] r={rnd.nextDouble(), rnd.nextDouble()};
    return new Vertex(index, (1-Math.sqrt(r[0]))/2-r[1]*Math.sqrt(r[0])/2, (Math.sqrt(r[0])-1)*Math.sqrt(3)/6-r[1]*Math.sqrt(r[0])*Math.sqrt(3)/6+(Math.sqrt(r[0])*(1-r[1]))*Math.sqrt(3)/3-Math.sqrt(3)/12, zRange, connectivity());
  }
}
class Vertex {
  int value, degree, lowpoint=-1;//value: vertex ID or list size; degree: degreeList index or degree when deleted; order: DFS order; lowpoint: DFS lowpoint or degree when deleted and isGraph mark;
  int[] order={-5, -6};//order[0] for random combined bipartite, order[1] for archived backbones; 0->minor components, >0->minor blocks, -1->MB separates, -2->tails, -3->GB separates -4->giant block -5->surplus
  float avgDegree, avgOrgDegree;
  double x, y, z, rho, pho, theta, phi;
  boolean mark;//mark for tail counting
  HashMap<Color, LinkedList<Vertex>> coloredNeighbors;
  Color primeColor, relayColor;
  Vertex previous, next;
  LinkedList<Vertex> neighbors, arcs, links;//arcs used in independent set for gabriel graph, links used in bipartite subgraph
  LinkedList<Color>[] colorList;//used in relay coloring color list according to relay degree
  ListIterator<Vertex> edgeIndicator;
  Vertex () {
  }
  Vertex(int degree) {//degreeList is a doubly linked list with head
    this.degree=degree;
  }
  Vertex(int value, double x, double y, double z, int connectivity) {//cartesian system
    this.x=x;
    this.y=y;
    this.z=z;
    pho=Math.sqrt(x*x+y*y);
    rho=Math.sqrt(x*x+y*y+z*z);
    phi=arctan(y, x);
    theta=rho==0?0:Math.acos(z/rho);
    initialize(value, connectivity);
  }
  Vertex(double rho, double theta, double phi, int value, int connectivity) {//spherical system
    this.rho=rho;
    this.theta=theta;
    this.phi=phi;
    x=rho*(theta==Math.PI/2?1:Math.sin(theta))*Math.cos(phi);
    y=rho*(theta==Math.PI/2?1:Math.sin(theta))*Math.sin(phi);
    z=theta==Math.PI/2?0:rho*Math.cos(theta);
    pho=theta==Math.PI/2?rho:Math.sqrt(x*x+y*y);
    initialize(value, connectivity);
  }
  public double arctan(double y, double x) {
    double ans=Math.atan2(y, x);
    return ans<0?Math.PI*2+ans:ans;
  }
  public double distance(Vertex node) {
    return Math.sqrt(squaredDistance(node));
  }
  public double squaredDistance(Vertex node) {
    return (x-node.x)*(x-node.x)+(y-node.y)*(y-node.y)+(z-node.z)*(z-node.z);
  }
  public Vertex pop() {//pop out the 1st node
    if (next==null)
      return this;
    else {
      Vertex vertex=next;
      next=vertex.next;
      if (next!=null)
        next.previous=this;
      value--;
      return vertex;
    }
  }
  public LinkedList<Vertex> linksAt(Color colour) {//return neighbors according to color from hashmap
    LinkedList<Vertex> list=coloredNeighbors.get(colour);
    return list==null?gui.mainColor.vertices:list;
  }
  public void setEdgeIndicator() {//reset listIterator of links
    edgeIndicator=links.listIterator();
  }
  public void setCoordinates(double x, double y, double z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }
  public void clearColor(Color colour) {
    if (colour==primeColor) {//use if else to achieve the clearColor(null) usage, which clear relays only
      primeColor=null;
      coloredNeighbors.clear();
    } else {
      for (LinkedList<Color> list : colorList)
        list.clear();
      relayColor=null;
      order[1]=-6;
    }
  }
  public void initialize(int value, int connectivity) {
    this.value=value;
    neighbors=new LinkedList<Vertex>();
    colorList=new LinkedList[connectivity-1];//0 means 2 in connectivity 
    for (int i=0; i<colorList.length; i++)
      colorList[i]=new LinkedList<Color>();
    coloredNeighbors=new HashMap<Color, LinkedList<Vertex>>();
  }
  public void categorize(Vertex node) {//push node to corresponding coloredNeighbors
    if (coloredNeighbors.containsKey(node.primeColor))
      coloredNeighbors.get(node.primeColor).addLast(node);
    else {
      LinkedList<Vertex> list=new LinkedList<Vertex>();
      list.addLast(node);
      coloredNeighbors.put(node.primeColor, list);
    }
  }
  public void clean() {//clear the list
    next=null;
    value=0;
  }
  public void push(Vertex vertex) {//push node to the list at 1st location
    vertex.previous=this;
    vertex.next=next;
    if (next!=null)
      next.previous=vertex;
    next=vertex;
    value++;
  }
  public void solo(Vertex head) {//solo from a list
    head.value--;
    previous.next=next;
    if (next!=null)
      next.previous=previous;
  }
}
class VertexDegreePlot extends Plots implements Screen {
  Checker originalDegree=new Checker("Original degree"), averageDegree=new Checker("Average degree when deleted"), averageOriginalDegree=new Checker("Average original degree"), degreeDeleted=new Checker("Degree when deleted");
  VertexDegreePlot() {
    parts.addLast(originalDegree);
    parts.addLast(averageOriginalDegree);
    parts.addLast(averageDegree);
    parts.addLast(degreeDeleted);
    chart=new Plot("Vertex", "Degree", gui.partColor, "Original degree", "Average degree when deleted", "Average original degree", "Degree when deleted");
  }
  public void moreSettings() {
    chart.setX(0, graph.vertex.length-1);
    chart.setY(0, graph.maxDegree);
    chart.setPoints();
    for (int i=0; i!=graph.vertex.length; i++) {
      chart.points[0].set(i, graph.vertex[i].neighbors.size()+0f);
      chart.points[1].set(i, graph.vertex[i].avgOrgDegree);
      chart.points[2].set(i, graph.vertex[i].avgDegree);
      chart.points[3].set(i, graph.vertex[i].degree+0f);
    }
  }
  public void show() {
    if (showEdge.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display();
    }
    if (showNode.value) {
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display();
    }
  }
  public void moreMouseReleases() {
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
      Checker checker=i.next();
      if (checker.active())
        chart.setPlot(i.previousIndex(), checker.value);
    }
  }
}
class Video extends Animation {
  Movie movie;
  float volume=1, playWidth, playHeight;
  Video(WSN wsn, String path) {
    movie = new Movie(wsn, path);
  }
  public void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      animeWidth=gui.unit(movie.width)*factor;
      animeHeight=gui.unit(movie.height)*factor;
      break;
    case GUI.WIDTH:
      animeWidth=factor;
      animeHeight=movie.height*factor/movie.width;
      break;
    case GUI.HEIGHT:
      animeWidth=movie.width*factor/movie.height;
      animeHeight=factor;
    }
    image(movie, x, y, animeWidth, animeHeight);
  }
  public void play() {
    movie.play();
    isPlaying=true;
  }
  public void repeat() {
    isPlaying=true;
    movie.loop();
  }
  public void end() {
    isPlaying=false;
    movie.stop();
  }
  public void pause() {
    isPlaying=false;
    movie.pause();
  }
  public void jump(float percent) {
    movie.jump(percent*movie.duration());
  }
  public int hours() {
    return round(movie.time())/3600;
  }
  public int minutes() {
    return round(movie.time()%3600)/60;
  }
  public int seconds() {
    return round(movie.time())%60;
  }
  public float position() {
    return movie.time()/movie.duration();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WSN" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
