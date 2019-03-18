public class SystemPanel extends Panel {
  int index;
  Switcher saveMode=new Switcher("Auto", "Manual"), colorMode=new Switcher("Demo", "Paper"), captureMode=new Switcher("Fullscreen", "Partial screen");
  Slider fps=new Slider("FPS", 1, 120, 1);
  Animation sonic=new GIF("Sonic", 8);
  PathBar[] bar=new PathBar[]{new PathBar("Default save path", capture.path), new PathBar("Screenshot path", capture.path), new PathBar("Error log path", error.path)};
  Button[] button=new Button[]{new Button("Select"), new Button("Select"), new Button("Select")};
  SystemPanel() {
    label="System";
  }
  void setting() {
    //saveMode.value=io.mode;
    colorMode.value=gui.mode;
    captureMode.value=capture.mode;
    fps.setValue(frameRate);
  }
  void show() {
    float contentHeight=saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[0].barHeight*bar.length+gui.thisFont.gap(3+bar.length);
    fill(gui.headColor[2].value);
    textAlign(LEFT, CENTER);
    text("Save mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight/2);
    saveMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2);
    text("Color mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+gui.thisFont.gap()+colorMode.switchHeight/2);
    colorMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+gui.thisFont.gap());
    text("Screenshot mode: ", x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+gui.thisFont.gap(2)+captureMode.switchHeight/2);
    captureMode.display(x+gui.thisFont.stepX(2)+textWidth("Screenshot mode: "), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+gui.thisFont.gap(2));
    fps.display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+gui.thisFont.gap(3), panelWidth/2-gui.thisFont.stepX());
    sonic.display(GUI.HEIGHT, x+panelWidth/2+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+gui.thisFont.gap(3), fps.sliderHeight);
    for (int i=0; i<bar.length; i++) {
      bar[i].display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[i].barHeight*i+gui.thisFont.gap(4+i), panelWidth-gui.thisFont.stepX(3)-button[i].buttonWidth);
      button[i].display(GUI.HEIGHT, x+panelWidth-button[0].buttonWidth-gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+bar[i].barHeight*i+gui.thisFont.gap(4+i)+bar[i].pathHeight, bar[i].pathHeight);
    }
  }
  void keyPress() {
    for (PathBar path : bar)
      path.keyPress();
  }
  void keyType() {
    for (PathBar path : bar)
      path.keyType();
  }
  void mousePress() {
    for (PathBar path : bar)
      path.mousePress();
    if (fps.active())
      frameRate(fps.value);
  }
  void mouseRelease() {
    if (captureMode.active())
      capture.mode=captureMode.value;
    if (colorMode.active()) {
      gui.mode=colorMode.value;
      gui.resetColor();
    }
    for (int i=0; i<button.length; i++)
      if (button[i].active()) {
        index=i;
        selectFolder("Select a folder", "setPath", new File(System.getProperty("user.dir")), this);
      }
  }
  void setPath(File selection) {
    if (selection != null)
      bar[index].path.setValue(selection.getAbsolutePath());
  }
}
