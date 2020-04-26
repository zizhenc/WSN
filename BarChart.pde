class BarChart extends Chart {
  float[] percent;
  float interval=0.01;
  BarChart(String labelX, String labelY, SysColor[] colors, String...bar) {
    super(labelX, labelY, colors, bar);
    percent=new float[plots];
    drawPlot=new DrawPlot[] {
      new DrawPlot() {
        void display() {
          float barWidth=intervalX/plot.length*g.strokeWeight/10;
          pushStyle();
          strokeWeight(barWidth);
          strokeCap(SQUARE);
          for (int i=0, sequence=0; i<plot.length; i++)
            if (active[i]) {
              stroke(colour[i].value);
              for (int j=0; j<=maxX-minX; j++) {
                float value=points[i].get(j);
                if (value>0)
                  line(xStart+gapX/2+j*intervalX-barWidth*plots/2+(sequence+0.5)*barWidth, yStart, xStart+gapX/2+j*intervalX-barWidth*plots/2+(sequence+0.5)*barWidth, yStart-value*intervalY*percent[i]);
              }
              sequence++;
              if(play){
                percent[i]+=interval;
                if(percent[i]>1)
                  percent[i]=1;
              }
            }
          popStyle();
        }
        void display(int index) {
          display(index, minX);
        }
        void display(int index, int beginIndex) {
          if (active[index]) {
            float barWidth=intervalX*g.strokeWeight/10;
            pushStyle();
            strokeWeight(barWidth);
            strokeCap(SQUARE);
            stroke(colour[index].value);
            for (int i=beginIndex-minX; i<=points[index].size(); i++) {
              float value=points[index].get(i-beginIndex+minX);
              if (value>0)
                line(xStart+gapX/2+i*intervalX, yStart, xStart+gapX/2+i*intervalX, yStart-value*intervalY*percent[index]);
            }
            popStyle();
            if(play) {
              percent[index]+=interval;
              if(percent[index]>1)
                percent[index]=1;
            }
          }
        }
      }
    };
  }
  void reset(){
    for(int i=0;i<percent.length;i++)
      percent[i]=0;
  }
  void setInterval(float interval){
    for(int i=0;i<percent.length;i++)
      percent[i]=0;
    this.interval=constrain(round(interval), 0, maxX-minX);
    this.interval=constrain(interval, 0, 1);
  }
  void showScaleX(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=beginIndex; i<=(endIndex-beginIndex)/stepX; i++)
      line(x+i*gapX+gapX/2, y+gui.thisFont.gap(), x+i*gapX+gapX/2, y);
    strokeWeight(gui.unit(2));
    line(x, y, x+(endIndex-beginIndex+1)*intervalX, y);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepX; i++)
      text(i*stepX+beginIndex, x+i*gapX+gapX/2, y+gui.thisFont.stepY());
    popStyle();
  }
  void showScaleY(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=1; i<=(endIndex-beginIndex)/stepY; i++)
      line(x, y-gapY*i, x-gui.thisFont.gap(), y-gapY*i);
    strokeWeight(gui.unit(2));
    line(x, y, x, y-(endIndex-beginIndex)*intervalY);
    fill(gui.bodyColor[0].value);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepY; i++)
      text(i*stepY+beginIndex, x-gui.thisFont.stepX(), y-gapY*i);
    popStyle();
  }
  float getX() {
    return min(max(minX, (mouseX-xStart-gapX/2)/intervalX), maxX);
  }
  float getX(float index) {
    return xStart+gapX/2+index*intervalX;
  }
  float getY() {
    return min(max(minY, (yStart-mouseY)/intervalY), maxY);
  }
  float getY(float index) {
    return yStart-index*intervalY;
  }
}
