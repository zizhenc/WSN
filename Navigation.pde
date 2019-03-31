class Navigation {
  int page, nextPage, option, end=-420;
  int[] readyPage={-1, -1, -1};
  boolean ready, auto, lock;//lock item controled by keyboard
  float itemLength, subItemLength, barWidth, barHeight;
  LinkedList<String>[] items=new LinkedList[]{new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>(), new LinkedList<String>()};
  String[] itemTarget={"New demonstration [3]", "Save primary set summary [4]", "Primary independent sets [3]", "Smallest-last coloring bipartites [7]", "Degree distribution histogram [1]", "System settings [2]", "Documentation [1]"};//itemTarget means the longest item (in text) among the whole menu list.
  Navigation() {
    items[0].addFirst("New graph [1]");//103
    items[0].addFirst("New computation [2]");//102
    items[0].addFirst("New demonstration [3]");//101
    items[0].addFirst("New [N]");//100
    items[1].addFirst("Load graph [1]");//206
    items[1].addFirst("Save graph [2]");//205
    items[1].addFirst("Save graph summary [3]");//204
    items[1].addFirst("Save primary set summary [4]");//203
    items[1].addFirst("Save relay set summary [5]");//202
    items[1].addFirst("Save backbone summary [6]");//201
    items[1].addFirst("Files [F]");//200
    items[2].addFirst("Select graph [1]");//306
    items[2].addFirst("Terminal clique [2]");//305
    items[2].addFirst("Primary independent sets [3]");//304
    items[2].addFirst("Relay independent sets [4]");//303
    items[2].addFirst("Backbones [5]");//302
    items[2].addFirst("Surplus [6]");//301
    items[2].addFirst("Results [R]");//300
    items[3].addFirst("Node distribution [1]");//410
    items[3].addFirst("Graph generation [2]");//409
    items[3].addFirst("Smallest-last ordering [3]");//408
    items[3].addFirst("Smallest-last coloring [4]");//407
    items[3].addFirst("Partitioning [5]");//406
    items[3].addFirst("Relay coloring [6]");//405
    items[3].addFirst("Smallest-last coloring partites [7]");//404
    items[3].addFirst("Relay coloring partites [8]");//403
    items[3].addFirst("Smallest-last coloring bipartites [9]");//402
    items[3].addFirst("Relay coloring bipartites [10]");//401
    items[3].addFirst("Procedures [P]");//400
    items[4].addFirst("Degree distribution histogram [1]");//503
    items[4].addFirst("Vertex-degree plot [2]");//502
    items[4].addFirst("Color-size plot [3]");//501
    items[4].addFirst("Charts [C]");//500
    items[5].addFirst("Font settings [1]");//603
    items[5].addFirst("System settings [2]");//602
    items[5].addFirst("Color settings [3]");//601
    items[5].addFirst("Settings [S]");//600
    items[6].addFirst("Documentation [1]");//702
    items[6].addFirst("About [2]");//701
    items[6].addFirst("Help [H]");//700
  }
  float getLength(String item) {
    return textWidth(item)+gui.thisFont.stepX(2);
  }
  boolean active() {
    return option!=0;
  }
  boolean itemRange(int i) {
    return mouseX>width/2+(i-items.length/2.0)*itemLength&&mouseX<width/2+(i-items.length/2.0+1)*itemLength&&mouseY>height-barHeight;
  }
  boolean subItemRange(int i, int j) {
    return mouseX>width/2+(i-items.length/2.0+0.5)*itemLength-subItemLength/2&&mouseX<width/2+(i-items.length/2.0+0.5)*itemLength+subItemLength/2&&mouseY<height-barHeight*j-barHeight/2&&mouseY>height-barHeight*(1+j)-barHeight/2;
  }
  void display() {
    push();
    translate(width/2, height);
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    barHeight=gui.thisFont.stepY(2.5);
    itemLength=getLength("Procedures [P]");//longest main menu item
    barWidth=itemLength*items.length;
    fill(gui.colour[2].value, 50);
    noStroke();
    rect(0, -barHeight/2, barWidth, barHeight, gui.unit(10), gui.unit(10), 0, 0);
    strokeWeight(gui.unit());
    for (int i=0; i<items.length; i++) {
      noStroke();
      fill(gui.colour[2].value, 50);
      if (itemRange(i))
        rect(itemLength*(i-items.length/2.0+0.5), -barHeight/2, itemLength-gui.unit(6), barHeight-gui.unit(6), gui.unit(10), gui.unit(10), 0, 0);
      if (option>=100*(i+1)&&option<(i+2)*100) {
        ListIterator<String> itemIterator=items[i].listIterator(1);
        subItemLength=getLength(itemTarget[i]);
        quad((i-items.length/2.0+0.5)*itemLength-subItemLength/2, -1.5*barHeight, (i-items.length/2.0+0.5)*itemLength+subItemLength/2, -1.5*barHeight, (i-items.length/2.0+1)*itemLength-gui.thisFont.stepX(), -barHeight, (i-items.length/2.0)*itemLength+gui.thisFont.stepX(), -barHeight);
        rect((i-items.length/2.0+0.5)*itemLength, -(items[i].size()-1)*barHeight/2-1.5*barHeight, subItemLength, (items[i].size()-1)*barHeight, gui.unit(10), gui.unit(10), 0, 0);
        for (int j=1; j<items[i].size(); j++) {
          fill(gui.colour[2].value, 50);
          if (subItemRange(i, j))
            rect(itemLength*(i-items.length/2.0+0.5), -barHeight*(1+j), subItemLength-gui.unit(6), barHeight-gui.unit(6), gui.unit(10), gui.unit(10), 0, 0);
          fill(gui.bodyColor[option==100*(i+1)+j?0:2].value);
          text(itemIterator.next(), (i-items.length/2.0+0.5)*itemLength, -barHeight*(j+1));
        }
        stroke(gui.colour[1].value);
        for (int j=2; j<items[i].size(); j++)
          line(itemLength*(i-items.length/2.0+0.5)-subItemLength/2+gui.unit(3), -barHeight*j-barHeight/2, itemLength*(i-items.length/2.0+0.5)+subItemLength/2-gui.unit(3), -barHeight*j-barHeight/2);
      }
      fill(gui.bodyColor[option==-100*(i+1)?0:2].value);
      text(items[i].getFirst(), (i-items.length/2.0+0.5)*itemLength, -barHeight/2);
    }
    stroke(gui.colour[1].value);
    strokeWeight(gui.unit(2));
    for (int i=1; i<items.length; i++)
      dottedLine(itemLength*(i-items.length/2.0), 0, itemLength*(i-items.length/2.0), -barHeight);
    pop();
  }
  void go(int option) {//end from Node distribtuting to Relay coloring is 1 to 6, New graph is 0
    switch(option) {
    case 103://New graph
      nextPage=0;
      break;
    case 102://New computation
      nextPage=19;
      break;
    case 101://New demonstration
      nextPage=20;
      break;
    case 206://Load graph
      selectInput("Select WSN file:", "loadGraph", new File("Results"+System.getProperty("file.separator")+"."), io);
      break;
    case 205://Save graph
      if (end>=1)
        io.saveAs("graph");
      else
        error.logOut("File save error - No graph generated");
      break;
    case 204://Save graph summary
      if (end>=6)
        io.saveAs("graph summary");
      else
        error.logOut("File save error - Computation not finished");
      break;
    case 203://Save primary set summary
      if (end>=5)
        io.saveAs("primary set summary");
      else
        error.logOut("File save error - Computation not finished");
      break;
    case 202://Save relay set summary
      if (end>=6)
        io.saveAs("relay set summary");
      else
        error.logOut("File save error - Computation not finished");
      break;
    case 201://Save backbone summary
      if (end>=6)
        io.saveAs("bacbone summary");
      else
        error.logOut("File save error - Computation not finished");
      break;
    case 306://Select graph
      io.selectGraph();
      break;
    case 305://Terminal clique
      if (end>=3)
        nextPage=11;
      break;
    case 304://Primary independent sets
      if (end>=5)
        nextPage=12;
      break;
    case 303://Relay independent sets
      if (end>=6)
        nextPage=13;
      break;
    case 302://Backbones
      if (end>=6)
        nextPage=14;
      break;
    case 301://Surplus
      if (end>=6)
        nextPage=15;
      break;
    case 410://Node distributing
      if (end>=0&&end<7)
        nextPage=1;
      break;
    case 409://Graph Generating
      if (end>=1&&end<7)
        nextPage=2;
      break;
    case 408://Smallest-last Ordering
      if (end>=2&&end<7)
        nextPage=3;
      break;
    case 407://Smallest-last Coloring
      if (end>=3&&end<7)
        nextPage=4;
      break;
    case 406://Partitioning
      if (end>=4&&end<7)
        nextPage=5;
      break;
    case 405://Relay coloring
      if (end>=5&&end<7)
        nextPage=6;
      break;
    case 404://Smallest-last coloring partites
      if (end>=4&&end<7)
        nextPage=7;
      break;
    case 403://Relay coloring partites
      if (end>=6&&end<7)
        nextPage=8;
      break;
    case 402://Smallest-last coloring bipartites
      if (end>=4&&end<7)
        nextPage=9;
      break;
    case 401://Relay coloring bipartites
      if (end>=6&&end<7)
        nextPage=10;
      break;
    case 503://Degree distribution histogram
      if (end>=3)
        nextPage=16;
      break;
    case 502://Vertex-degree plot
      if (end>=3)
        nextPage=17;
      break;
    case 501://Smallest-last Color-size plot
      if (end>=4)
        nextPage=18;
      break;
    case 601://Color settings
      if (end>=0||end==-420)
        nextPage=21;
      break;
    case 602://System settings
      if (end>=0||end==-420)
        nextPage=22;
      break;
    case 603://Font settings
      if (end>=0||end==-420)
        nextPage=23    ;
      break;
    case 702://Documentation
      if (Desktop.isDesktopSupported())
      try {
        Desktop.getDesktop().open(new File(dataPath("Documentation.pdf")));
      }
      catch (IOException e) {
        error.logOut("File open error - "+e.getMessage());
      }
      break;
    case 701://About
      nextPage=24;
    }
    if (page!=nextPage) {
      page=screen.length-1;
      screen[page].setting();
      screen[nextPage].setting();
    }
  }
  void dottedLine(float x1, float y1, float x2, float y2) {
    float steps=dist(x1, y1, x2, y2)/10;
    for (float i = 0; i <steps; i++)
      point(lerp(x1, x2, i/steps), lerp(y1, y2, i/steps));
  }
  void keyPress() {
    if (key==CODED&&keyCode==ALT)
      lock=true;
    if (lock) {
      switch(Character.toLowerCase(key)) {
      case 'n':
        option=-100;
        break;
      case 'f':
        option=-200;
        break;
      case 'r':
        option=-300;
        break;
      case 'p':
        option=-400;
        break;
      case 'c':
        option=-500;
        break;
      case 's':
        option=-600;
        break;
      case 'h':
        option=-700;
      }
      if (option>0&&key>'0'&&key<'0'+items[option/100-1].size())
        option+=items[option/100-1].size()-int(key)+48;
    }
    if (option>0&&key==CODED) {
      if (keyCode==UP) {
        if (option%100==items[option/100-1].size())
          option-=option%100;
        option++;
      }
      if (keyCode==DOWN) {
        if (option%100==0)
          option+=items[option/100-1].size()-option%100;
        option--;
      }
    }
  }
  void keyRelease() {
    if (lock&&keyCode!=ALT||key==ENTER||key==RETURN) {
      mouseRelease();
      lock=false;
    }
  }
  void mousePress() {
    for (int i=0; i<items.length; i++) {
      if (itemRange(i)) {
        option=option==100*(i+1)?0:-100*(i+1);
        break;
      }
      if (option==100*(i+1)&&!itemTarget[i].equals("")) {
        boolean out=false;
        for (int j=1; j<items[i].size(); j++)
          if (subItemRange(i, j)) {
            option+=j;
            out=true;
            break;
          }
        if (out)
          break;
      }
    }
  }
  void mouseRelease() {
    if (option<0)
      option=-option;
    else {
      go(option);
      option=0;
    }
  }
}
