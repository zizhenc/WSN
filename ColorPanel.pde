class ColorPanel extends Panel {
  Slider r=new Slider("Red", 0, 255, 1), g=new Slider("Green", 0, 255, 1), b=new Slider("Blue", 0, 255, 1);
  Radio colors=new Radio("Main", "Background", "Frame", "Base", "Highlight", "Text header 0", "Text header 1", "Text header 2", "Text body 0", "Text body 1", "Text body 2", "Graph part 0", "Graph part 1", "Graph part 2", "Graph part 3");
  Button reset=new Button("Reset");
  ColorPanel() {
    label="Colors";
    reset.alignment=CENTER;
  }
  void setting() {
    r.setValue(getColor().r);
    g.setValue(getColor().g);
    b.setValue(getColor().b);
  }
  void show() {
    r.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1, y+panelHeight/2+gui.thisFont.gap(), (panelWidth*3/4-colors.radioWidth/2)*0.8);
    g.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1, y+panelHeight/2+r.sliderHeight+gui.thisFont.gap(2), (panelWidth*3/4-colors.radioWidth/2)*0.8);
    b.display(x+(panelWidth*3/4-colors.radioWidth/2)*0.1, y+panelHeight/2+r.sliderHeight+b.sliderHeight+gui.thisFont.gap(3), (panelWidth*3/4-colors.radioWidth/2)*0.8);
    colors.display(x+panelWidth*3/4-colors.radioWidth/2, y+panelHeight/2-colors.radioHeight/2);
    fill(r.value, g.value, b.value);
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    float diameter=panelWidth<panelHeight?panelWidth/3:panelHeight/3;
    circle(x+panelWidth*3/8-colors.radioWidth/4, y+panelHeight/2-diameter/2, diameter);
    reset.display(x+panelWidth*3/8-colors.radioWidth/4, y+panelHeight/2+r.sliderHeight+b.sliderHeight+g.sliderHeight+gui.thisFont.gap(2)+reset.buttonHeight);
  }
  void mousePress() {
    if (r.active()||g.active()||b.active())
      getColor().setValue(round(r.value), round(g.value), round(b.value));
  }
  void mouseRelease() {
    if (colors.active())
      setting();
    if (reset.active()) {
      gui.resetColor();
      setting();
    }
  }
  SysColor getColor() {
    switch(colors.value) {
    case 0:
      return gui.mainColor;
    case 1:
      return gui.backgroundColor;
    case 2:
      return gui.frameColor;
    case 3:
      return gui.baseColor;
    case 4:
      return gui.highlightColor;
    }
    if (colors.value<8)
      return gui.headColor[colors.value-5];
    else if (colors.value<11)
      return gui.bodyColor[colors.value-8];
    else
      return gui.partColor[colors.value-11];
  }
}
