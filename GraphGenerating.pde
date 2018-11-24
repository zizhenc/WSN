class GraphGenerating extends Procedure implements Screen {
  int _N;
  String[][] coordinateLabels={{"Cartesian system", "Cylindrical system", "Spherical system"}, {"Cartesian system", "Cylindrical system"}};
  Radio methods=new Radio(new String[] {"Exhaustive method", "Sweep method", "Cell method"}), coordinates=new Radio(coordinateLabels[0]);
  Slider edgeWeight=new Slider("Edge weight");
  Checker remainingVertices=new Checker("Remain vertices"), generatedGraph=new Checker("Generated graph");
  Switcher showEdge=new Switcher("Edge", "Edge");
  GraphGenerating() {
    word=new String[3];
    parts.addLast(remainingVertices);
    parts.addLast(generatedGraph);
    switches.addLast(showEdge);
    tunes.addLast(edgeWeight);
  }
  void setting() {
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    remainingVertices.value=false;
    showNode.value=showEdge.value=generatedGraph.value=true;
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
    for (Vertex node : graph.vertex)
      node.clearNeighbors();
    graph._E=0;
  }
  void updateCoordinates() {//update coodinates when methods changed
    if (methods.value==2&&graph.topology.value!=4)
      coordinates.label=coordinateLabels[1];
    else
      coordinates.label=coordinateLabels[0];
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
      if (nodeA.mark<0) {
        if (remainingVertices.value) {
          stroke(gui.partColor[0].value);
          displayNode(nodeA);
        }
      } else if (generatedGraph.value) {
        stroke(gui.mainColor.value);
        if (showEdge.value) {
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.neighbors)
            if (nodeA.value<nodeB.value)
              line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
        displayNode(nodeA);
      }
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Methods:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    methods.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (methods.value>0) {
      fill(gui.headColor[2].value);
      text("Coordinates:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap());
      coordinates.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+methods.radioHeight+gui.thisFont.gap(2));
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Graph gernerating...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(6));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<3; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]="Edges: "+(generatedGraph.value&&showEdge.value?graph._E:0);
    word[2]=String.format("Average degree: %.2f", generatedGraph.value&&showEdge.value?graph._E*2.0/_N:0);
    for (int i=0; i<3; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(7+i));
  }
  void moreMouseReleases() {
    if (methods.active()) {
      reset();
      graph.methodIndex=methods.value;
      graph.coordinateIndex=coordinates.value=0;
      updateCoordinates();
    }
    if (coordinates.active()) {
      reset();
      graph.coordinateIndex=coordinates.value;
      graph.initialize();
    }
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
  void displayNode(Vertex node) {
    if (showNode.value) {
      displayNode((float)node.x, (float)node.y, (float)node.z);
      _N++;
    }
  }
}
