class Surplus extends Result implements Screen {
  Checker surplus=new Checker("Surplus"), minorComponents=new Checker("+Minor components"), tails=new Checker("+Tails"), minorBlocks=new Checker("+Minor blocks"), giantBlock=new Checker("Giant block");
  int _N, _E;
  Surplus() {
    word=new String[13];
    parts.addLast(giantBlock);
    parts.addLast(surplus);
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
  }
  void setting() {
    initialize();
    surplus.value=true;
    showEdge.value=tails.value=giantBlock.value=minorComponents.value=minorBlocks.value=false;
    graph.calculateBackbones();
  }
  void show() {
    _N=_E=0;
    for (Vertex nodeA : graph.vertex)
      switch(nodeA.order[1]) {
      case -5:
        if (surplus.value) {
          stroke(gui.mainColor.value);
          displayEdge(nodeA);
          displayNode(nodeA);
        }
        break;
      case 0:
        if (minorComponents.value) {
          stroke(gui.partColor[0].value);
          displayEdge(nodeA);
          displayNode(nodeA);
        }
        break;
      case -2:
        if (tails.value) {
          stroke(gui.partColor[3].value);
          displayEdge(nodeA);
          displayNode(nodeA);
        }
        break;
      case -4:
        if (giantBlock.value) {
          stroke(gui.partColor[1].value);
          displayEdge(nodeA);
          displayNode(nodeA);
        }
        break;
      default:
        if (minorBlocks.value) {
          stroke(gui.partColor[2].value);
          displayEdge(nodeA);
          displayNode(nodeA);
        }
      }
  }
  void displayNode(Vertex node) {
    if (showNode.value) {
      _N++;
      displayNode(node);
    }
  }
  void displayEdge(Vertex nodeA) {
    if (showEdge.value) {
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.neighbors)
        if (nodeA.value<nodeB.value&&(giantBlock.value&&nodeB.order[1]==-4||minorBlocks.value&&nodeB.order[1]>-2||tails.value&&nodeB.order[1]==-2||minorComponents.value&&nodeB.order[1]==0||surplus.value&&nodeB.order[1]==-5)) {
          _E++;
          line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring backbones...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(15));
    int surplusOrder=graph.surplus();
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
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-surplusOrder)*100.0/graph.vertex.length);
    word[12]=String.format("Surplus cardinality: %d (%.2f%%)", surplusOrder, surplusOrder*100.0/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    word[0]="Vertices: "+_N;
    word[1]="Edges: "+_E;
    word[2]=String.format("Average degree: %.2f", _E*2.0/_N);
    for (int i=0; i<3; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(16+i));
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='e')
      showEdge.value=showEdge.value ? false : true;
  }
}
