class DialogBox {
  Action action;
  int option;//reuse attribute, when box is active, it stores the number of options, otherwise it stores which option.
  boolean active, mode;//mode true has entry, mode false is messagebox
  float boxWidth, boxHeight, moveX, moveY, x, y;
  String[] message=new String[2];
  Button[] choice={new Button(), new Button(), new Button()};
  Radio entry=new Radio();
  DialogBox() {
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
    boxHeight=mode?max(entry.radioHeight+gui.thisFont.stepY(2)+choice[0].buttonHeight+gui.thisFont.gap(2), gui.thisFont.stepY(10)):gui.thisFont.stepY(10);
    boxWidth=boxHeight*1920/1080;
    rect(x, y, boxWidth, boxHeight, gui.unit(8), 0, gui.unit(8), 0);
    if (mode)
      entry.display(x-entry.radioWidth/2, y-boxHeight/2+gui.thisFont.stepY(2));
    else {
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
    }
    switch(option) {
    case 1:
      choice[0].display(x, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      break;
    case 2:
      choice[0].display(x-boxWidth/6, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[1].display(x+boxWidth/6, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      break;
    case 3:
      choice[0].display(x-boxWidth/4, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[1].display(x, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
      choice[2].display(x+boxWidth/4, y+boxHeight/2-choice[0].buttonHeight/2-gui.thisFont.gap());
    }
    textAlign(CENTER);
    fill(gui.headColor[2].value);
    text(message[1], x, y-boxHeight/2+gui.thisFont.stepY());
    popStyle();
  }
  void pop(LinkedList<String> items, String metaMessage, String...label) {
    pop(items, metaMessage, null, label);
  }
  void pop(LinkedList<String> items, String metaMessage, Action action, String...label) {
    mode=true;
    entry.setLabels(items);
    initialize(metaMessage, action, label);
  }
  void pop(String mainMessage, String metaMessage, Action action, String...label) {
    mode=false;
    message[0]=mainMessage;
    initialize(metaMessage, action, label);
  }
  void pop(String mainMessage, String metaMessage, String...label) {
    pop(mainMessage, metaMessage, null, label);
  }
  void initialize(String metaMessage, Action action, String...label) {
    x=width/2;
    y=height/2;
    this.action=action;
    message[1]=metaMessage;
    option=label.length;
    for (int i=0; i<label.length; i++)
      choice[i].label=label[i];
    active=true;
  }
  void keyPress() {
    if (option==1)
      if (key==ENTER||key==RETURN||key==' ') {
        if (action!=null)
          action.go();
        active=false;
      }
  }
  void mousePress() {
    entry.active();
    moveX=mouseX-x;
    moveY=mouseY-y;
  }
  void mouseRelease() {
    for (int i=0; active&&i<option; i++)
      if (choice[i].active()) {
        option=i;
        if (action!=null)
          action.go();
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
