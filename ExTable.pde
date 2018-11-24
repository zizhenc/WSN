class ExTable extends Table {
  String maxString;
  ExTable(String[] column, int rows) {
    for (String c : column)
      addColumn(c);
    for (int i=0; i<rows; i++)
      addRow();
    maxString=column[0];
    for (int i=1; i<column.length; i++)
      if (column[i].length()>maxString.length())
        maxString=column[i];
  }
  void display(float x, float y) {
    pushStyle();
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    float gap=textWidth(maxString)+gui.body.stepX();
    line(x, y, x+getColumnCount()*gap, y);
    line(x, y+gui.body.stepY((getRowCount()+1)*1.6), x+getColumnCount()*gap, y+gui.body.stepY((getRowCount()+1)*1.6));
    line(x, y, x, y+gui.body.stepY((getRowCount()+1)*1.6));
    line(x+getColumnCount()*gap, y, x+getColumnCount()*gap, y+gui.body.stepY((getRowCount()+1)*1.6));
    strokeWeight(gui.unit());
    for (int i=1; i<getColumnCount(); i++)
      line(x+i*gap, y, x+i*gap, y+gui.body.stepY((getRowCount()+1)*1.6));
    for (int i=1; i<=getRowCount(); i++)
      line(x, y+gui.body.stepY(i*1.6), x+getColumnCount()*gap, y+gui.body.stepY(i*1.6));
    fill(gui.headColor[3].value);
    textAlign(CENTER);
    for (int i=0; i<getColumnCount(); i++)
      text(getColumnTitle(i), x+i*gap+gap/2, y+gui.body.stepY(1.1));
    fill(gui.bodyColor[0].value);
    for (int i=0; i<getRowCount(); i++)
      for (int j=0; j<getColumnCount(); j++)
        if (getString(i, j)!=null)
          text(getString(i, j), x+j*gap+gap/2, y+gui.body.stepY(1.6*i+2.7));
    popStyle();
  }
}
