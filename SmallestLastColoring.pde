class SmallestLastColoring extends Procedure implements Screen {
  int _N, _E;
  boolean[] slot;
  Switcher showEdge=new Switcher("Edge", "Edge"), showMeasurement=new Switcher("Measurement", "Measurement");
  Checker uncoloredGraph=new Checker("Uncolored graph"), coloredGraph=new Checker("Colored graph");
  Slider edgeWeight=new Slider("Edge weight");
  Vertex nodeM=new Vertex();
  SmallestLastColoring() {
    word=new String[9];
    parts.addLast(uncoloredGraph);
    parts.addLast(coloredGraph);
    tunes.addLast(edgeWeight);
    switches.addLast(showEdge);
    switches.addLast(showMeasurement);
  }
  void setting() {
    initialize();
    showMeasurement.value=uncoloredGraph.value=showEdge.value=false;
    coloredGraph.value=true;
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    if (navigation.end==3) {
      navigation.end=-4;
      _N=0;
      if (graph._SLColors.isEmpty()) {
        interval.setPreference(ceil(graph.vertex.length*7.0/3200), ceil(graph.vertex.length/3.0), ceil(graph.vertex.length*7.0/3200));
        if (slot==null||slot.length<=graph.maxMinDegree)
          slot=new boolean[graph.maxMinDegree+1];
      } else {
        for (Color colour : graph._SLColors)
          colour.clean();
        graph._SLColors.clear();
      }
    }
  }
  void restart() {
    _N=0;
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==graph.vertex.length) {
        if (navigation.end==-4)
          navigation.end=4;
        if (navigation.auto)
          navigation.go(406);
        play.value=false;
      }
      if (play.value) {
        if (graph.vertex[_N].primeColor==null)
          graph.colour(_N, slot);
        _N++;
      }
    }
  }
  void show() {
    _E=0;
    if (uncoloredGraph.value) {
      stroke(gui.partColor[0].value);
      for (int i=_N; i<graph.vertex.length; i++) {
        Vertex nodeA=graph.vertex[i];
        if (showEdge.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            displayEdge(nodeA, nodeB, nodeB.value<_N&&coloredGraph.value||nodeA.value>nodeB.value&&nodeB.value>=_N);
        }
        if (showNode.value)
          displayNode(nodeA);
      }
    }
    if (coloredGraph.value)
      for (int i=0; i<_N; i++) {
        Vertex nodeA=graph.vertex[i];
        if (showEdge.value) {
          stroke(gui.mainColor.value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            displayEdge(nodeA, nodeB, nodeA.value>nodeB.value&&nodeB.value<_N);
        }
        if (showNode.value) {
          stroke(nodeA.primeColor.value);
          displayNode(nodeA);
        }
      }
  }
  void displayEdge(Vertex nodeA, Vertex nodeB, boolean condition) {
    if (condition) {
      _E++;
      if (showMeasurement.value) {
        nodeM.setCoordinates((nodeA.x+nodeB.x)/2, (nodeA.y+nodeB.y)/2, (nodeA.z+nodeB.z)/2);
        stroke(gui.partColor[nodeA.value<nodeB.value?1:2].value);
        line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeM.x, (float)nodeM.y, (float)nodeM.z);
        stroke(gui.partColor[nodeA.value<nodeB.value?2:1].value);
        line((float)nodeM.x, (float)nodeM.y, (float)nodeM.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
      } else
        line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(12));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int vertices=0;
    if (showNode.value) {
      if (coloredGraph.value)
        vertices=_N;
      if (uncoloredGraph.value)
        vertices+=graph.vertex.length-_N;
    }
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", _E*2.0/vertices);
    word[3]="Colors: "+graph._SLColors.size();
    word[4]=String.format("Complete: %.2f %%", _N*100.0/graph.vertex.length);
    for (int i=0; i<5; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(13+i));
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 'm':
      showMeasurement.value=!showMeasurement.value;
    }
  }
}
