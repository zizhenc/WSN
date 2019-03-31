class GUI {
  static final int SCALE=0, WIDTH=1, HEIGHT=2;
  volatile int thread;
  float angle;
  String _V="3.14159265";
  boolean mode;
  String[] loadText={"Loading", "Loading.", "Loading..", "Loading..."};
  Font body, head, thisFont;
  Image title;
  Image[] cover=new Image[2];
  Color mainColor=new Color(255, 255, 0, -1);
  SysColor[] colour={new SysColor(), new SysColor(255, 165, 0), new SysColor(255, 255, 255), new SysColor(0, 255, 255)}, headColor={new SysColor(255, 255, 0), new SysColor(255, 0, 0), new SysColor(0, 255, 0)}, bodyColor={new SysColor(0, 255, 255), new SysColor(200, 200, 200), new SysColor(255, 165, 0)}, partColor={new SysColor(240, 247, 212), new SysColor(255, 0, 255), new SysColor(0, 255, 0), new SysColor(138, 43, 226)};
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
    cover[gui.thread>0?1:0].display(GUI.HEIGHT, width/2, height/5, height/2.5);
    fill(gui.thread>0?bodyColor[0].value:headColor[1].value);
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
  void initialize() {
    surface.setLocation((displayWidth-width)/2, round(0.035*displayHeight));
    surface.setResizable(true);
    surface.setTitle("Wireless Sensor Networks");
    body=new Font("AmericanTypewriter-Bold-24.vlw", 18);
    head=new Font("ColonnaMT-60.vlw", 54);
    cover[0]=new Image("RedDragon.jpg");
    cover[1]=new Image("BlueDragon.jpg");
    title=new Image("Title.png");
    background(colour[0].value);
  }
  void resetColor() {
    if (mode) {
      mainColor.setValue(84, 84, 159);
      colour[0].setValue(255, 247, 217 );
      colour[1].setValue(51, 35, 5);
      colour[2].setValue(199, 175, 189);
      colour[3].setValue(45, 196, 166);
      headColor[0].setValue(111, 39, 45);
      headColor[2].setValue(26, 135, 0);
      bodyColor[0].setValue(51, 35, 5);
      bodyColor[1].setValue(107, 140, 106);
      bodyColor[2].setValue(51, 35, 5);
      partColor[0].setValue(0, 126, 255);
      partColor[1].setValue(255, 0, 255);
      partColor[2].setValue(252, 79, 115);
    } else {
      mainColor.setValue(255, 255, 0);
      colour[0].setValue(0);
      colour[1].setValue(255, 165, 0);
      colour[2].setValue(255, 255, 255);
      colour[3].setValue(0, 255, 255);
      headColor[0].setValue(255, 255, 0);
      headColor[1].setValue(255, 0, 0);
      headColor[2].setValue(0, 255, 0);
      bodyColor[0].setValue(0, 255, 255);
      bodyColor[1].setValue(200, 200, 200);
      bodyColor[2].setValue(255, 165, 0);
      partColor[0].setValue(240, 247, 212);
      partColor[1].setValue(255, 0, 255);
      partColor[2].setValue(0, 255, 0);
      partColor[3].setValue(138, 43, 226);
    }
  }
  void display() {
    push();
    body.initialize();
    translate(width/2, logo());
    noStroke();
    fill(colour[0].value);
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
}
