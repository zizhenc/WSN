class Plot extends Chart {
  int[][] size;
  int interval=1;
  Plot(String labelX, String labelY, SysColor[] colors, String...bar) {
    super(labelX, labelY, colors, bar);
    size=new int[2][plots];
    drawPlot=new DrawPlot[] {
      new DrawPlot() {
        void display() {
          pushStyle();
          for (int i=0; i<plot.length; i++)
            if (active[i]){
              stroke(colour[i].value);
              for (int j=0; j<=size[0][i]; j++)
                point(xStart+j*intervalX, yStart-intervalY*points[i].get(j));
              if(play) {
                size[0][i]+=interval;
                if(size[0][i]>maxX-minX)
                  size[0][i]=maxX-minX;
              }
            }
          popStyle();
        }
        void display(int index){
          display(index, minX);
        }
        void display(int index, int beginIndex) {
          if(active[index]) {
            pushStyle();
            stroke(colour[index].value);
            for (int i=0; i<size[0][index]; i++)
                point(xStart+(i+beginIndex-minX)*intervalX, yStart-intervalY*points[index].get(i));
            if(play) {
              size[0][index]+=interval;
              if(size[0][index]>points[index].size())
                size[0][index]=points[index].size();
            }
            popStyle();
          }
        }
      },
      new DrawPlot() {
        void display() {
          pushStyle();
          for (int i=0; i<plot.length; i++)
            if (active[i]) {
              stroke(colour[i].value);
              for (int j=0; j<size[1][i]; j++)
                line(xStart+j*intervalX, yStart-intervalY*points[i].get(j), xStart+(j+1)*intervalX, yStart-intervalY*points[i].get(j+1));
              if(play) {
                size[1][i]+=interval;
                if(size[1][i]>maxX-minX)
                  size[1][i]=maxX-minX;
              }
            }
          popStyle();
        }
        void display(int index){
          display(index, minX);
        }
        void display(int index, int beginIndex) {
          if(active[index]) {
            pushStyle();
            stroke(colour[index].value);
            for (int i=0; i<size[1][index]; i++)
              line(xStart+(i+beginIndex-minX)*intervalX, yStart-intervalY*points[index].get(i), xStart+(i+beginIndex-minX+1)*intervalX, yStart-intervalY*points[index].get(i+1));
            if(play) {
              size[1][index]+=interval;
              if(size[1][index]>points[index].size()-1)
                size[1][index]=points[index].size()-1;
            }
            popStyle();
          }
        }
      }
    };
  }
  void setInterval(float interval) {
    int max=maxX-minX;
    for(int i=0;i<plot.length;i++)
      if(max>points[i].size())
        max=points[i].size();
    this.interval=constrain(round(interval), 0, max);
  }
  void reset(){
    for(int i=0;i<2;i++)
      for(int j=0;j<size[i].length;j++)
        size[i][j]=0;
  }
  void showScaleX(float x, float y, int beginIndex, int endIndex) {
    pushStyle();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit());
    for (int i=1; i<=(endIndex-beginIndex)/stepX; i++)
      line(x+i*gapX, y+gui.thisFont.gap(), x+i*gapX, y);
    strokeWeight(gui.unit(2));
    line(x, y, x+(endIndex-beginIndex+1)*intervalX, y);
    fill(gui.bodyColor[0].value);
    textAlign(CENTER);
    for (int i=0; i<=(endIndex-beginIndex)/stepX; i++)
      text(i*stepX+beginIndex, x+i*gapX, y+gui.thisFont.stepY()+gui.thisFont.gap());
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
    return min(max(minX, (mouseX-xStart)/intervalX), maxX);
  }
  float getX(float index) {
    return xStart+index*intervalX;
  }
  float getY() {
    return min(max(minY, (yStart-mouseY)/intervalY), maxY);
  }
  float getY(float index) {
    return yStart-index*intervalY;
  }
}
