class NodeDistributing extends Procedure implements Screen {
  int _N;
  Checker distributedNodes=new Checker("Distributed nodes");
  NodeDistributing() {
    word=new String[3];
    parts.addLast(distributedNodes);
  }
  void setting() {
    initialize();
    distributedNodes.value=true;
    if (navigation.end==0) {
      navigation.end=-1;
      interval.setPreference(ceil(graph.vertex.length*7.0/3200), ceil(graph.vertex.length/3.0), ceil(graph.vertex.length*7.0/3200));
      _N=0;
    } else if (navigation.auto)
      _N=0;
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&_N==graph.vertex.length) {
        if (navigation.end==-1)
          navigation.end=1;
        if (navigation.auto)
          navigation.go(409);
        play.value=false;
      }
      if (play.value) {
        if (graph.vertex[_N]==null)
          graph.vertex[_N]=graph.topology.generateVertex(_N);
        _N++;
      }
    }
  }
  void show() {
    if (distributedNodes.value&&showNode.value) {
      stroke(gui.mainColor.value);
      for (int i=0; i<_N; i++)
        displayNode(graph.vertex[i]);
    }
  }
  void restart() {
    _N=0;
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Node distributing...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(6));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.4f", graph.r);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]=String.format("Vertices: %d (%.2f %%)", distributedNodes.value&&showNode.value?_N:0, (distributedNodes.value&&showNode.value?_N:0)*100.0/graph.vertex.length);
    word[1]=String.format("Complete: %.2f %%", _N*100.0/graph.vertex.length);
    text(word[0], gui.thisFont.stepX(3), gui.thisFont.stepY(7));
    text(word[1], gui.thisFont.stepX(3), gui.thisFont.stepY(8));
  }
}
