class Surplus extends Result implements Screen {
  Checker surplus=new Checker("Surplus"), minorComponents=new Checker("+Minor components"), tails=new Checker("+Tails"), minorBlocks=new Checker("+Minor blocks"), giantBlocks=new Checker("+Giant blocks");
  int _N, _E;
  Surplus() {
    word=new String[13];
    parts.addLast(giantBlocks);
    parts.addLast(surplus);
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(minorBlocks);
    showEdge.value=tails.value=giantBlocks.value=minorComponents.value=minorBlocks.value=false;
  }
  void setting() {
    initialize();
    graph.calculateBackbones();
  }
  void show() {
    _N=_E=0;
    for (Vertex nodeA : graph.vertex)
      switch(nodeA.order[1]) {
      case -5:
        if (surplus.value) {
          stroke(gui.mainColor.value);
          showNetwork(nodeA);
        }
        break;
      case 0:
        if (minorComponents.value) {
          stroke(gui.partColor[0].value);
          showNetwork(nodeA);
        }
        break;
      case -2:
        if (tails.value) {
          stroke(gui.partColor[3].value);
          showNetwork(nodeA);
        }
        break;
      case -3:
        if (giantBlocks.value) {
          stroke(gui.partColor[1].value);
          showNetwork(nodeA);
        } else if (minorBlocks.value) {
          stroke(gui.partColor[2].value);
          showNetwork(nodeA);
        }
        break;
      case -4:
        if (giantBlocks.value) {
          stroke(gui.partColor[1].value);
          showNetwork(nodeA);
        }
        break;
      default:
        if (minorBlocks.value) {
          stroke(gui.partColor[2].value);
          showNetwork(nodeA);
        }
      }
  }
  void showNetwork(Vertex nodeA) {
    if (showEdge.value) {
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.neighbors)
        if (nodeA.value<nodeB.value&&((nodeB.order[1]>0||nodeB.order[1]==-1)&&minorBlocks.value||nodeB.order[1]==0&&minorComponents.value||nodeB.order[1]==-2&&tails.value||nodeB.order[1]==-3&&(giantBlocks.value||minorBlocks.value)||nodeB.order[1]==-4&&giantBlocks.value)) {
          _E++;
          line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
        }
    }
    if (showNode.value) {
      _N++;
      displayNode(nodeA);
    }
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Surplus...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
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
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(16));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0/_N:0);
    for (int i=0; i<3; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(16+i+1));
  }
}
