class SLBipartite extends Bipartite {
  SLBipartite() {
    word=new String[10];
  }
  int getAmount() {
    int size=graph._SLColors.size();
    return size*(size-1)/2;
  }
  void setComponent(int index) {
    int size=graph._SLColors.size();
    if (size<2)
      primary=relay=gui.mainColor;
    else {
      int sum=--size, primaryIndex=0, relayIndex;
      while (sum<index) {
        sum+=--size;
        primaryIndex++;
      }
      for (sum=sum-size, relayIndex=primaryIndex; sum<index; sum++, relayIndex++);
      primary=graph._SLColors.get(primaryIndex);
      relay=graph._SLColors.get(relayIndex);
    }
    if (component==null)
      component=new Component(primary, relay);
    else
      component.reset(primary, relay, 0);
    reset();
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring bipartites...", gui.thisFont.stepX(), gui.thisFont.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.thisFont.stepX(2), gui.thisFont.stepY(2));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique order: "+graph.clique.size();
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    fill(gui.bodyColor[0].value);
    for (int i=0; i<word.length; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(3+i));
    runtimeData(13);
  }
}
