class GUI {
  static final int SCALE=0, WIDTH=1, HEIGHT=2;
  int kind=-1;//cursor kind
  float angle, moveX, moveY, x, y, boxWidth, boxHeight;
  String _V="3.14159";
  boolean load, lock, showFPS, showMessage;
  String[] loadText={"Loading", "Loading.", "Loading..", "Loading..."}, message=new String[2];
  Font body, head, thisFont;
  Image title;
  Button confirm=new Button("Confirm");
  Image[] cover=new Image[2];
  Color mainColor=new Color(255, 255, 0, -1);
  SysColor backgroundColor=new SysColor(0), frameColor=new SysColor(255, 165, 0), baseColor=new SysColor(70, 70, 70), highlightColor=new SysColor(255, 255, 255);
  SysColor[] headColor={new SysColor(255, 255, 0), new SysColor(255, 0, 0), new SysColor(0, 255, 0), new SysColor(255, 0, 255)}, bodyColor={new SysColor(0, 255, 255), new SysColor(200, 200, 200), new SysColor(255, 165, 0)}, partColor={new SysColor(0, 255, 255), new SysColor(255, 0, 255), new SysColor(0, 255, 0), new SysColor(138, 43, 226), new SysColor(0, 255, 255)};
  int getWidth() {
    return 0.86*displayHeight*1920/1080>displayWidth?round(0.86*displayWidth):round(0.86*displayHeight*1920/1080);
  }
  int getHeight() {
    return 0.86*displayHeight*1920/1080>displayWidth?round(0.86*displayWidth*1080/1920):round(0.86*displayHeight);
  }
  float margin() {
    return thisFont.stepX(3)+textWidth("Welcome to DragonZ-WSN world!");
  }
  float logo() {
    pushStyle();
    imageMode(CENTER);
    cover[load?1:0].display(GUI.HEIGHT, width/2, height/5, height/2.5);
    fill(load?bodyColor[0].value:headColor[1].value);
    text("DragonZ", width/2, height/2.5-unit(40));
    title.display(GUI.HEIGHT, width/2, height/2.5-unit(10), unit(40));
    popStyle();
    return height/2.5;
  }
  float unit() {
    return unit(1);
  }
  float unit(float factor) {
    return height*factor/1080;
  }
  boolean active() {
    return !load||showMessage;
  }
  void initialize() {
    surface.setLocation((displayWidth-width)/2, round(0.035*displayHeight));
    surface.setResizable(true);
    surface.setTitle("Wireless Sensor Networks");
    body=new Font("AmericanTypewriter-Bold-24.vlw", 19);
    head=new Font("Apple-Chancery-48.vlw", 50);
    cover[0]=new Image("RedDragon.jpg");
    cover[1]=new Image("BlueDragon.jpg");
    title=new Image("Title.png");
    background(backgroundColor.value);
  }
  void display() {
    if (load) {
      if (showFPS)
        _FPS();
      if (showMessage)
        messageBox();
      if (kind>-1) {
        cursor(kind);
        kind=ARROW;
      } else if (kind==ARROW)
        kind=-1;
    } else
      loading();
  }
  void loading() {
    push();
    body.initialize();
    translate(width/2, logo());
    noStroke();
    fill(backgroundColor.value);
    rect(-width/2, 0, width, thisFont.stepY(2)+thisFont.gap());
    fill(headColor[2].value);
    textAlign(CENTER);
    text("Ver. "+_V, 0, thisFont.stepY());
    angle+=0.1;
    fill(0, 8);
    rect(-unit(15), thisFont.stepY(3), unit(30), unit(30));
    fill(32, 32, 255);
    ellipse(cos(angle)*unit(10), sin(angle)*unit(10)+thisFont.stepY(3)+unit(15), unit(10), unit(10));
    fill(bodyColor[2].value);
    text(loadText[frameCount/15%4], 0, thisFont.stepY(2));
    pop();
  }
  void messageBox() {
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
    confirm.buttonMode(CENTER);
    confirm.display(x, y+gui.thisFont.stepY(4)-gui.unit(4));
    textAlign(CENTER);
    fill(gui.headColor[2].value);
    text(message[1], x, y-boxHeight/2+gui.thisFont.stepY());
    popStyle();
  }
  void _FPS() {
    pushStyle();
    body.initialize();
    textAlign(RIGHT);
    fill(bodyColor[1].value);
    text(String.format("FPS: %.2f", frameRate), width-thisFont.stepX(), height-thisFont.stepY());
    popStyle();
  }
  void messageBox(String mainMessage, String metaMessage) {
    x=width/2;
    y=height/2;
    message[0]=mainMessage;
    message[1]=metaMessage;
    showMessage=true;
  }
  void keyPress() {
    if (key==ENTER||key==RETURN||key==' ')
      showMessage=false;
  }
  void mousePress() {
    lock=mouseX>x-boxWidth/2&&mouseX<x+boxWidth/2&&mouseY>y-boxHeight/2&&mouseY<y+boxHeight/2?true:false;
    moveX=mouseX-x;
    moveY=mouseY-y;
  }
  void mouseRelease() {
    lock=false;
    if (confirm.active())
      showMessage=false;
  }
  void mouseDrag() {
    if (lock) {
      x=mouseX-moveX;
      y=mouseY-moveY;
    }
  }
}
