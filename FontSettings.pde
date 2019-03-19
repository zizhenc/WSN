public class FontSettings extends Setting implements Screen {
  Slider[] size=new Slider[]{new Slider("Size", 2, 72, 1), new Slider("Size", 1, 36, 1)};
  Button[] font=new Button[]{new Button("Choose font..."), new Button("Choose font...")};
  Button reset=new Button("Reset");
  int index;
  FontSettings (WSN wsn) {
    video=new Video(wsn, "Fonts.mov");
    label="Fonts";
    font[0].alignment=CENTER;
    font[1].alignment=CENTER  ;
    reset.alignment=CENTER;
  }
  void initialize() {
    size[0].setValue(gui.head.size);
    size[1].setValue(gui.body.size);
  }
  void show(float x, float y, float panelWidth, float panelHeight) {
    fill(gui.headColor[2].value);
    textAlign(CENTER, BOTTOM);
    gui.head.initialize();
    text("Head", x+panelWidth/4, y+panelHeight/2-gui.body.gap(2)-font[0].buttonHeight);
    float textLength=textWidth("Head");
    textAlign(CENTER, TOP);
    gui.body.initialize();
    text("Body", x+panelWidth/4, y+panelHeight/2+size[1].sliderHeight/2+gui.thisFont.gap());
    if (textWidth("Body")>textLength)
      textLength=textWidth("Body");
    size[0].display(x+panelWidth/2, y+panelHeight/2-gui.thisFont.gap(2)-font[0].buttonHeight-size[0].sliderHeight, panelWidth/4+textLength/2);
    font[0].display(x+panelWidth*5/8+textLength/4, y+panelHeight/2-gui.thisFont.gap()-font[0].buttonHeight/2);
    size[1].display(x+panelWidth/2, y+panelHeight/2+gui.thisFont.gap(), panelWidth/4+textLength/2);
    font[1].display(x+panelWidth*5/8+textLength/4, y+panelHeight/2+gui.thisFont.gap(2)+size[1].sliderHeight+font[1].buttonHeight/2);
    reset.display(x+panelWidth/2, y+panelHeight*3/4);
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='r') {
      gui.head.size=54;
      gui.head.font=loadFont("ColonnaMT-60.vlw");
      gui.body.size=18;
      gui.body.font=loadFont("AmericanTypewriter-Bold-24.vlw");
      initialize();
    }
  }
  void moreMousePresses() {
    if (size[0].active())
      gui.head.size=round(size[0].value);
    if (size[1].active())
      gui.body.size=round(size[1].value);
  }
  void moreMouseReleases() {
    for (int i=0; i<font.length; i++)
      if (font[i].active()) {
        index=i;
        selectInput("Choose a font file:", "setFont", new File(System.getProperty("user.dir")+System.getProperty("file.separator")+'.'), this);
      }
    if (reset.active()) {
      gui.head.size=54;
      gui.head.font=loadFont("ColonnaMT-60.vlw");
      gui.body.size=18;
      gui.body.font=loadFont("AmericanTypewriter-Bold-24.vlw");
      initialize();
    }
    if (navigation.nextPage!=22)
      video.pause();
  }
  void setFont(File selection) {
    if (selection!=null)
      if (index==0)
        gui.head.font=loadFont(selection.getAbsolutePath());
      else
        gui.body.font=loadFont(selection.getAbsolutePath());
  }
}
