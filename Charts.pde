abstract class Charts {
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  Switcher showMeasurement=new Switcher("Measurement", "Measurement");
  Slider edgeWeight=new Slider("Edge weight");
  Button screenshot=new Button("Screenshot");
  Capture capture=new Capture();
  Chart chart;
  Charts() {
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
  }
  void initialize() {
    chart.deployColors();
  }
  void moreKeyReleases() {
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    controls();
    chart.display(gui.thisFont.gap(), gui.thisFont.gap(), width-gui.margin()-gui.thisFont.gap(), height-gui.thisFont.gap(2)-navigation.barHeight);
    popStyle();
    navigation.display();
    if (capture.active)
      capture.display();
  }
  void controls() {
    fill(gui.headColor[1].value);
    text("Welcome to DragonZ-WSN world!", width-gui.margin(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Controls:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(2));
    screenshot.display(GUI.WIDTH, width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(2)+gui.thisFont.gap(), gui.margin()-gui.thisFont.stepX(3));
    fill(gui.headColor[2].value);
    text("Switches:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(3)+(screenshot.buttonHeight+gui.thisFont.gap()));
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+screenshot.buttonHeight+gui.thisFont.gap()+showMeasurement.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+screenshot.buttonHeight+gui.thisFont.gap()+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+screenshot.buttonHeight+gui.thisFont.gap()+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+screenshot.buttonHeight+gui.thisFont.gap()+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+screenshot.buttonHeight+gui.thisFont.gap()+switches.size()*(showMeasurement.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
  }
  void keyPress() {
    if (!capture.active)
      navigation.keyPress();
  }
  void keyRelease() {
    if (capture.active)
      capture.keyRelease();
    else {
      navigation.keyRelease();
      if (!navigation.active()) {
        switch(Character.toLowerCase(key)) {
        case 'x':
          capture.store();
          break;
        case 'm':
          showMeasurement.value=!showMeasurement.value;
        }
        int i=0;
        for (Checker part : parts) {
          if (key==char(i+48))
            part.value=!part.value;
          i++;
        }
        moreKeyReleases();
      }
    }
  }
  void keyType() {
  }
  void mousePress() {
    if (capture.active)
      capture.mousePress();
    else
      navigation.mousePress();
  }
  void mouseRelease() {
    if (!capture.active) {
      navigation.mouseRelease();
      if (!navigation.active()) {
        for (Slider slider : tunes) {
          if (slider.activeLeft())
            slider.decreaseValue();
          if (slider.activeRight())
            slider.increaseValue();
        }
        for (Switcher switcher : switches)
          if (switcher.active())
            switcher.value=!switcher.value;
        for (Checker checker : parts)
          if (checker.active())
            checker.value=!checker.value;
        if (screenshot.active())
          capture.store();
      }
    }
  }
  void mouseDrag() {
    if (capture.active)
      capture.mouseDrag();
  }
  void mouseScroll(MouseEvent event) {
  }
}
