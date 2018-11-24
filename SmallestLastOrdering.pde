class SmallestLastOrdering extends Procedure implements Screen {
  Slider edgeWeight=new Slider("Edge weight");
  Switcher showMeasurement=new Switcher("Measurement", "Measurement"), showEdge=new Switcher("Edge", "Edge");
  Checker deletedGraph=new Checker("Deleted graph"), remainingGraph=new Checker("Remaning graph");
  int[] degree=new int[2];//degree/2, degree;
  int _N, _E;
  Vertex[] degreeList=new Vertex[2];
  SmallestLastOrdering() {
    word=new String[7];
    parts.addLast(deletedGraph);
    parts.addLast(remainingGraph);
    switches.addLast(showEdge);
    switches.addLast(showMeasurement);
    tunes.addLast(edgeWeight);
  }
  void setting() {
    remainingGraph.value=showMeasurement.value=showEdge.value=showNode.value=true;
    edgeWeight.setPreference(gui.unit(0.0005), gui.unit(0.00002), gui.unit(0.002), gui.unit(0.0005), gui.unit(1000));
    deletedGraph.value=false;
    initialize();
    if (graph.degreeList.isEmpty()) {
      interval.setPreference(ceil(graph.vertex.length*7.0/3200), ceil(graph.vertex.length/3.0), ceil(graph.vertex.length*7.0/3200));
      graph.generateDegreeList();
      reset();
    } else if (navigation.end==2)
      restart();
  }
  void restart() {
    graph.clique.clear();
    graph.maxMinDegree=0;
    for (Vertex list : graph.degreeList)
      list.clean();
    for (Vertex node : graph.vertex) {
      node.degree=node.neighbors.size();
      graph.degreeList.get(node.degree).push(node);
    }
    reset();
  }
  void reset() {
    navigation.end=-3;
    degreeList[0]=graph.degreeList.get(graph.minDegree);
    degreeList[1]=graph.degreeList.get(graph.maxDegree);
    _N=graph.vertex.length;
    degree[0]=graph._E;
    degree[1]=degree[0]*2;
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==0) {
        if (navigation.end==-3)
          navigation.end=3;
        if (navigation.auto)
          navigation.go(407);
        play.value=false;
      }
      if (play.value) {
        graph.order(_N, degree, degreeList);
        _N--;
      }
    }
  }
  void highlight(Vertex list) {
    for (Vertex nodeA=list.next; nodeA!=null; nodeA=nodeA.next) {
      if (showEdge.value) {
        strokeWeight(edgeWeight.value);
        for (Vertex nodeB : nodeA.neighbors)
          if (nodeB.value<_N)
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
      }
      displayNode(nodeA);
    }
  }
  void show() {
    if (remainingGraph.value) {
      stroke(gui.mainColor.value); 
      for (int i=0; i<_N; i++) {
        Vertex nodeA=graph.vertex[i]; 
        if (showEdge.value&&!showMeasurement.value) {
          strokeWeight(edgeWeight.value); 
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeB.value<_N&&nodeA.value<nodeB.value)
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
        displayNode(nodeA);
      }
    }
    if (deletedGraph.value) {
      stroke(gui.partColor[0].value);
      _E=0;
      for (int i=_N; i<graph.vertex.length; i++) {
        Vertex nodeA=graph.vertex[i]; 
        if (showEdge.value&&!showMeasurement.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeB.value<_N) {
              if (remainingGraph.value)
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            } else if (nodeA.value<nodeB.value) {
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              ++_E;
            }
        }
        displayNode(nodeA);
      }
    }
    if (showMeasurement.value) {
      stroke(gui.partColor[1].value);
      highlight(degreeList[1]);
      stroke(gui.partColor[2].value);
      highlight(degreeList[0]);
    }
  }
  void data() {
    fill(gui.headColor[1].value); 
    text("Smallest-last ordering...", gui.thisFont.stepX(), gui.thisFont.stepY()); 
    fill(gui.headColor[2].value); 
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(10)); 
    word[0]="Topology: "+graph.topology; 
    word[1]="N: "+graph.vertex.length; 
    word[2]=String.format("r: %.3f", graph.r); 
    word[3]="E: "+graph._E; 
    word[4]="Deg(Max.): "+graph.maxDegree; 
    word[5]="Deg(Min.): "+graph.minDegree; 
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length); 
    fill(gui.bodyColor[0].value); 
    for (int i=0; i<7; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    int edges=0, vertices=0; 
    if (showNode.value) {
      if (remainingGraph.value)
        vertices+=_N;
      else if (showMeasurement.value)
        vertices+=degreeList[0].value+degreeList[1].value;
      if (deletedGraph.value)
        vertices+=graph.vertex.length-_N;
    }
    if (showEdge.value) {
      if (showMeasurement.value)
        edges=degreeList[1].value*degreeList[1].degree+degreeList[0].value*degreeList[0].degree; 
      else {
        if (deletedGraph.value&&remainingGraph.value)
          edges=graph._E;
        else if (remainingGraph.value)
          edges=degree[0];
        else
          edges=_E;
      }
    }
    word[0]=String.format("Vertices: %d (%.2f %%)", vertices, vertices*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", edges, edges*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", edges*2.0/vertices); 
    word[3]="Terminal clique size: "+graph.clique.size();
    word[4]="Maximum min-degree: "+graph.maxMinDegree;
    word[5]=String.format("Complete: %.2f%%", (1-_N*1.0/graph.vertex.length)*100); 
    for (int i=0; i<6; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(11+i));
    if (showMeasurement.value) {
      fill(gui.partColor[1].value); 
      text("Max. degree: "+degreeList[1].degree+" ("+degreeList[1].value+(degreeList[1].value<2?" vertex)":" vertices)"), gui.thisFont.stepX(3), gui.thisFont.stepY(17)); 
      fill(gui.partColor[2].value);
      text("Min. degree: "+degreeList[0].degree+" ("+degreeList[0].value+(degreeList[0].value<2?" vertex)":" vertices)"), gui.thisFont.stepX(3), gui.thisFont.stepY(18));
    }
  }
  void moreKeyReleases() {
    switch(Character.toLowerCase(key)) {
    case 'e' : 
      showEdge.value=!showEdge.value; 
      break; 
    case 'm' : 
      showMeasurement.value=!showMeasurement.value;
    }
  }
  void displayNode(Vertex node) {
    if (showNode.value)
      displayNode((float)node.x, (float)node.y, (float)node.z);
  }
}