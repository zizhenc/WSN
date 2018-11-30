/*class Plot extends Chart {
 Plot(String labelX, String labelY, int plots) {
 super(labelX, labelY, plots);
 }
 void drawScaleX(float x, float y, LinkedList<Integer> values) {
 pushStyle();
 strokeWeight(gui.unit(2));
 line(x, y, x+(values.size()-1)*intervalX, y);
 strokeWeight(gui.unit());
 for (int i=0; i<values.size()/stepX; i++)
 line(x+i*gapX, y, x+i*gapX, y-gui.body.stepX(0.5));
 fill(gui.bodyColor[0].value);
 textAlign(CENTER);
 for (int i=0; i<values.size()/stepX; i++)
 text(values.get(i*stepX), x+i*gapX, y-gui.body.stepY());
 popStyle();
 }
 void drawScaleY(float x, float y, LinkedList<Integer> values) {
 pushStyle();
 strokeWeight(gui.unit(2));
 line(x, y, x, y-(values.size()-1)*intervalY);
 strokeWeight(gui.unit());
 for (int i=0; i<values.size()/stepY; i++)
 line(x, y-i*gapY, x+gui.body.stepX(0.5), y-i*gapY);
 fill(gui.bodyColor[0].value);
 for (int i=0; i<values.size()/stepY; i++)
 text(values.get(i*stepY), x+gui.body.stepX(), y-i*gapY+gui.body.stepY(0.3));
 popStyle();
 }
 void pointsAt(int index) {
 for (ListIterator<Float> i=points[index].listIterator(); i.hasNext(); )
 point(x+textWidth(maxY+"")+gui.body.stepX()+i.nextIndex()*intervalX, y+gui.body.stepY()+frameY-i.next()*intervalY);
 }
 void pointsAt(int index, int min, int max) {
 ListIterator<Float> i=points[index].listIterator(min);
 for (int j=min; j<=max; j++)
 point(x+textWidth(maxY+"")+gui.body.stepX()+i.nextIndex()*intervalX, y+gui.body.stepY()+frameY-i.next()*intervalY);
 }
 void linesAt(int index) {
 for (ListIterator<Float> i=points[index].listIterator(), j=points[index].listIterator(1); j.hasNext(); )
 line(x+textWidth(maxY+"")+gui.body.stepX()+i.nextIndex()*intervalX, y+gui.body.stepY()+frameY-i.next()*intervalY, x+textWidth(maxY+"")+gui.body.stepX()+j.nextIndex()*intervalX, y+gui.body.stepY()+frameY-j.next()*intervalY);
 }
 void linesAt(int index, int min, int max) {
 ListIterator<Float> i=points[index].listIterator(min), j=points[index].listIterator(min+1);
 for (int k=min; k<max; k++)
 line(x+textWidth(maxY+"")+gui.body.stepX()+i.nextIndex()*intervalX, y+gui.body.stepY()+frameY-i.next()*intervalY, x+textWidth(maxY+"")+gui.body.stepX()+j.nextIndex()*intervalX, y+gui.body.stepY()+frameY-j.next()*intervalY);
 }
 void drawLineAt(int index, int min, int max) {
 line(x+textWidth(maxY+"")+gui.body.stepX()+min*intervalX, y+gui.body.stepY()+frameY-points[index].get(min)*intervalY, x+textWidth(maxY+"")+gui.body.stepX()+max*intervalX, y+gui.body.stepY()+frameY-points[index].get(max)*intervalY);
 }
 float getX() {
 return (mouseX-x-textWidth(maxY+"")-gui.body.stepX())/intervalX;
 }
 float getY() {
 return (y+gui.body.stepY()+frameY-mouseY)/intervalY;
 }
 float getXPosition(int x) {
 return this.x+textWidth(maxY+"")+gui.body.stepX()+x*intervalX;
 }
 float getYPosition(int y) {
 return this.y+gui.body.stepY()+frameY-y*intervalY;
 }
 void measure() {
 if (mouseX>=x-gui.body.stepX()&&mouseX<=x+xFrameLength&&mouseY>=y-gui.body.stepX()&&mouseY<=y+yFrameLength) {
 pushStyle();
 strokeWeight(gui.unit(2));
 dottedLine(x, mouseY, x+xFrameLength, mouseY);
 dottedLine(mouseX, y, mouseX, y+xFrameLength);
 fill(gui.headColor[3].value);
 float xPos, yPos;
 if (mouseX<x+textWidth(maxY+"")+gui.body.stepX()+frameX/2) {
 measureX=true;
 textAlign(LEFT);
 xPos=mouseX+gui.body.stepX();
 } else {
 measureX=false;
 textAlign(RIGHT);
 xPos=mouseX-gui.body.stepX();
 }
 if (mouseY>y+gui.body.stepY()+frameY/2) {
 measureY=false;
 yPos=mouseY-gui.body.stepY(0.5);
 } else {
 measureY=true;
 yPos=mouseY+gui.body.stepY();
 }
 text(String.format("(%.2f, %.2f)", (mouseX-x-textWidth(maxY+"")-gui.body.stepX())/intervalX, (y+gui.body.stepY()+frameY-mouseY)/intervalY), xPos, yPos);
 popStyle();
 }
 }
 void frame() {
 pushStyle();
 stroke(gui.frameColor.value);
 strokeWeight(gui.unit(2));
 frameX=xFrameLength-textWidth(maxY+labelX)-gui.body.stepX(2);
 frameY=yFrameLength-textWidth(maxY+labelX)-gui.body.stepX(2);
 rangeX=frameX-gui.body.stepX();
 rangeY=frameY-gui.body.stepX();
 fill(gui.headColor[3].value);
 text(labelY, x, y+gui.body.stepY(0.5));
 text(labelX, x+xFrameLength-textWidth(labelX), y+gui.body.stepY(1.3)+frameY);
 arrow(x+textWidth(maxY+"")+gui.body.stepX(), y+gui.body.stepY()+gui.body.stepX(0.5)+frameY, x+textWidth(maxY+"")+gui.body.stepX(), y+gui.body.stepY());
 arrow(x+textWidth(maxY+"")+gui.body.stepX(0.5), y+gui.body.stepY()+frameY, x+xFrameLength-gui.body.stepX()-textWidth(labelX), y+gui.body.stepY()+frameY);
 stepX=stepY=1;
 gapX=rangeX*stepX/(maxX-minX);
 gapY=rangeY*stepY/(maxY-minY);
 intervalX=gapX;
 intervalY=gapY;
 if (maxX<100)
 while (gapX<=textWidth(maxX+"")*3.0/4) {
 stepX++;
 gapX=rangeX*stepX/(maxX-minX);
 } else
 while (gapX<=textWidth(maxX+"")) {
 stepX++;
 gapX=rangeX*stepX/(maxX-minX);
 }
 while (gapY<=gui.body.stepY()) {
 stepY++;
 gapY=rangeY*stepY/(maxY-minY);
 }
 strokeWeight(gui.unit());
 for (int i=1; i<=(maxX-minX)/stepX; i++)
 line(x+textWidth(maxY+"")+gui.body.stepX()+i*gapX, y+gui.body.stepY()+frameY, x+textWidth(maxY+"")+gui.body.stepX()+i*gapX, y+gui.body.stepY()+frameY+gui.body.stepX(0.5));
 for (int i=1; i<=(maxY-minY)/stepY; i++)
 line(x+textWidth(maxY+"")+gui.body.stepX(0.5), y+gui.body.stepY()+frameY-gapY*i, x+textWidth(maxY+"")+gui.body.stepX(), y+gui.body.stepY()+frameY-gapY*i);
 fill(gui.bodyColor[0].value);
 textAlign(CENTER, CENTER);
 for (int i=0; i<=(maxX-minX)/stepX; i++)
 text(i*stepX, x+textWidth(maxY+"")+gui.body.stepX()+i*gapX, y+gui.body.stepY(2)+frameY);
 textAlign(RIGHT, CENTER);
 for (int i=0; i<=(maxY-minY)/stepY; i++)
 text(i*stepY, x+textWidth(maxY+""), y+gui.body.stepY()+frameY-gapY*i);
 popStyle();
 }
 }*/
