abstract class Charts {
  float centralX, centralY, centralZ, eyeX, eyeY, eyeZ;
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  Switcher play=new Switcher("Stop", "Play"), showMeasurement=new Switcher("Measurement", "Measurement");
  Slider edgeWeight=new Slider("Edge weight"), interval=new Slider("Display interval", 0);
  Button[] button={new Button("Reset"), new Button("Restore"), new Button("Screenshot")};
  Chart chart;
  Charts() {
    switches.addLast(play);
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
    tunes.addLast(interval);
  }
  abstract void show();
  abstract void moreKeyReleases();
  abstract void moreMouseReleases();
  void display() {
    pushStyle();
    gui.body.initialize();
    controls();
    pushMatrix();
    camera(width/2+eyeX, height/2+eyeY, (height/2)/tan(PI/6.0)+eyeZ, centralX+width/2, centralY+height/2, centralZ, 0, 1, 0);
    chart.showFrame(gui.thisFont.gap(), gui.thisFont.gap(), width-gui.margin()-gui.thisFont.gap(), height-gui.thisFont.gap(2)-navigation.barHeight);
    if (showMeasurement.value)
      chart.showMeasurement();
    show();
    popMatrix();
    navigation.display();
    popStyle();
  }
  void controls() {
    fill(gui.headColor[1].value);
    text("Welcome to DragonZ-WSN world!", width-gui.margin(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Controls:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(2));
    for (int i=0; i<button.length; i++)
      button[i].display(GUI.WIDTH, width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(2)+gui.thisFont.gap(i+1)+button[0].buttonHeight*i, gui.margin()-gui.thisFont.stepX(3));
    fill(gui.headColor[2].value);
    text("Switches:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap()));
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+play.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
    fill(gui.headColor[2].value);
    text("Labels:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(6)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*tunes.size());
    chart.showLabels(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(7)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(play.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+edgeWeight.sliderHeight*tunes.size());
  }
  void relocate() {
    centralX=centralY=centralZ=eyeX=eyeY=eyeZ=0;
  }
  void keyPress() {
    navigation.keyPress();
    if (!navigation.active())
      switch(Character.toLowerCase(key)) {
      case 'a':
        eyeX-=40;
        break;
      case 'd':
        eyeX+=40;
        break;
      case 's':
        eyeZ+=10;
        break;
      case 'w':
        eyeZ-=10;
        break;
      case CODED:
        switch(keyCode) {
        case DOWN:
          eyeY-=10;
          centralY-=10;
          break;
        case UP:
          eyeY+=10;
          centralY+=10;
          break;
        case RIGHT:
          eyeX-=10;
          centralX-=10;
          break;
        case LEFT:
          eyeX+=10;
          centralX+=10;
        }
      }
  }
  void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'x':
        capture.store();
        break;
      case 'g':
        relocate();
        break;
      case 'm':
        showMeasurement.value=!showMeasurement.value;
        break;
      case 'r':
        chart.reset();
        break;
      case 'p':
        play.value=!play.value;
        chart.play=play.value;
      }
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker part=i.next();
        if (key==char(i.previousIndex()+48)) {
          part.value=!part.value;
          chart.setPlot(i.previousIndex(), part.value);
        }
      }
      moreKeyReleases();
    }
  }
  void keyType() {
  }
  void mousePress() {
    navigation.mousePress();
    if (!navigation.active()) {
      edgeWeight.active();
      if (interval.active())
        chart.setInterval(interval.value);
      moreMousePresses();
    }
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      showMeasurement.active();
      if (play.active())
        chart.play=play.value;
      if (button[0].active())
        chart.reset();
      if (button[1].active())
        relocate();
      if (button[2].active())
        capture.store();
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker checker=i.next();
        if (checker.active())
          chart.setPlot(i.previousIndex(), checker.value);
      }
      moreMouseReleases();
    }
  }
  void mouseDrag() {
    if (mouseButton==RIGHT) {
      eyeX-=mouseX-pmouseX;
      eyeY-=mouseY-pmouseY;
    }
  }
  void mouseScroll(MouseEvent event) {
    eyeZ+=event.getCount()*10;
  }
  void moreMousePresses() {
  }
}
