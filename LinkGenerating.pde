class LinkGenerating extends Procedure implements Screen {
  int _N;
  Radio methods=new Radio("Exhaustive method", "Sweep method", "Cell method"), coordinates=new Radio("Cartesian system", "Cylindrical system", "Spherical system");
  Checker remainingVertices=new Checker("Remaining vertices"), generatedGraph=new Checker("Generated graph");
  Switcher showEdge=new Switcher("Edge", "Edge");
  LinkGenerating() {
    word=new String[3];
    parts.addLast(remainingVertices);
    parts.addLast(generatedGraph);
    switches.addLast(showEdge);
    tunes.addLast(edgeWeight);
    remainingVertices.value=false;
  }
  void setting() {
    initialize();
    if (navigation.end==1) {
      navigation.end=-2;
      interval.setPreference(ceil(graph.vertex.length*7.0/3200), ceil(graph.vertex.length/3.0), ceil(graph.vertex.length*7.0/3200));
      if (navigation.auto) {
        methods.value=graph.methodIndex;
        coordinates.value=graph.coordinateIndex;
      } else {
        graph.methodIndex=methods.value;
        graph.coordinateIndex=coordinates.value;
      }
      updateCoordinates();
    } else if (navigation.auto)
      restart();
  }
  void restart() {
    reset();
    graph.method[methods.value].reset();
  }
  void reset() {
    navigation.end=-2;
    for (Vertex node : graph.vertex) {
      node.neighbors.clear();
      node.lowpoint=-1;
    }
    graph._E=0;
  }
  void updateCoordinates() {//update coodinates when methods changed
    if (methods.value==2&&graph.topology.value!=4) {
      if (coordinates.labels.size()==3)
        coordinates.labels.removeLast();
    } else if (coordinates.labels.size()==2)
      coordinates.labels.addLast("Spherical system");
    graph.initialize();
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&!graph.method[methods.value].connecting()) {
        navigation.end=2;
        if (navigation.auto)
          navigation.go(408);
        play.value=false;
      }
    }
  }
  void show() {
    _N=0;
    for (Vertex nodeA : graph.vertex) {
      if (nodeA.lowpoint<0) {
        if (remainingVertices.value) {
          stroke(gui.partColor[0].value);
          if (showNode.value) {
            displayNode(nodeA);
            _N++;
          }
        }
      } else if (generatedGraph.value) {
        stroke(gui.mainColor.value);
        if (showEdge.value)
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeA.value<nodeB.value)
              displayEdge(nodeA, nodeB);
        if (showNode.value) {
          displayNode(nodeA);
          _N++;
        }
      }
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Methods:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    methods.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.gap()+gui.thisFont.stepY());
    if (methods.value>0) {
      fill(gui.headColor[2].value);
      text("Coordinates:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap());
      coordinates.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap(2));
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Link gernerating...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(6));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]="Edges: "+(generatedGraph.value&&showEdge.value?graph._E:0);
    word[2]=String.format("Average degree: %.2f", generatedGraph.value&&showEdge.value?graph._E*2.0/_N:0);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(7+i));
  }
  void moreMouseReleases() {
    if (methods.active()) {
      methods.commit();
      reset();
      graph.methodIndex=methods.value;
      graph.coordinateIndex=coordinates.value=0;
      updateCoordinates();
    }
    if (coordinates.active()) {
      coordinates.commit();
      reset();
      graph.coordinateIndex=coordinates.value;
      graph.initialize();
    }
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.commit();
  }
}
