class Plot extends Chart {
  Plot(String labelX, String labelY, String[] plot) {
    super(labelX, labelY, plot);
  }
  void chartAt(int index, int sequence) {
    for (ListIterator<Float> i=points[index].listIterator(); i.hasNext(); ) {
      //point(x+textWidth(maxY+"")+gui.body.stepX()+i.nextIndex()*intervalX, y+gui.body.stepY()+frameY-i.next()*intervalY);
    }
  }
  String measure() {
    return String.format("(%.2f, %.2f)", max(0, (mouseX-xStart)/intervalX), max(0, (yStart-mouseY)/intervalY));
  }
  void graduation() {
    for (int i=1; i<=(maxX-minX)/stepX; i++)
      line(xStart+i*gapX, yStart+gui.thisFont.gap(), xStart+i*gapX, yStart);
    for (int i=1; i<=(maxY-minY)/stepY; i++)
      line(xStart, yStart-gapY*i, xStart-gui.thisFont.gap(), yStart-gapY*i);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(maxX-minX)/stepX; i++)
      text(i*stepX, xStart+i*gapX, y+chartHeight);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<=(maxY-minY)/stepY; i++)
      text(i*stepY, xStart-gui.thisFont.stepX(), yStart-gapY*i);
  }
}
