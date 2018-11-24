abstract class New implements Screen {
  int index, _N;
  float logoSize;
  double r;
  ArrayList<Input> inputs=new ArrayList<Input>();
  HashMap<String, Input> inputLibrary=new HashMap<String, Input>();
  Topology topology;
  Animation animation;
  abstract void enter()throws Exception;
  New() {
    inputLibrary.put("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue...", new Input("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."));
    inputLibrary.put("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ", new Input("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): "));
    inputLibrary.put("Enter vertex number: ", new Input("Enter vertex number: "));
    inputLibrary.put("Provide threshold (r or avg): ", new Input("Provide threshold (r or avg): "));
    inputLibrary.put("r=", new Input("r="));
    inputLibrary.put("avg≈", new Input("avg≈"));
    inputs.add(inputLibrary.get("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."));
  }
  void display() {
    pushStyle();
    pushMatrix();
    gui.body.initialize();
    logoSize=gui.logo();
    translate(width/2, logoSize);
    fill(gui.bodyColor[2].value);
    for (int i=0; i<inputs.size(); i++)
      if (i!=index)
        inputs.get(i).display(-textWidth(inputs.get(i).prompt+inputs.get(i).word)/2, gui.thisFont.stepY(1+i));
    inputs.get(index).cin(-textWidth(inputs.get(index).prompt+inputs.get(index).word)/2, gui.thisFont.stepY(1+index));
    imageMode(CENTER);
    animation.display(GUI.HEIGHT, 0, height-logoSize-navigation.barHeight-height/10, height/5);
    popMatrix();
    popStyle();
    navigation.display();
  }
  void setting() {
    for (int i=inputs.size()-1; i>0; i--)
      inputs.remove(i).clean();
    index=0;
  }
  void defaultEnter(String prompt, String word, String nextPrompt) throws Exception {
    if (prompt.equals("Press "+(System.getProperty("os.name").contains("Windows")?"Enter":"Return")+" to continue..."))
      commit("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ");
    else if (prompt.equals("Choose a topology (Square, Disk, Triangle, Sphere, Torus, Bottle, Cube, Ball): ")) {
      if (word.contains("square"))
        topology=new Square();
      else if (word.contains("disk"))
        topology=new Disk();
      else if (word.contains("triangle"))
        topology=new Triangle();
      else if (word.contains("sphere"))
        topology=new Sphere();
      else if (word.contains("torus"))
        topology=new Torus();
      else if (word.contains("bottle"))
        topology=new Bottle();
      else if (word.contains("cube"))
        topology=new Cube();
      else if (word.contains("ball"))
        topology=new Ball();
      else
        throw new Exception('\"'+word+"\" - No such topology");
      commit("Enter vertex number: ");
    } else if (prompt.equals("Enter vertex number: ")) {
      _N=Integer.parseInt(word);
      if (_N<0)
        throw new NumberFormatException('\"'+inputs.get(index).word+"\" - Invalid 'N' value"); 
      commit("Provide threshold (r or avg): ");
    } else if (prompt.equals("Provide threshold (r or avg): "))
      if (word.contains("r"))
        commit("r=");
      else if (word.contains("avg"))
        commit("avg≈");
      else
        throw new Exception('\"'+inputs.get(index).word+"\" - No such threshold");
    else if (prompt.equals("r=")) {
      r=Double.parseDouble(word);
      if (r<0||r>topology.range)
        throw new NumberFormatException('\"'+inputs.get(index).word+"\" - Invalid 'r' value");
      inputs.get(index).word+=String.format(" (avg≈%.2f)", topology.getAvg(r, _N));
      commit(nextPrompt);
    } else if (prompt.equals("avg≈")) {
      double avgDegree=Double.parseDouble(word);
      if (avgDegree<0||avgDegree>_N-1)
        throw new NumberFormatException('\"'+inputs.get(index).word+"\" - Invalid average degree"); 
      r=topology.getR(avgDegree, _N);
      inputs.get(index).word+=String.format(" (r=%.2f)", r);
      commit(nextPrompt);
    } else
      throw new Exception('\"'+inputs.get(index).word+"\" - Nonsense message");
  }
  void commit(String prompt) {
    for (int i=0; i<index; i++)
      inputs.get(i).abstain();
    inputs.get(index).commit();
    for (int i=inputs.size()-1; i>index; i--)
      inputs.remove(i).clean();
    inputs.add(inputLibrary.get(prompt));
    index++;
  }
  void keyPress() {
    navigation.keyPress();
    if (!navigation.active()) {
      inputs.get(index).keyPress();
      switch(key) {
      case ENTER:
      case RETURN:
        try {
          enter();
        }
        catch (Exception e) {
          error.logOut("Menu input "+e.getMessage());
        }
        break;
      case CODED:
        switch(keyCode) {
        case UP:
          if (index>0)
            index--;
          else
            index=inputs.size()-1;
          break;
        case DOWN:
          index=(index+1)%inputs.size();
        }
      }
    }
  }
  void keyRelease() {
    navigation.keyRelease();
  }
  void keyType() {
    if (!navigation.active())
      inputs.get(index).keyType();
  }
  void mousePress() {
    navigation.mousePress();
    for (Input input : inputs)
      if (input.active())
        input.mousePress();
  }
  void mouseRelease() {
    navigation.mouseRelease();
    if (!navigation.active())
      for (int i=0; i<inputs.size(); i++)
        if (i!=index&&inputs.get(i).active())
          index=i;
  }
  void mouseDrag() {
  }
  void mouseScroll(MouseEvent event) {
  }
}
