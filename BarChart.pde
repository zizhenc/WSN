class BarChart extends Chart {
  float barWidth;
  BarChart(String labelX, String labelY, String[] bar) {
    super(labelX, labelY, bar);
  }
  void chartAt(int index, int sequence) {
    for (int i=0; i<points[index].size(); i++) {
      float value=points[index].get(i);
      if (value>0)
        rect(xStart+gapX/2+i*intervalX-barWidth*plots/2+sequence*barWidth, yStart, barWidth, -value*intervalY);
    }
  }
  String measure() {
    return String.format("(%d, %.2f)", max(0, floor((mouseX-xStart)/intervalX)), max(0, (yStart-mouseY)/intervalY));
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
