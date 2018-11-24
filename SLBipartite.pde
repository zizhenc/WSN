class SLBipartite extends Bipartite {
  SLBipartite() {
    word=new String[10];
  }
  void setComponent(int index) {
    int size=graph._SLColors.size();
    amount=size*(size-1)/2;
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
    reset();
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Smallest-last coloring bipartites...", gui.body.stepX(), gui.body.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.body.stepX(2), gui.body.stepY(2));
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
    for (int i=0; i<10; i++)
      text(word[i], gui.body.stepX(3), gui.body.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.body.stepX(2), gui.body.stepY(13));
    word[0]="Vertices: "+_N;
    word[1]="Edges: "+_E;
    word[2]=String.format("Average degree: %.2f", _E*2.0/_N);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0/graph.vertex.length);
    word[4]="Components: "+components();  
    int len=6;//goOn?6:7;
    if (graph.topology.value<5) {
      len=8;//goOn?8:9;
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[5]="Faces: "+faces;
      word[6]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
    }
    //if (!goOn)
    word[len-2]="Giant component blocks: "+(component.block.giant==gui.mainColor.vertices?0:component.block.minors.size()+1);
    word[len-1]="Primary partite #"+(primary.index+1)+" & relay partite #"+(relay.index+1);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<len; i++)
      text(word[i], gui.body.stepX(3), gui.body.stepY(14+i));
    if (modals.value==1) {
      setPlot();
      plot.initialize(gui.body.stepX(2), gui.body.stepY(14+len), gui.margin(), gui.margin());
      plot.frame();
      if (primaryPlot.value) {
        stroke(colour[0]);
        strokeWeight(gui.unit());
        plot.linesAt(0);
        strokeWeight(gui.unit(4));
        plot.pointsAt(0);
      }
      if (relayPlot.value) {
        stroke(colour[1]);
        strokeWeight(gui.unit());
        plot.linesAt(1);
        strokeWeight(gui.unit(4));
        plot.pointsAt(1);
      }
      if (totalPlot.value) {
        stroke(colour[2]);
        strokeWeight(gui.unit());
        plot.linesAt(2);
        strokeWeight(gui.unit(4));
        plot.pointsAt(2);
      }
      plot.measure();
    } else {
      setTable();
      table.display(gui.body.stepX(2), gui.body.stepY(14+len));
    }
  }
}
