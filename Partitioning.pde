class Partitioning extends Procedure implements Screen {
  int _N, _E, frame, pivot;
  Slider edgeWeight=new Slider("Edge weight"), breakpoint=new Slider("Selected percentile", 55, 1, 100, 1), selectColorSets=new Slider("Selected color sets", 1, 1);
  Switcher showEdge=new Switcher("Edge", "Edge");
  Checker remainingGraph=new Checker("Remaining graph"), selectedGraph=new Checker("Selected graph");
  LinkedList<String> modalLabels=new LinkedList<String>();
  Radio modals=new Radio(new String[]{"Auto select", "Manual select"});
  Partitioning() {
    word=new String[10];
    parts.addLast(remainingGraph);
    parts.addLast(selectedGraph);
    tunes.addLast(edgeWeight);
    switches.addLast(showEdge);
  }
  void setting() {
    initialize();
    remainingGraph.value=showEdge.value=false;
    selectedGraph.value=showNode.value=true;
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    if (navigation.end==4) {
      selectColorSets.setMax(graph._SLColors.size()-1);
      navigation.end=-5;
      if (graph.primaries==0) {
        interval.setPreference(1, graph._SLColors.size(), 1);
        if (navigation.auto) {
          if (graph.partitionModal) {
            modals.value=0;
            breakpoint.setValue(graph.breakpoint);
            selectColorSets.setValue(graph._SLColors.size()/2);
          } else {
            modals.value=1;
            selectColorSets.setValue(graph.breakpoint);
          }
        } else {
          selectColorSets.setValue(graph._SLColors.size()/2);
          graph.partitionModal=modals.value==0?true:false;
          graph.breakpoint=(graph.partitionModal?breakpoint:selectColorSets).value;
        }
        updateSelection();
      } else
        clean();
    }
  }
  void updateSelection() {//update selection after modal changed
    if (tunes.getLast()!=edgeWeight)
      tunes.removeLast();
    tunes.addLast(graph.partitionModal?breakpoint:selectColorSets);
  }
  void deploying() {
    if (play.value&&frameCount-frame>frameRate/interval.value) {
      if (pivot<graph._PYColors.size())
        pivot++;
      else if (graph.primaries>0) {
        if (navigation.end==-5)
          navigation.end=5;
        if (navigation.auto)
          navigation.go(405);
        play.value=false;
      } else
        pivot=graph.selectPrimarySet(pivot);
      frame=frameCount;
    }
  }
  void show() {
    _N=_E=0;
    if (remainingGraph.value) {
      stroke(gui.mainColor.value);
      for (int i=pivot; i<graph._SLColors.size(); i++ )
        for (Vertex nodeA : graph._SLColors.get(i).vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&(selectedGraph.value||nodeB.primeColor.index>=pivot)) {
                _E++;
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value) {
            ++_N;
            displayNode((float)nodeA.x, (float)nodeA.y, (float)nodeA.z);
          }
        }
    }
    if (selectedGraph.value) {
      for (int i=0; i<pivot; i++) {
        Color colour=graph._SLColors.get(i);
        for (Vertex nodeA : colour.vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            stroke(gui.partColor[1].value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&(remainingGraph.value||nodeB.primeColor.index<pivot)) {
                _E++;    
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value) {
            ++_N;
            stroke(colour.value);
            displayNode((float)nodeA.x, (float)nodeA.y, (float)nodeA.z);
          }
        }
      }
    }
  }
  void restart() {
    pivot=0;
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Partitioning...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(13));
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
    fill(gui.bodyColor[0].value);
    for (int i=0; i<10; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i)); 
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0/_N);
    word[3]="Primary colors: "+pivot;
    for (int i=0; i<4; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(14+i));
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Partition modals:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modals.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
  }
  void moreMouseReleases() {
    if (modals.active()) {
      graph.partitionModal=modals.value==0?true:false;
      updateSelection();
      graph.breakpoint=tunes.getLast().value;
      reset();
    }
    if (tunes.getLast().active()) {
      graph.breakpoint=tunes.getLast().value;
      reset();
    }
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
  void reset() {
    navigation.end=-5;
    clean();
  }
  void clean() {
    graph._PYColors.clear();
    pivot=graph.primaries=0;
  }
}
