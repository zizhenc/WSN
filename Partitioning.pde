class Partitioning extends Procedure implements Screen {
  int _E, frame, pivot;
  Slider edgeWeight=new Slider("Edge weight"), breakpoint=new Slider("Selected percentile", 55, 1, 100, 1), selectColorSets=new Slider("Selected color sets", 1, 1);
  Switcher showEdge=new Switcher("Edge", "Edge");
  Checker remainingGraph=new Checker("Remaining graph"), selectedGraph=new Checker("Selected graph");
  LinkedList<String> modalLabels=new LinkedList<String>();
  Radio modes=new Radio(new String[]{"Auto select", "Manual select"});
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
    selectedGraph.value=true;
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    if (navigation.end==4) {
      selectColorSets.setMax(graph._SLColors.size()-1);
      navigation.end=-5;
      interval.setPreference(1, graph._SLColors.size(), 1);
      if (graph.primaries==0) {
        selectColorSets.setValue(graph._SLColors.size()/2);
        if (navigation.auto) {
          modes.value=graph.mode?0:1;
          (graph.mode?breakpoint:selectColorSets).setValue(graph.breakpoint);
        } else {
          graph.mode=modes.value==0?true:false;
          graph.breakpoint=(graph.mode?breakpoint:selectColorSets).value;
        }
        updateSelection();
      } else
        clean();
    }
  }
  void updateSelection() {//update selection after modal changed
    if (tunes.getLast()!=edgeWeight)
      tunes.removeLast();
    tunes.addLast(graph.mode?breakpoint:selectColorSets);
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
    _E=0;
    if (remainingGraph.value) {
      stroke(gui.mainColor.value);
      for (int i=pivot; i<graph._SLColors.size(); i++ )
        for (Vertex nodeA : graph._SLColors.get(i).vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&nodeB.primeColor.index>=pivot||selectedGraph.value&&nodeB.primeColor.index<pivot) {
                _E++;
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value)
            displayNode(nodeA);
        }
    }
    if (selectedGraph.value) {
      for (int i=0; i<pivot; i++) {
        Color colour=graph._PYColors.get(i);
        for (Vertex nodeA : colour.vertices) {
          if (showEdge.value) {
            strokeWeight(edgeWeight.value);
            stroke(gui.partColor[1].value);
            for (Vertex nodeB : nodeA.neighbors)
              if (nodeA.value>nodeB.value&&nodeB.primeColor.index<pivot) {
                _E++;
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              }
          }
          if (showNode.value) {
            stroke(colour.value);
            displayNode(nodeA);
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
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int vertices=getN();
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0/vertices);
    word[3]="Primary colors: "+pivot;
    if (modes.value==1)
      word[4]=String.format("Complete: %.2f%%", pivot*100/selectColorSets.value);
    for (int i=0; i<(modes.value==0?4:5); i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(14+i));
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Partition mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
  }
  void moreMouseReleases() {
    if (modes.active()) {
      graph.mode=modes.value==0?true:false;
      updateSelection();
      reset();
    }
    if (tunes.getLast().active())
      reset();
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
  void reset() {
    graph.breakpoint=tunes.getLast().value;
    navigation.end=-5;
    clean();
  }
  void clean() {
    graph._PYColors.clear();
    pivot=graph.primaries=0;
  }
  int getN() {
    if (selectedGraph.value&&remainingGraph.value)
      return graph.vertex.length;
    else if (selectedGraph.value)
      return getNodes(0, pivot);
    else if (remainingGraph.value)
      return getNodes(pivot, graph._SLColors.size());
    else
      return 0;
  }
  int getNodes(int index, int len) {
    int sum=0;
    for (int i=index; i<len; i++)
      sum+=graph._SLColors.get(i).vertices.size();
    return sum;
  }
}
