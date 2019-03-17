class MessageBox {
  boolean active, lock;
  float boxWidth, boxHeight, moveX, moveY, x, y;
  String[] message=new String[2];
  Button confirm=new Button("Confirm");
  MessageBox() {
    confirm.alignment=CENTER;
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    fill(gui.baseColor.value, 100);
    rectMode(CENTER);
    boxHeight=gui.thisFont.stepY(10);
    boxWidth=boxHeight*1366/768;
    rect(x, y, boxWidth, boxHeight, gui.unit(18), 0, gui.unit(18), 0);
    if (textWidth(message[0]+"  ")>boxWidth) {
      String[] word=message[0].split(" ");
      float count=gui.thisFont.stepX();
      message[0]="";
      for (String str : word) {
        count+=textWidth(str+' ');
        if (count>boxWidth) {
          message[0]+=System.getProperty("line.separator");
          count=gui.thisFont.stepX()+textWidth(str+' ');
        }
        message[0]+=str+' ';
      }
    }
    textAlign(LEFT, CENTER);
    fill(gui.bodyColor[0].value);
    text(message[0], x-boxWidth/2+gui.thisFont.stepX(), y);
    confirm.display(x, y+gui.thisFont.stepY(4)-gui.unit(4));
    textAlign(CENTER);
    fill(gui.headColor[2].value);
    text(message[1], x, y-boxHeight/2+gui.thisFont.stepY());
    popStyle();
  }
  void pop(String mainMessage, String metaMessage) {
    x=width/2;
    y=height/2;
    message[0]=mainMessage;
    message[1]=metaMessage;
    active=true;
  }
  void keyPress() {
    if (key==ENTER||key==RETURN||key==' ')
      active=false;
  }
  void mousePress() {
    if (mouseX>x-boxWidth/2&&mouseX<x+boxWidth/2&&mouseY>y-boxHeight/2&&mouseY<y+boxHeight/2)
      lock=true;
    moveX=mouseX-x;
    moveY=mouseY-y;
  }
  void mouseRelease() {
    lock=false;
    if (confirm.active())
      active=false;
  }
  void mouseMove() {
    if (lock) {
      x=mouseX-moveX;
      y=mouseY-moveY;
    }
  }
}
