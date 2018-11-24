class RLPartite extends Partite {
  RLPartite() {
    word=new String[13];
  }
  void setColorPool() {
    colorPool=graph._RLColors;
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring partites...", gui.body.stepX(), gui.body.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.body.stepX(2), gui.body.stepY(2));
    int surplusOrder=surplus();
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
    word[12]=String.format("Surplus size: %d (%.2f%%)", surplusOrder, surplusOrder*100.0/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<13; i++)
      text(word[i], gui.body.stepX(3), gui.body.stepY(3+i));
    runtimeData(16);
  }
  int surplus() {
    int order=0;
    for (int i=0; i<graph.connectivity-1; i++)
      order+=graph.relayList[i].size();
    return order;
  }
}
