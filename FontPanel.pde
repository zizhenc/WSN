public class FontPanel extends Panel {
  Slider[] size=new Slider[]{new Slider("Size", 2, 72, 1), new Slider("Size", 1, 36, 1)};
  Button[] font=new Button[]{new Button("Choose font..."), new Button("Choose font...")};
  Button reset=new Button("Reset");
  int fontIndex;
  FontPanel() {
    label="Fonts";
    font[0].alignment=CENTER;
    font[1].alignment=CENTER  ;
    reset.alignment=CENTER;
  }
  void setting() {
    size[0].setValue(gui.head.size);
    size[1].setValue(gui.body.size);
  }
  void show() {
    fill(gui.headColor[2].value);
    textAlign(CENTER, BOTTOM);
    gui.head.initialize();
    text("Head", x+panelWidth/4, y+panelHeight/2-gui.body.gap(2)-font[0].buttonHeight);
    textAlign(CENTER, TOP);
    gui.body.initialize();
    text("Body", x+panelWidth/4, y+panelHeight/2+size[1].sliderHeight/2+gui.thisFont.gap());
    size[0].display(x+panelWidth/2+gui.thisFont.stepX(), y+panelHeight/2-gui.thisFont.gap(2)-font[0].buttonHeight-size[0].sliderHeight, panelWidth/2-gui.thisFont.stepX(2));
    font[0].display(x+panelWidth*3/4, y+panelHeight/2-gui.thisFont.gap()-font[0].buttonHeight/2);
    size[1].display(x+panelWidth/2+gui.thisFont.stepX(), y+panelHeight/2+gui.thisFont.gap(), panelWidth/2-gui.thisFont.stepX(2));
    font[1].display(x+panelWidth*3/4, y+panelHeight/2+gui.thisFont.gap(2)+size[1].sliderHeight+font[1].buttonHeight/2);
    reset.display(x+panelWidth/2, y+panelHeight*3/4);
  }
  void mousePress() {
    if (size[0].active())
      gui.head.size=round(size[0].value);
    if (size[1].active())
      gui.body.size=round(size[1].value);
  }
  void mouseRelease() {
    for (int i=0; i<font.length; i++)
      if (font[i].active())
        selectInput("Choose a font file:", "setFont", new File(System.getProperty("user.dir")+System.getProperty("file.separator")+'.'), this);
    if (reset.active()) {
      gui.head.size=54;
      gui.head.font=loadFont("ColonnaMT-60.vlw");
      gui.body.size=18;
      gui.body.font=loadFont("AmericanTypewriter-Bold-24.vlw");
      setting();
    }
  }
  void setFont(File selection) {
    if (selection!=null)
      if (fontIndex==0)
        gui.head.font=loadFont(selection.getAbsolutePath());
      else
        gui.body.font=loadFont(selection.getAbsolutePath());
  }
}
