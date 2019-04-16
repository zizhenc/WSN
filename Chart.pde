abstract class Chart {
  int stepX, stepY, minX, maxX, minY, maxY, plots;
  float intervalX, intervalY, gapX, gapY, rangeX, rangeY, x, y, chartWidth, chartHeight, xStart, yStart;
  boolean[] active;
  boolean play=true;
  String labelX, labelY;
  String[] plot;
  ArrayList<Float>[] points;
  DrawPlot[] drawPlot;
  SysColor[] colour;
  abstract float getX();//return current mouseX index 
  abstract float getY();//return current mouseY index
  abstract float getX(float index);//return x position of index
  abstract float getY(float index);//return y position of index
  abstract void showScaleX(float x, float y, int beginIndex, int endIndex);
  abstract void showScaleY(float x, float y, int beginIndex, int endIndex);
  abstract void reset();
  abstract void setInterval(float value);
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
  void showFrame(float x, float y, float chartWidth, float chartHeight) {
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
    line(xStart, yStart, xStart-gui.thisFont.gap(0.5), yStart);
    line(xStart, yStart, xStart, yStart+gui.thisFont.gap(0.5));
    fill(gui.headColor[0].value);
    textAlign(LEFT, TOP);
    text(labelY, x, y);
    textAlign(LEFT, CENTER);
    text(labelX, x+chartWidth-textWidth(labelX), yStart);
    showScaleY(xStart, yStart, minY, maxY);
    showScaleX(xStart, yStart, minX, maxX);
    popStyle();
  }
  void showLabels(float x, float y) {
    pushStyle();
    textAlign(LEFT, CENTER);
    noStroke();
    for (int i=0, sequence=0; i<plot.length; i++)
      if (active[i]) {
        fill(colour[i].value);
        rect(x, y+gui.thisFont.stepY(sequence-0.5), gui.thisFont.gap(), gui.thisFont.gap());
        text(plot[i], x+gui.thisFont.gap(2), y+gui.thisFont.stepY(sequence-0.5)+gui.thisFont.gap(0.5));
        sequence++;
      }
    popStyle();
  }
  boolean active() {
    return mouseX>x+textWidth(maxY+"")&&mouseX<x+chartWidth-textWidth(labelX)&&mouseY>=y&&mouseY<=y+chartHeight-gui.thisFont.stepY();
  }
  void showMeasurement() {
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
  void setX(int minX, int maxX) {
    this.minX=minX;
    this.maxX=maxX;
  }
  void setY(int minY, int maxY) {
    this.minY=minY;
    this.maxY=maxY;
  }
  void setPlot(int index, boolean onOff) {
    if (active[index]!=onOff) {
      if (onOff)
        plots++;
      else
        plots--;
      active[index]=onOff;
    }
  }
  void setPoints() {
    for (ArrayList<Float> point : points) {
      while (point.size()<=maxX-minX)
        point.add(0f);
      while (point.size()>maxX-minX+1)
        point.remove(point.size()-1);
    }
  }
  void setPoints(int index) {
    setPoints(index, minX, maxX);
  }
  void setPoints(int index, int minX, int maxX) {
    while (points[index].size()<=maxX-minX)
      points[index].add(0f);
    while (points[index].size()>maxX-minX+1)
      points[index].remove(points[index].size()-1);
  }
  void arrow(float x1, float y1, float x2, float y2) {
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
  void dottedLine(float x1, float y1, float x2, float y2) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
    popStyle();
  }
}
