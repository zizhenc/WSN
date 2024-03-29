public class SystemSettings extends Setting implements Screen {
  int index;
  Switcher saveMode=new Switcher("Auto [s]", "Manual [s]"), colorMode=new Switcher("Demo [c]", "Paper [c]"), captureMode=new Switcher("Fullscreen [x]", "Partial screen [x]");
  Slider fps=new Slider("FPS", 1, 144, 1);
  Animation sonic=new GIF("Sonic", 8);
  PathBar[] bar={new PathBar("Default save path", io.path), new PathBar("Screenshot path", capture.path), new PathBar("Error log path", error.path)};
  Button[] button={new Button("Select"), new Button("Select"), new Button("Select")};
  Switcher[] toggle={saveMode, colorMode, captureMode};
  SystemSettings(WSN wsn) {
    label="System";
    video=new Video(wsn, "System.mov");
  }
  void initialize() {
    saveMode.value=io.mode;
    colorMode.value=gui.mode;
    captureMode.value=capture.mode;
    fps.setValue(frameRate);
    tunes.addLast(fps);
  }
  void show(float x, float y, float panelWidth, float panelHeight) {
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
  void moreKeyReleases() {
    if (!bar[0].active&&!bar[1].active&&!bar[2].active)
      switch(Character.toLowerCase(key)) {
      case 'c':
        colorMode.commit();
        gui.mode=colorMode.value;
        gui.resetColor();
        break;
      case 's':
        saveMode.commit();
        io.mode=saveMode.value;
        break;
      case 'x':
        captureMode.commit();
        capture.mode=captureMode.value;
      }
    if (navigation.nextPage!=22)
      video.pause();
  }
  void moreKeyPresses() {
    for (PathBar path : bar)
      path.keyPress();
  }
  void keyType() {
    for (PathBar path : bar)
      path.keyType();
  }
  void moreMousePresses() {
    for (PathBar path : bar)
      path.mousePress();
    if (fps.active())
      frameRate(fps.value);
  }
  void moreMouseReleases() {
    for (Switcher mode : toggle)
      if (mode.active())
        mode.commit(); 
    if (captureMode.active())
      capture.mode=captureMode.value; 
    if (colorMode.active()) {
      gui.mode=colorMode.value; 
      gui.resetColor();
    }
    if (saveMode.active())
      io.mode=saveMode.value; 
    for (int i=0; i<button.length; i++)
      if (button[i].active()) {
        index=i; 
        selectFolder("Select a folder", "setPath", new File(System.getProperty("user.dir")), this);
      }
    if (navigation.nextPage!=22)
      video.pause();
  }
  void setPath(File selection) {
    if (selection != null)
      bar[index].path.setValue(selection.getAbsolutePath());
  }
}
