class MessageBox {
  int status;
  boolean active;
  float boxWidth, boxHeight, moveX, moveY, x, y;
  String[] message=new String[2];
  Button[] choice={new Button(), new Button(), new Button()};
  MessageBox() {
    for (int i=0; i<choice.length; i++)
      choice[i].alignment=CENTER;
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    fill(gui.colour[2].value, 50);
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
    switch(status) {
    case 1:
      choice[0].display(x, y+gui.thisFont.stepY(4)-gui.unit(4));
      break;
    case 2:
      choice[0].display(x-boxWidth/6, y+gui.thisFont.stepY(4)-gui.unit(4));
      choice[1].display(x+boxWidth/6, y+gui.thisFont.stepY(4)-gui.unit(4));
      break;
    case 3:
      choice[0].display(x-boxWidth/4, y+gui.thisFont.stepY(4)-gui.unit(4));
      choice[1].display(x, y+gui.thisFont.stepY(4)-gui.unit(4));
      choice[2].display(x+boxWidth/4, y+gui.thisFont.stepY(4)-gui.unit(4));
    }
    textAlign(CENTER);
    fill(gui.headColor[2].value);
    text(message[1], x, y-boxHeight/2+gui.thisFont.stepY());
    popStyle();
  }
  void pop(String mainMessage, String metaMessage, String...label) {
    x=width/2;
    y=height/2;
    message[0]=mainMessage;
    message[1]=metaMessage;
    status=label.length;
    for (int i=0; i<label.length; i++)
      choice[i].label=label[i];
    active=true;
  }
  void keyPress() {
    if (key==ENTER||key==RETURN||key==' ')
      active=false;
  }
  void mousePress() {
    moveX=mouseX-x;
    moveY=mouseY-y;
  }
  void mouseRelease() {
    for (int i=0; active&&i<status; i++)
      if (choice[i].active()) {
        status=i;
        active=false;
      }
  }
  void mouseDrag() {
    if (mouseX>x-boxWidth/2&&mouseX<x+boxWidth/2&&mouseY>y-boxHeight/2&&mouseY<y+boxHeight/2) {
      x=mouseX-moveX;
      y=mouseY-moveY;
    }
  }
}
