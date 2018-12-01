class BarChart extends Chart {
  float barWidth;
  BarChart(String labelX, String labelY, int bars) {
    super(labelX, labelY, bars);
  }
  void chartAt(int index) {
    for (ListIterator<Float> i=points[index].listIterator(); i.hasNext(); ) {
      float value=i.next();
      if (value>0)
        rect(xStart+gapX/2+i.previousIndex()*intervalX-barWidth*points.length/2+index*barWidth, yStart, barWidth, -value*intervalY);
    }
  }
  /*
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
  void graduation() {
    barWidth=intervalX/(points.length+1);
    for (int i=0; i<=(maxX-minX)/stepX; i++)
      line(xStart+i*gapX+gapX/2, yStart+gui.thisFont.gap(), xStart+i*gapX+gapX/2, yStart);
    for (int i=1; i<=(maxY-minY)/stepY; i++)
      line(xStart, yStart-gapY*i, xStart-gui.thisFont.gap(), yStart-gapY*i);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(maxX-minX)/stepX; i++)
      text(i*stepX, xStart+i*gapX+gapX/2, y+chartHeight);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<=(maxY-minY)/stepY; i++)
      text(i*stepY, xStart-gui.thisFont.stepX(), yStart-gapY*i);
  }
}
