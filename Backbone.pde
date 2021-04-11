class Backbone extends Result implements Screen {
  int _N, _E;
  float kCoverage;
  Color primary, relay;
  SysColor[] plotColor=new SysColor[3];
  Radio modes=new Radio("Table", "Bar chart");
  Region region=new Region();
  Slider backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  BarChart barChart=new BarChart("Degree", "Vertex", plotColor, "Primary", "Relay", "Total");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  HashSet<Vertex> domain=new HashSet<Vertex>(), primaryDomain=new HashSet<Vertex>(), relayDomain=new HashSet<Vertex>();
  Analyze domination, network, coverage;
  Backbone () {
    word=new String[13];
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
    parts.addLast(giantBlock);
    switches.addLast(showRegion);
    tunes.addLast(backbone);
    table=new ExTable(13, "Coverage", "Primary", "Relay", "Total");
    plotColor[2]=gui.partColor[0];
    barChart.setX(0, 12);
    barChart.setPoints();
    for (int i=0; i<13; i++)
      table.setInt(12-i, 0, i);
    minorComponents.value=showRegion.value=false;
    domination=new Analyze() {
      void go(Vertex nodeA) {
        HashSet<Vertex> subDomain=nodeA.primeColor==primary?primaryDomain:relayDomain;
        domain.add(nodeA);
        subDomain.add(nodeA);
        for (Vertex nodeB : nodeA.neighbors) {
          domain.add(nodeB);
          subDomain.add(nodeB);
        }
      }
    };
    coverage=new Analyze() {
      void go(Vertex nodeA) {
        for (Vertex nodeB : nodeA.neighbors)
          if (nodeB.k[0]>=0)
            nodeB.k[nodeA.primeColor==primary?0:1]++;
      }
    };
    network=new Analyze() {
      void go(Vertex node) {
        node.k[0]=-1;
      }
    };
  }
  void setting() {
    initialize();
    barChart.setY(0, graph.vertex.length);
    graph.initailizeBackbones();
    setComponent(1);
    backbone.setPreference(1, graph.backbone.length);
  }
  void setComponent(int index) {
    component=graph.getBackbone(index-1);
    primary=component.primary;
    relay=component.relay;
    plotColor[0]=primary;
    plotColor[1]=relay;
    barChart.reset();
    barChart.play=true;
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    while (component.deleting());
    statistics();
  }
  void traverse(Analyze analyze) {
    if (giantBlock.value)
      for (Vertex nodeA : component.giant[0])
        if (nodeA.order[component.archive]!=-3)
          analyze.go(nodeA);
    if (minorBlocks.value)
      for (LinkedList<Vertex> list : component.blocks)
        if (component.giant[0]!=list)
          for (Vertex nodeA : list)
            if (nodeA.order[component.archive]!=-1&&nodeA.order[component.archive]!=-3)
              analyze.go(nodeA);
    if (!component.blocks.isEmpty())
      for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
        Vertex nodeA=i.previous().getLast();
        if (minorBlocks.value||giantBlock.value&&nodeA.order[component.archive]==-3)
          analyze.go(nodeA);
      }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next)
        analyze.go(nodeA);
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list)
            analyze.go(nodeA);
  }
  void statistics() {
    domain.clear();
    primaryDomain.clear();
    relayDomain.clear();
    traverse(domination);
    switch(modes.value) {
    case 0:
      for (int i=0; i<13; i++)
        for (int j=0; j<plot.length; j++)
          table.setInt(i, j+1, 0);
      break;
    case 1:
      for (ArrayList<Float> point : barChart.points)
        for (int i=0; i<13; i++)
          point.set(i, 0f);
    }
    for (Vertex node : graph.vertex)
      node.k[0]=node.k[1]=0;
    traverse(network);
    traverse(coverage);
    int nodes=0;
    for (Vertex node : graph.vertex)
      if (node.k[0]<0)
        nodes++;
      else {
        switch(modes.value) {
        case 0:
          table.setInt(12-node.k[0], 1, table.getInt(12-node.k[0], 1)+1);
          table.setInt(12-node.k[1], 2, table.getInt(12-node.k[1], 2)+1);
          table.setInt(12-node.k[0]-node.k[1], 3, table.getInt(12-node.k[0]-node.k[1], 3)+1);
          break;
        case 1:
          barChart.points[0].set(node.k[0], barChart.points[0].get(node.k[0])+1);
          barChart.points[1].set(node.k[1], barChart.points[1].get(node.k[1])+1);
          barChart.points[2].set(node.k[0]+node.k[1], barChart.points[2].get(node.k[0]+node.k[1])+1);
        }
      }
    nodes=graph.vertex.length-nodes;
    kCoverage=0;
    for (int i=3; i<13; i++)
      if(modes.value==0)
        kCoverage+=table.getInt(12-i, 3);
      else
        kCoverage+=barChart.points[2].get(i);
    kCoverage/=nodes;
  }
  void show() {
    _N=_E=0;
    if (giantBlock.value)
      for (Vertex nodeA : component.giant[0])
        if (nodeA.order[component.archive]!=-3)
          showNetwork(nodeA, gui.mainColor);
    if (minorBlocks.value)
      for (LinkedList<Vertex> list : component.blocks)
        if (component.giant[0]!=list)
          for (Vertex nodeA : list)
            if (nodeA.order[component.archive]!=-1&&nodeA.order[component.archive]!=-3)
              showNetwork(nodeA, gui.partColor[0]);
    if (!component.blocks.isEmpty())
      for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
        Vertex nodeA=i.previous().getLast();
        if (minorBlocks.value||giantBlock.value&&nodeA.order[component.archive]==-3) {
          if (showEdge.value) {
            for (Vertex nodeB : nodeA.links) {
              if (nodeB.order[component.archive]==-2&&tails.value||nodeB.order[component.archive]>-2&&minorBlocks.value||nodeB.order[component.archive]<-3&&giantBlock.value||nodeB.order[component.archive]==-3&&(giantBlock.value||minorBlocks.value)) {
                if (nodeB.order[component.archive]==-2)
                  stroke(gui.partColor[1].value);
                else if (nodeB.order[component.archive]>-2)
                  stroke(gui.partColor[0].value);
                else if (nodeB.order[component.archive]<-3)
                  stroke(gui.mainColor.value);
                else if (nodeA.order[component.archive]==-1)
                  stroke(gui.partColor[0].value);
                else
                  stroke(gui.mainColor.value);
                displayLink(nodeA, nodeB);
              }
            }
          }
          showSensor(nodeA);
        }
      }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          stroke(gui.partColor[1].value);
          for (Vertex nodeB : nodeA.links)
            if (nodeB.order[component.archive]==-2||nodeB.order[component.archive]<-3&&giantBlock.value||nodeB.order[component.archive]>-2&&minorBlocks.value||nodeB.order[component.archive]==-3&&(giantBlock.value||minorBlocks.value))
              displayLink(nodeA, nodeB);
        }
        showSensor(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              stroke(gui.partColor[2].value);
              for (Vertex nodeB : nodeA.links)
                displayLink(nodeA, nodeB);
            }
            showSensor(nodeA);
          }
  }
  void showNetwork(Vertex nodeA, SysColor colour) {
    if (showEdge.value)
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[component.archive]!=-2||nodeB.order[component.archive]==-2&&tails.value) {
          stroke(nodeB.order[component.archive]==-2?gui.partColor[1].value:colour.value);
          displayLink(nodeA, nodeB);
        }
    showSensor(nodeA);
  }
  void showSensor(Vertex nodeA) {
    if (showNode.value||showRegion.value)
      ++_N;
    if (showNode.value) {
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode(nodeA);
    }
    if (showRegion.value) {
      strokeWeight(edgeWeight.value);
      region.display(_N, nodeA);
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Backbones...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
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
    for (int i=0; i<13; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Nodes: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0/_N:0);
    word[3]=String.format("Primary dominates: %d (%.2f%%)", primaryDomain.size(), primaryDomain.size()*100.0/graph.vertex.length);
    word[4]=String.format("Relay dominates: %d (%.2f%%)", relayDomain.size(), relayDomain.size()*100.0/graph.vertex.length);
    word[5]=String.format("Total dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0/graph.vertex.length);
    word[6]="Components: "+components();
    word[7]="Giant component blocks: "+component.blocks.size();
    int len=9;
    if (graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len+=2;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[len-3]="Faces: "+faces;
      word[len-2]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
    }
    word[len-1]=String.format("3+-Coverage: %.2f%%",kCoverage*100);
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(16+i+1));
    fill(primary.value);
    text("Primary partite #"+(primary.index+1), gui.thisFont.stepX(3), gui.thisFont.stepY(17+len));
    fill(gui.bodyColor[0].value);
    text(" & ", gui.thisFont.stepX(3)+textWidth("Primary partite #"+(primary.index+1)), gui.thisFont.stepY(17+len));
    fill(relay.value);
    text("relay partite #"+(relay.index+1), gui.thisFont.stepX(3)+textWidth("Primary partite #"+(primary.index+1)+" & "), gui.thisFont.stepY(17+len));
    if (modes.value==1) {
      barChart.showFrame(gui.thisFont.stepX(3), gui.thisFont.stepY(17+len)+gui.thisFont.gap(), gui.margin(), gui.margin());
      barChart.showLabels(gui.thisFont.stepX(2)+gui.margin()-textWidth("Degree"), gui.thisFont.stepY(19+len));
      strokeWeight(7.5);
      barChart.drawPlot[0].display();
      barChart.showMeasurement();
    } else
      table.display(gui.thisFont.stepX(3), gui.thisFont.stepY(17+len)+gui.thisFont.gap());
  }
  void displayLink(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      displayEdge(nodeA, nodeB);
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (modes.value==1) {
      fill(gui.headColor[2].value);
      text("Plots:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+gui.thisFont.gap()+modes.radioHeight);
      for (int i=0; i<plot.length; i++)
        plot[i].display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+gui.thisFont.gap(2)+modes.radioHeight+(plot[0].checkerHeight+gui.thisFont.gap())*i);
    }
  }
  void moreMousePresses() {
    if (backbone.active())
      setComponent(round(backbone.value));
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  void moreMouseReleases() {
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (modes.active()) {
      modes.commit();
      statistics();
    }
    if (modes.value==1)
      for (int i=0; i<plot.length; i++)
        if (plot[i].active()) {
          plot[i].commit();
          barChart.setPlot(i, plot[i].value);
        }
    for (Checker part : parts)
      if (part.active())
        statistics();
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
    if (Character.toLowerCase(key)=='t') {
      showRegion.commit();
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
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
}
