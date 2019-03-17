class SystemPanel extends Panel {
  Switcher saveMode=new Switcher("Auto", "Manual"), colorMode=new Switcher("Demo", "Paper"), captureMode=new Switcher("Fullscreen", "Partial screen");
  Slider fps=new Slider("FPS", 1, 120, 1);
  Animation sonic=new GIF("Sonic", 8);
  PathBar savePath=new PathBar("Auto save path", "Results/"), screenshotPath=new PathBar("Screenshot path", "Screenshots/"), errorPath=new PathBar("Error log path", "Logs/");
  int pathIndex=-1;
  SystemPanel() {
    label="System";
  }
  void setting() {
    //saveMode.value=io.mode;
    //colorMode.value=gui.colorMode;
    captureMode.value=capture.mode;
    fps.setValue(frameRate);
  }
  void show() {
    float contentHeight=saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+savePath.pathHeight+screenshotPath.pathHeight+errorPath.pathHeight+gui.thisFont.gap(6);
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
    savePath.display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+gui.thisFont.gap(4), panelWidth-gui.thisFont.stepX(2));
    screenshotPath.display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+savePath.pathHeight+gui.thisFont.gap(5), panelWidth-gui.thisFont.stepX(2));
    errorPath.display(x+gui.thisFont.stepX(), y+panelHeight/2-contentHeight/2+saveMode.switchHeight+colorMode.switchHeight+captureMode.switchHeight+fps.sliderHeight+screenshotPath.pathHeight+errorPath.pathHeight+gui.thisFont.gap(6), panelWidth-gui.thisFont.stepX(2));
  }
  void keyPress() {
    savePath.keyPress();
    screenshotPath.keyPress();
    errorPath.keyPress();
  }
  void keyType() {
    savePath.keyType();
    screenshotPath.keyType();
    errorPath.keyType();
  }
  void mousePress() {
    savePath.mousePress();
    screenshotPath.mousePress();
    errorPath.mousePress();
    if (fps.active())
      frameRate(fps.value);
  }
  void mouseRelease() {
    if (captureMode.active())
      capture.mode=captureMode.value;
  }
}
