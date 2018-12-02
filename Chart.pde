abstract class Chart {
  String labelX, labelY;
  int stepX, stepY, minX, maxX, minY, maxY;
  float intervalX, intervalY, gapX, gapY, rangeX, rangeY, x, y, chartWidth, chartHeight, xStart, yStart;
  color[] colour;
  boolean[] chart;
  LinkedList<Float>[] points;
  abstract String measure();
  abstract void graduation();
  abstract void chartAt(int index);
  Chart(String labelX, String labelY, int plots) {
    this.labelX=labelX;
    this.labelY=labelY;
    points=new LinkedList[plots];
    colour=new color[plots];
    chart=new boolean[plots];
    for (int i=0; i!=plots; i++) {
      points[i]=new LinkedList<Float>();
      colour[i]=color(random(128, 256), random(128, 256), random(128, 256));
    }
  }
  void display(float x, float y, float chartWidth, float chartHeight) {
    pushStyle();
    stroke(gui.frameColor.value);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.chartWidth=chartWidth;
    this.chartHeight=chartHeight;
    rangeX=chartWidth-gui.thisFont.stepX(2)-textWidth(labelX+maxY)-gui.thisFont.gap();
    rangeY=chartHeight-gui.thisFont.stepY(2)-gui.thisFont.gap(2);
    stepX=stepY=1;
    intervalX=gapX=rangeX/(maxX-minX+1);
    intervalY=gapY=rangeY/(maxY-minY);
    while (gapX<=textWidth(maxX+"")) {
      stepX++;
      gapX=rangeX*stepX/(maxX-minX+1);
    }
    while (gapY<=gui.thisFont.stepY()) {
      stepY++;
      gapY=rangeY*stepY/(maxY-minY);
    }
    xStart=x+textWidth(maxY+"")+gui.thisFont.stepX();
    yStart=y+chartHeight-gui.thisFont.stepY()-gui.thisFont.gap();
    strokeWeight(gui.unit(2));
    fill(gui.headColor[3].value);
    textAlign(LEFT, TOP);
    text(labelY, x, y);
    textAlign(LEFT, CENTER);
    text(labelX, x+chartWidth-textWidth(labelX), yStart);
    arrow(xStart, y+chartHeight-gui.thisFont.stepY(), xStart, y+gui.thisFont.stepY());
    arrow(xStart-gui.thisFont.gap(), yStart, x+chartWidth-gui.thisFont.stepX()-textWidth(labelX), yStart);
    if (mouseX>x+textWidth(maxY+"")&&mouseX<x+chartWidth-textWidth(labelX)&&mouseY>=y&&mouseY<=y+chartHeight-gui.thisFont.stepY()) {
      dottedLine(x, mouseY, x+chartWidth, mouseY);
      dottedLine(mouseX, y, mouseX, y+chartHeight);
      fill(gui.headColor[3].value);
      float xPos, yPos;
      int alignX, alignY;
      if (mouseX<xStart+(rangeX+gui.thisFont.gap())/2) {
        alignX=LEFT;
        xPos=mouseX+gui.thisFont.stepX();
      } else {
        alignX=RIGHT;
        xPos=mouseX-gui.thisFont.stepX();
      }
      if (mouseY>y+gui.thisFont.stepY()+(rangeY+gui.thisFont.gap())/2) {
        alignY=BOTTOM;
        yPos=mouseY-gui.thisFont.gap();
      } else {
        alignY=TOP;
        yPos=mouseY+gui.thisFont.gap();
      }
      textAlign(alignX, alignY);
      text(measure(), xPos, yPos);
    }
    strokeWeight(gui.unit());
    graduation();
    for (int i=0; i<points.length; i++) {
      fill(colour[i]);
      chartAt(i);
    }
    popStyle();
  }
  void initialize(int minX, int maxX, int minY, int maxY) {
    this.minX=minX;
    this.maxX=maxX;
    this.minY=minY;
    this.maxY=maxY;
  }
  void arrow(float x1, float y1, float x2, float y2) {
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    rotate(atan2(x1-x2, y2-y1));
    line(0, 0, -gui.unit(3), -gui.unit(6));
    line(0, 0, gui.unit(3), -gui.unit(6));
    popMatrix();
  }
  void clean() {
    for (int i=0; i!=points.length; i++)
      points[i].clear();
  }
  void dottedLine(float x1, float y1, float x2, float y2) {
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
  }
}
