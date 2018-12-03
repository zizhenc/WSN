class PrimarySet extends IndependentSet {
  PrimarySet() {
    word=new String[11];
  }
  void setColorPool() {
    colorPool=graph._PYColors;
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Primary independent sets...", gui.thisFont.stepX(), gui.thisFont.stepY());
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
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(14);
  }
}
