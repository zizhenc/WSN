class BarChart extends Chart {
  BarChart(String labelX, String labelY, int bars) {
    super(labelX, labelY, bars);
  }/*
  void barsAt(int index, float factor) {
   float weight=factor*intervalX, offset=weight/points.length;
   for (ListIterator<Float> i=points[index].listIterator(); i.hasNext(); ) {
   float value=i.next();
   rect(textWidth(maxX+""+maxY+"")+x+gui.thisFont.stepX()+i.previousIndex()*intervalX-weight/2+offset*index, y+gui.thisFont.stepY()+frameY-value*intervalY, offset, value*intervalY);
   }
   }
   void measure() {
   if (mouseX>=x-gui.thisFont.stepX()&&mouseX<=x+xFrameLength&&mouseY>=y-gui.thisFont.stepX()&&mouseY<=y+yFrameLength) {
   pushStyle();
   strokeWeight(gui.unit(2));
   dottedLine(x, mouseY, x+xFrameLength, mouseY);
   dottedLine(mouseX, y, mouseX, y+xFrameLength);
   fill(gui.headColor[3].value);
   float xPos, yPos;
   if (mouseX<x+textWidth(maxY+"")+gui.thisFont.stepX()+frameX/2) {
   textAlign(LEFT);
   xPos=mouseX+gui.thisFont.stepX();
   } else {
   textAlign(RIGHT);
   xPos=mouseX-gui.thisFont.stepX();
   }
   if (mouseY>y+gui.thisFont.stepY()+frameY/2) {
   measureY=false;
   yPos=mouseY-gui.thisFont.stepY(0.5);
   } else {
   measureY=true;
   yPos=mouseY+gui.thisFont.stepY();
   }
   text(String.format("(%.2f, %.2f)", (mouseX-x-textWidth(maxX+""+maxY+"")-gui.thisFont.stepX())/intervalX, (y+gui.thisFont.stepY()+frameY-mouseY)/intervalY), xPos, yPos);
   popStyle();
   }
   }*/
  void frame() {
    pushStyle();
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    float maxXLength=textWidth(round(maxX)+""), maxYLength=textWidth(round(maxY)+"");
    rangeX=chartWidth-gui.thisFont.stepX(2)-textWidth(round(maxY)+labelY);
    rangeY=chartHeight-gui.thisFont.stepY(2)-gui.thisFont.gap();
    fill(gui.headColor[3].value);
    textAlign(LEFT, TOP);
    text(labelY, x, y);
    textAlign(LEFT, CENTER);
    text(labelX, x+chartWidth-textWidth(labelX), y+gui.thisFont.stepY()+rangeY);
    arrow(x+maxYLength+gui.thisFont.stepX(), y+chartHeight-gui.thisFont.stepY(), x+maxYLength+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    arrow(x+maxYLength+gui.thisFont.stepX()-gui.thisFont.gap(), y+chartHeight-gui.thisFont.stepY()-gui.thisFont.gap(), x+chartWidth-gui.thisFont.stepX()-textWidth(labelX), y+chartHeight-gui.thisFont.stepY()-gui.thisFont.gap());
    stepX=stepY=1;
    intervalX=gapX=rangeX/(maxX-minX);
    intervalY=gapY=rangeY/(maxY-minY);
    while (gapX<textWidth(round(maxX)+"")) {
      stepX++;
      gapX=rangeX*stepX/(maxX-minX);
    }
    while (gapY<gui.thisFont.stepY()) {
      stepY++;
      gapY=rangeY*stepY/(maxY-minY);
    }
    strokeWeight(gui.unit());
    for (int i=0; i<=(maxX-minX)/stepX; i++)
      line(maxXLength+maxYLength+x+gui.thisFont.stepX()+i*gapX, y+chartHeight-gui.thisFont.stepY(), maxXLength+maxYLength+x+gui.thisFont.stepX()+i*gapX, y+gui.thisFont.stepY()+rangeY);
    //for (int i=1; i<=(maxY-minY)/stepY; i++)
    //line(x+textWidth(maxY+"")+gui.thisFont.stepX(0.5), y+gui.thisFont.stepY()+frameY-gapY*i, x+textWidth(maxY+"")+gui.thisFont.stepX(), y+gui.thisFont.stepY()+frameY-gapY*i);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(maxX-minX)/stepX; i++)
      text(i*stepX, x+maxXLength+maxYLength+gui.thisFont.stepX()+i*gapX, y+chartHeight);
    textAlign(RIGHT, CENTER);
    //for (int i=0; i<=(maxY-minY)/stepY; i++)
    //text(i*stepY, x+textWidth(maxY+""), y+gui.thisFont.stepY()+frameY-gapY*i);
    popStyle();
  }
}
