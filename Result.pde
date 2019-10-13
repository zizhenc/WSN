abstract class Result {
  float centralX, centralY, centralZ, eyeX, eyeY, eyeZ, spinX, spinY, spinZ;
  String[] word;
  Slider nodeWeight=new Slider("Node weight"), edgeWeight=new Slider("Edge weight");
  Button[] button={new Button("Restore"), new Button("Screenshot")};
  Switcher spin=new Switcher("Spin", "Spin"), showNode=new Switcher("Node", "Node"), showEdge=new Switcher("Edge", "Edge"), projection=new Switcher("Orthographic", "Perspective");
  LinkedList<Slider> tunes=new LinkedList<Slider>();
  LinkedList<Checker> parts=new LinkedList<Checker>();
  LinkedList<Switcher> switches=new LinkedList<Switcher>();
  abstract void data();
  abstract void show();
  Result() {
    switches.addLast(projection);
    switches.addLast(spin);
    switches.addLast(showNode);
    switches.addLast(showEdge);
    tunes.addLast(nodeWeight);
    tunes.addLast(edgeWeight);
  }
  void initialize() {
    spin.value=graph.topology.value<4?false:true;
    nodeWeight.setPreference(gui.unit(0.005), gui.unit(0.0005), gui.unit(0.01), gui.unit(0.00025), gui.unit(1000));
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
  }
  void display() {
    pushStyle();
    gui.body.initialize();
    data();
    controls();
    pushMatrix();
    camera(eyeX, eyeY, height*(float)graph.topology.yRange+eyeZ, centralX, centralY, centralZ, 0, 1, 0);
    scale(height);
    if (spin.value)
      spinY+=0.002;
    rotateX(spinX);
    rotateY(spinY);
    rotateZ(spinZ);
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
    for (ListIterator<Switcher> i=switches.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(3)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+spin.switchHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Parts:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap()));
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(4)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.getFirst().checkerHeight*i.previousIndex()+gui.thisFont.gap(i.nextIndex())));
    fill(gui.headColor[2].value);
    text("Tunes:", width-gui.margin()+gui.thisFont.stepX(), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap()));
    for (ListIterator<Slider> i=tunes.listIterator(); i.hasNext(); i.next().display(width-gui.margin()+gui.thisFont.stepX(2), gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+nodeWeight.sliderHeight*i.previousIndex(), gui.margin()-gui.thisFont.stepX(3)));
    moreControls(gui.thisFont.stepY(5)+button.length*(button[0].buttonHeight+gui.thisFont.gap())+switches.size()*(spin.switchHeight+gui.thisFont.gap())+parts.size()*(parts.getFirst().checkerHeight+gui.thisFont.gap())+tunes.size()*nodeWeight.sliderHeight);
  }
  void relocate() {
    spinX=spinY=spinZ=centralX=centralY=centralZ=eyeX=eyeY=eyeZ=0;
  }
  void moreKeyPresses() {
  }
  void moreKeyReleases() {
  }
  void moreMousePresses() {
  }
  void moreMouseReleases() {
  }
  void moreControls(float y) {
  }
  void displayNode(Vertex node) {
    if (projection.value)
      strokeWeight(nodeWeight.value+(modelZ((float)node.x, (float)node.y, (float)node.z)-modelZ(0, 0, 0))/height*nodeWeight.value);
    else
      strokeWeight(nodeWeight.value);
    point((float)node.x, (float)node.y, (float)node.z);
  }
  void keyPress() {
    navigation.keyPress();
    if (!navigation.active()) {
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
      moreKeyPresses();
    }
  }
  void keyRelease() {
    navigation.keyRelease();
    if (!navigation.active()) {
      switch(Character.toLowerCase(key)) {
      case 'e':
        showEdge.commit();
        break;
      case 'x':
        capture.store();
        break;
      case 'g':
        relocate();
        break;
      case 'q':
        spin.commit();
        break;
      case 'n':
        showNode.commit();
      }
      for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
        Checker part=i.next();
        if (key==char(i.previousIndex()+48))
          part.commit();
      }
      moreKeyReleases();
    }
  }
  void keyType() {
  }
  void mousePress() {
    navigation.mousePress();
    if (!navigation.active()) {
      for (Slider tune : tunes)
        if (tune.active())
          tune.commit();
      moreMousePresses();
    }
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active()) {
      for (Switcher toggle : switches)
        if (toggle.active())
          toggle.commit();
      for (Checker checker : parts)
        if (checker.active())
          checker.commit();
      if (button[0].active())
        relocate();
      if (button[1].active())
        capture.store();
      moreMouseReleases();
    }
  }
  void mouseDrag() {
    if (mouseButton==LEFT) {
      spinY+=(mouseX - pmouseX)*0.002;
      spinX+=(pmouseY - mouseY)*0.002;
    } else if (mouseButton==RIGHT) {
      eyeX-=mouseX-pmouseX;
      eyeY-=mouseY-pmouseY;
    }
  }
  void mouseScroll(MouseEvent event) {
    eyeZ+=event.getCount()*10;
  }
}
