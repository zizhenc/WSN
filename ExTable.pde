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
  float tableWidth() {
    return getColumnCount()*gapX;
  }
  float tableHeight() {
    return (getRowCount()+1)*gapY;
  }
  void display(float x, float y) {
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
