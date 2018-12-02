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
  String measure() {
    return String.format("(%d, %.2f)", max(0, floor((mouseX-xStart)/intervalX)), (yStart-mouseY)/intervalY);
  }
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
