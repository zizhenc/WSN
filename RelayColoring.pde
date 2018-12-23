class RelayColoring extends Procedure implements Screen {
  int index, _N, _E;
  boolean[] slot;
  Slider connectivity=new Slider("Connectivity", 2, 1), edgeWeight=new Slider("Edge weight");
  Switcher showEdge=new Switcher("Edge", "Edge");
  Checker surplus=new Checker("Surplus"), coloredGraph=new Checker("Colored graph"), uncoloredGraph=new Checker("Uncolored graph"), primaryGraph=new Checker("Primary graph");
  RelayColoring() {
    parts.addLast(coloredGraph);
    parts.addLast(uncoloredGraph);
    parts.addLast(surplus);
    parts.addLast(primaryGraph);
    word=new String[11];
    tunes.addLast(edgeWeight);
    tunes.addLast(connectivity);
    switches.addLast(showEdge);
  }
  void setting() {
    initialize();
    surplus.value=primaryGraph.value=uncoloredGraph.value=showEdge.value=false;
    coloredGraph.value=true;
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    if (navigation.end==5) {
      if (slot==null||slot.length<graph._PYColors.size())
        slot=new boolean[graph._PYColors.size()];
      if (graph._RLColors.isEmpty()) {
        interval.setPreference(ceil((graph.vertex.length-graph.primaries)*7.0/3200), ceil((graph.vertex.length-graph.primaries)/3.0), ceil((graph.vertex.length-graph.primaries)*7.0/3200));
        connectivity.setPreference(graph.connectivity, graph.topology.connectivity());
        reset();
      } else
        restart();
    }
  }
  void restart() {
    graph.backbone=null;
    for (Color colour : graph._RLColors)
      colour.clean();
    graph._RLColors.clear();
    for (LinkedList<Vertex> list : graph.relayList) {
      for (Vertex node : list)
        node.clearRelays();
      list.clear();
    }
    reset();
  }
  void reset() {
    navigation.end=-6;
    index=graph.relayList.length-1;
    graph.generateRelayList(2);
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&index<connectivity.value-1) {
        if (navigation.end==-6)
          navigation.end=6;
        if (navigation.auto)
          navigation.go(403);
        play.value=false;
      }
      if (play.value)
        index=graph.colour(slot, index);
    }
  }
  void show() {
    _N=_E=0;
    if (primaryGraph.value)
      for (Color colour : graph._PYColors)
        for (Vertex nodeA : colour.vertices) {
          if (showEdge.value) {
            stroke(gui.partColor[1].value);
            displayEdge(nodeA);
          }
          displayNode(nodeA, colour);
        }
    for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++)
      for (Vertex nodeA : graph._SLColors.get(i).vertices) {
        if (surplus.value&&nodeA.order[1]==-5) {
          stroke(gui.mainColor.value);
          if (showEdge.value)
            displayEdge(nodeA);
          if (showNode.value) {
            _N++;
            displayNode(nodeA);
          }
        }
        if (coloredGraph.value&&nodeA.relayColor!=null) {
          if (showEdge.value) {
            stroke(gui.partColor[2].value);
            displayEdge(nodeA);
          }
          displayNode(nodeA, nodeA.relayColor);
        }
        if (uncoloredGraph.value&&nodeA.order[1]==-6) {
          stroke(gui.partColor[4].value);
          if (showEdge.value)
            displayEdge(nodeA);
          if (showNode.value) {
            _N++;
            displayNode(nodeA);
          }
        }
      }
  }
  void displayNode(Vertex node, Color colour) {
    if (showNode.value) {
      _N++;
      stroke(colour.value);
      displayNode(node);
    }
  }
  void displayEdge(Vertex nodeA) {
    strokeWeight(edgeWeight.value);
    for (Vertex nodeB : nodeA.neighbors)
      if (nodeA.value>nodeB.value)
        if (nodeB.primeColor.index<graph._PYColors.size()) {
          if (primaryGraph.value) {
            _E++;
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
        } else {
          if (coloredGraph.value&&nodeB.relayColor!=null||surplus.value&&nodeB.order[1]==-5||uncoloredGraph.value&&nodeB.order[1]==-6) {
            _E++;
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
          }
        }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(14));
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
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int surplusOrder=graph.surplus();
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0/_N);
    word[3]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0/graph.vertex.length);
    word[4]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0/graph.vertex.length);
    for (int i=0; i<5; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(15+i));
  }
  void moreMouseReleases() {
    if (connectivity.active()&&round(connectivity.value)!=graph.connectivity) {
      if (index<connectivity.value-1) {
        graph.connectivity=round(connectivity.value);
        restart();
      } else {
        graph.backbone=null;
        for (int i=graph.connectivity-1; i<connectivity.value-1; i++)
          for (Vertex node : graph.relayList[i])
            node.order[1]=-5;
        for (int i=round(connectivity.value)-1; i<graph.connectivity-1; i++)
          for (Vertex node : graph.relayList[i])
            node.order[1]=-6;
        graph.connectivity=round(connectivity.value);
      }
    }
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
}
