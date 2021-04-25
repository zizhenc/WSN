class Clique extends Result implements Screen {
  Checker showClique=new Checker("Clique");
  Clique() {
    word=new String[8];
    parts.addLast(showClique);
  }
  void setting() {
    initialize();
  }
  void show() {
    if (showClique.value) {
      stroke(gui.mainColor.value);
      if (showNode.value)
        for (Vertex node : graph.clique)
          displayNode(node);
      if (showEdge.value) {
        for (ListIterator<Vertex> i=graph.clique.listIterator(); i.hasNext(); ) {
          Vertex nodeA=i.next();
          for (ListIterator<Vertex> j=graph.clique.listIterator(i.previousIndex()+1); j.hasNext(); ) {
            Vertex nodeB=j.next();
            displayEdge(nodeA, nodeB);
          }
        }
      }
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Terminal clique...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(11));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique order: "+graph.clique.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]="Nodes: "+(showClique.value&&showNode.value?graph.clique.size():0);
    word[1]="Edges: "+(showClique.value&&showEdge.value?graph.clique.size()*(graph.clique.size()-1)/2:0);
    for (int i=0; i<2; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(12+i));
  }
}
