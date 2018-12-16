class Backbone extends Result implements Screen {
  int _N, _E;
  String[] headers={"Degree", "Primary", "Relay", "Total"}, modalLabels={"Table", "Bar chart"};
  Color primary, relay;
  SysColor[] plotColor=new SysColor[3];
  Radio modals=new Radio(modalLabels);
  Region region=new Region();
  Slider backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showRegion=new Switcher("Region", "Region");
  BarChart barChart=new BarChart("Degree", "Vertex", new String[]{"Primary", "Relay", "Total"});
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  Backbone() {
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
    parts.addLast(giantBlock);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    tunes.addLast(edgeWeight);
    tunes.addLast(backbone);
    table=new ExTable(headers, 8);
    plotColor[2]=gui.mainColor;
    for (int i=0; i<8; i++) {
      table.setInt(7-i, 0, i);
      for (int j=0; j<plot.length; j++)
        barChart.points[j].add(0.0);
    }
  }
  void setting() {
    initialize();
    showEdge.value=minorComponents.value=minorBlocks.value=giantBlock.value=plot[0].value=plot[1].value=plot[2].value=true;
    tails.value=showRegion.value=false;
    for (int i=0; i<plot.length; i++)
      barChart.setPlot(i, plot[i].value);
    setComponent(1);
    backbone.setPreference(1, graph.backbone.length);
  }
  void setComponent(int index) {
    if (index>graph._RLColors.size()) {
      primary=relay=gui.mainColor;
      if (component==null)
        component=new Component(primary, relay);
      else
        component.reset(primary, relay);
    } else {
      component=graph.getBackbone(index-1);
      primary=component.primary;
      relay=component.relay;
    }
    plotColor[0]=primary;
    plotColor[1]=relay;
    barChart.initialize(0, 7, 0, primary.vertices.size()+relay.vertices.size());
    barChart.deployColors(plotColor);
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
  }
  void show() {
    clearStatistics();
    if (giantBlock.value)
      for (Vertex nodeA : component.giant[0])
        if (nodeA.order[1]!=-3)
          showNetwork(nodeA, gui.mainColor);
    if (minorBlocks.value)
      for (LinkedList<Vertex> list : component.blocks)
        if (component.giant[0]!=list)
          for (Vertex nodeA : list)
            if (nodeA.order[1]!=-1&&nodeA.order[1]!=-3)
              showNetwork(nodeA, gui.partColor[0]);
    if (!component.blocks.isEmpty())
      for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
        Vertex nodeA=i.previous().getLast();
        if (minorBlocks.value||giantBlock.value&&nodeA.order[1]==-3) {
          if (showEdge.value) {
            int count=0;
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.links) {
              if (nodeB.order[1]==-2&&!tails.value||nodeB.order[1]>-2&&!minorBlocks.value||nodeB.order[1]<-3&&!giantBlock.value||nodeB.order[1]==-3&&!giantBlock.value&&!minorBlocks.value)
                count++;
              else {
                if (nodeB.order[1]==-2)
                  stroke(gui.partColor[1].value);
                else if (nodeB.order[1]>-2)
                  stroke(gui.partColor[0].value);
                else if (nodeB.order[1]<-3)
                  stroke(gui.mainColor.value);
                else if (nodeA.order[1]==-1)
                  stroke(gui.partColor[0].value);
                else
                  stroke(gui.mainColor.value);
                displayEdge(nodeA, nodeB);
              }
            }
            analyze(nodeA, nodeA.links.size()-count);
          }
          showSensor(nodeA);
        }
      }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.links)
            if (nodeB.order[1]<-3&&!giantBlock.value||nodeB.order[1]>-2&&!minorBlocks.value||nodeB.order[1]==-3&&!giantBlock.value&&!minorBlocks.value)
              count++;
            else
              displayEdge(nodeA, nodeB);
          analyze(nodeA, nodeA.links.size()-count);
        }
        showSensor(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              analyze(nodeA, nodeA.links.size());
              stroke(gui.partColor[2].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
            }
            showSensor(nodeA);
          }
  }
  void showNetwork(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[1]==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order[1]==-2?gui.partColor[1].value:colour.value);
          displayEdge(nodeA, nodeB);
        }
      analyze(nodeA, nodeA.links.size()-count);
    }
    showSensor(nodeA);
  }
  void showSensor(Vertex nodeA) {
    if (showNode.value) {
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
      ++_N;
      if (showRegion.value)
        region.display(_N, nodeA);
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode(nodeA);
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    int surplusOrder=graph.surplus();
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0/_N:0);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0/graph.vertex.length);
    word[4]="Components: "+components();
    word[5]="Giant component blocks: "+component.blocks.size();
    int len=7;
    if (graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len=9;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[len-3]="Faces: "+faces;
      word[len-2]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
    }
    word[len-1]="Primary partite #"+(primary.index+1)+" & relay partite #"+(relay.index+1);
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(17+i));
    if (modals.value==1)
      barChart.display(gui.thisFont.stepX(3), gui.thisFont.stepY(16+len)+gui.thisFont.gap(), gui.margin(), gui.margin());
    else
      table.display(gui.thisFont.stepX(3), gui.thisFont.stepY(16+len)+gui.thisFont.gap());
  }
  void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart modals:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modals.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (modals.value==1) {
      fill(gui.headColor[2].value);
      text("Plots:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+gui.thisFont.gap()+modals.radioHeight);
      for (int i=0; i<plot.length; i++)
        plot[i].display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+gui.thisFont.gap(2)+modals.radioHeight+(plot[0].checkerHeight+gui.thisFont.gap())*i);
    }
  }
  void moreMouseReleases() {
    modals.active();
    if (modals.value==1)
      for (int i=0; i<plot.length; i++)
        if (plot[i].active()) {
          plot[i].value=!plot[i].value;
          barChart.setPlot(i, plot[i].value);
        }
    if (backbone.active())
      setComponent(round(backbone.value));
    if (showRegion.active())
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (backbone.value==backbone.min)
        backbone.setValue(backbone.max);
      else
        backbone.decreaseValue();
      setComponent(round(backbone.value));
      break;
    case '.':
    case '>':
      if (backbone.value==backbone.max)
        backbone.setValue(backbone.min);
      else
        backbone.increaseValue();
      setComponent(round(backbone.value));
    }
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
    }
  }
  int components() {
    int amount=0;
    if (giantBlock.value&&minorBlocks.value)
      amount=component.giant[0].isEmpty()?0:1;
    else if (giantBlock.value) {
      if (!component.giant[0].isEmpty())
        amount=1;
    } else if (minorBlocks.value) {
      amount=component.tails[4];
    }
    if (tails.value) {
      if (!giantBlock.value&&!minorBlocks.value)
        amount+=component.tails[0];
      else if (!giantBlock.value)
        amount+=component.tailsXMinors();
      else if (!minorBlocks.value)
        amount+=component.tailsXGiant();
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
  void clearStatistics() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    domain.clear();
    switch(modals.value) {
    case 0:
      for (int i=0; i<8; i++)
        for (int j=0; j<plot.length; j++)
          table.setInt(i, j+1, 0);
      break;
    case 1:
      for (int i=0; i<8; i++)
        for (int j=0; j<plot.length; j++)
          barChart.points[j].set(i, 0.0);
    }
  }
  void analyze(Vertex node, int degree) {
    int category=node.primeColor==primary?0:1, tValue;
    float bValue;
    switch(modals.value) {
    case 0:
      tValue=table.getInt(7-degree, category+1)+1;
      table.setInt(7-degree, category+1, tValue);
      tValue=table.getInt(7-degree, 3)+1;
      table.setInt(7-degree, 3, tValue);
      break;
    case 1:
      bValue=barChart.points[category].get(degree)+1;
      barChart.points[category].set(degree, bValue);
      bValue=barChart.points[2].get(degree)+1;
      barChart.points[2].set(degree, bValue);
    }
  }
}
