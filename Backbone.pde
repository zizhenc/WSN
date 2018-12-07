class Backbone extends Result implements Screen {
  int _N, _E;
  String[] headers={"Degree", "Primary", "Relay", "Total"}, modalLabels={"Table", "Bar chart"};
  BarChart barChart=new BarChart("Degree", "Vertex", new String[]{"Primary", "Relay", "Total"});
  Color primary, relay;
  Radio modals=new Radio(modalLabels);
  Region region=new Region();
  Slider edgeWeight=new Slider("Edge weight"), backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  int[][] nodes;
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
  }
  void setting() {
    initialize();
    showNode.value=showEdge.value=minorComponents.value=minorBlocks.value=giantBlock.value=plot[0].value=plot[1].value=plot[2].value=true;
    tails.value=showRegion.value=false;
    edgeWeight.setPreference(gui.unit(0.0005), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    for (int i=0; i<plot.length; i++)
      barChart.setPlot(i, plot[i].value);
    setComponent(1);
    backbone.setPreference(1, graph.backbone.length);
  }
  void setComponent(int index) {
    if (index>graph._RLColors.size())
      primary=relay=gui.mainColor;
    else {
      relay=graph._RLColors.get(index-1);
      primary=graph._PYColors.get(relay.index-graph._SLColors.size());
    }
    if (component==null)
      component=new Component(primary, relay);
    else
      component.reset(primary, relay);
    barChart.initialize(0, 7, 0, primary.vertices.size()+relay.vertices.size());
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    while (component.deleting());
    component.clearTailCounts();
    component.countTails();
  }
  void show() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    for (int i=0; i<2; i++)
      for (int j=0; j<8; j++)
        nodes[i][j]=0;
    domain.clear();
    if (giantBlock.value)
      for (Vertex nodeA : component.giant[0])
        if (nodeA.order!=-3) {
          displayEdge(nodeA, gui.mainColor);
          displayNode(nodeA);
        }
    if (minorBlocks.value)
      for (LinkedList<Vertex> list : component.blocks)
        if (component.giant[0]!=list)
          for (Vertex nodeA : list)
            if (nodeA.order!=-1&&nodeA.order!=-3) {
              displayEdge(nodeA, gui.partColor[0]);
              displayNode(nodeA);
            }
    if (!component.blocks.isEmpty())
      for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
        Vertex nodeA=i.previous().getLast();
        if (minorBlocks.value||giantBlock.value&&nodeA.order==-3) {
          if (showEdge.value) {
            int count=0;
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.links) {
              if (nodeB.order==-2&&!tails.value||nodeB.order>-2&&!minorBlocks.value||nodeB.order<-2&&!giantBlock.value)
                count++;
              else {
                if (nodeB.order==-2)
                  stroke(gui.partColor[1].value);
                else if (nodeB.order>-2)
                  stroke(gui.partColor[0].value);
                else if (nodeB.order<-2)
                  stroke(gui.mainColor.value);
                displayEdge(nodeA, nodeB);
              }
            }
            nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
          }
          displayNode(nodeA);
        }
      }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.links)
            if (nodeB.order<-2&&!giantBlock.value||nodeB.order>-2&&!minorBlocks.value)
              count++;
            else
              displayEdge(nodeA, nodeB);
          nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
        }
        displayNode(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()]++;
              stroke(gui.partColor[2].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
            }
            displayNode(nodeA);
          }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    int surplusOrder=surplus();
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
      len+=2;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
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
  int surplus() {
    int order=0;
    for (int i=0; i<graph.connectivity-1; i++)
      order+=graph.relayList[i].size();
    return order;
  }
  void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  void displayEdge(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order==-2?gui.partColor[1].value:colour.value);
          displayEdge(nodeA, nodeB);
        }
      nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
    }
  }
  void displayNode(Vertex nodeA) {
    if (showNode.value) {
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
      ++_N;
      if (showRegion.value)
        region.display(_N, nodeA);
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode((float)nodeA.x, (float)nodeA.y, (float)nodeA.z);
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
    if (giantBlock.value)
      amount+=1;
    else if (minorBlocks.value)
      amount+=component.blocks.size()-1;
    if (tails.value) {
      if (!giantBlock.value&&!minorBlocks.value)
        amount+=component.tailsToTwoCore();
      else if (!giantBlock.value)
        amount+=component.tailsToGiant();
      else if (!minorBlocks.value)
        amount+=component.tailsToMinors();
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
}
