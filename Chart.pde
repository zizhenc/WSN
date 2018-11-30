class Chart {
  String labelX, labelY;
  int stepX, stepY;
  float minX, maxX, minY, maxY, intervalX, intervalY, gapX, gapY, rangeX, rangeY, x, y, chartWidth, chartHeight;
  boolean measureX, measureY;//measure locations in X and Y directions, false means left or up to the cursor, true means right or bottom to the cursor
  LinkedList<Float>[] points;
  Chart(String labelX, String labelY, int plots) {
    this.labelX=labelX;
    this.labelY=labelY;
    points=new LinkedList[plots];
    for (int i=0; i!=points.length; i++)
      points[i]=new LinkedList<Float>();
  }
  void setRange(float minX, float maxX, float minY, float maxY) {
    this.minX=minX;
    this.maxX=maxX;
    this.minY=minY;
    this.maxY=maxY;
  }
  void initialize(float x, float y, float chartWidth, float chartHeight) {
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.chartWidth=chartWidth;
    this.chartHeight=chartHeight;
  }
  void arrow(float x1, float y1, float x2, float y2) {
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    rotate(atan2(x1-x2, y2-y1));
    line(0, 0, -3, -6);
    line(0, 0, 3, -6);
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
