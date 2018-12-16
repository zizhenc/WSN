class RLBipartite extends Bipartite {
  RLBipartite() {
    word=new String[13];
  }
  void setComponent(int index) {
    if (index>graph._RLColors.size()) {
      primary=relay=gui.mainColor;
      if (component==null)
        component=new Component(primary, relay);
      else
        component.reset(primary, relay);
    } else {
      component=graph.getBackbone(index-1);
      primary=component.primary;
      relay=component.relay;
    }
    reset();
  }
  int getAmount() {
    return graph._RLColors.size();
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Relay coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
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
    runtimeData(16);
  }
}
