class Clique extends Result implements Screen {
  Slider edgeWeight=new Slider("Edge weight");
  Checker showClique=new Checker("Clique");
  Switcher showEdge=new Switcher("Edge", "Edge");
  Clique() {
    word=new String[8];
    parts.addLast(showClique);
    switches.addLast(showEdge);
    tunes.addLast(edgeWeight);
  }
  void setting() {
    showClique.value=showEdge.value=showNode.value=true;
    edgeWeight.setPreference(gui.unit(0.0002), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    initialize();
  }
  void show() {
    if (showClique.value) {
      stroke(gui.mainColor.value);
      if (showNode.value)
        for (Vertex node : graph.clique)
          displayNode((float)node.x, (float)node.y, (float)node.z);
      if (showEdge.value) {
        strokeWeight(edgeWeight.value);
        for (ListIterator<Vertex> i=graph.clique.listIterator(); i.hasNext(); ) {
          Vertex nodeA=i.next();
          for (ListIterator<Vertex> j=graph.clique.listIterator(i.previousIndex()+1); j.hasNext(); ) {
            Vertex nodeB=j.next();
            line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
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
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique size: "+graph.clique.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(11));
    word[0]="Vertices: "+(showClique.value&&showNode.value?graph.clique.size():0);
    word[1]="Edges: "+(showClique.value&&showEdge.value?graph.clique.size()*(graph.clique.size()-1)/2:0);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<2; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(12+i));
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=!showEdge.value;
  }
}