abstract class Bipartite extends Procedure implements Screen {
  int _N, _E;
  boolean goOn;
  Color primary, relay;
  SysColor[] plotColor=new SysColor[3];
  Radio modes=new Radio("Table", "Bar chart");
  Region region=new Region();
  Slider backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Checker minorComponents=new Checker("Minor components"), giantComponent=new Checker("Giant component"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  ExTable table;
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  BarChart barChart=new BarChart("Degree", "Vertex", plotColor, "Primary", "Relay", "Total");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Component component;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  abstract int getAmount();
  abstract void setComponent(int index);//index starts from 1
  Bipartite() {
    parts.addLast(minorComponents);
    parts.addLast(tails);
    parts.addLast(giantComponent);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    tunes.addLast(edgeWeight);
    tunes.addLast(backbone);
    table=new ExTable(8, "Degree", "Primary", "Relay", "Total");
    plotColor[2]=gui.partColor[0];
    for (int i=0; i<8; i++)
      table.setInt(7-i, 0, i);
    barChart.setX(0, 7);
    barChart.setPoints();
    tails.value=showRegion.value=false;
  }
  void setting() {
    initialize();
    setComponent(1);
    backbone.setPreference(1, getAmount());
  }
  void resetParts() {
    goOn=true;
    if (parts.getLast()==giantBlock) {
      parts.removeLast();
      parts.removeLast();
      parts.addLast(giantComponent);
    }
  }
  void reset() {
    resetParts();
    plotColor[0]=primary;
    plotColor[1]=relay;
    barChart.setY(0, primary.vertices.size()+relay.vertices.size());
    barChart.reset();
    barChart.play=true;
    regionAmount.setPreference(1, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    interval.setPreference(1, ceil((primary.vertices.size()+relay.vertices.size())/3.0), 1);
  }
  void restart() {
    resetParts();
    component.restart();
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&!goOn) {
        if (parts.getLast()==giantComponent) {
          parts.removeLast();
          parts.addLast(minorBlocks);
          parts.addLast(giantBlock);
        }
        if (navigation.auto) {
          if (backbone.value<backbone.max) {
            backbone.increaseValue();
            setComponent(round(backbone.value));
          } else
            navigation.go(410);
        }
        play.value=navigation.auto;
      }
      if (play.value)
        goOn=component.deleting();
    }
  }
  void show() {
    clearStatistics();
    if (goOn) {
      if (giantComponent.value)
        for (int i=1; i<component.degreeList.length; i++)
          for (Vertex nodeA=component.degreeList[i].next; nodeA!=null; nodeA=nodeA.next)
            showNetwork(nodeA, gui.mainColor);
    } else {
      if (giantBlock.value)
        for (Vertex nodeA : component.giant[0])
          if (nodeA.order[component.archive]!=-3)
            showNetwork(nodeA, gui.mainColor);
      if (minorBlocks.value)
        for (LinkedList<Vertex> list : component.blocks)
          if (component.giant[0]!=list)
            for (Vertex nodeA : list)
              if (nodeA.order[component.archive]!=-1&&nodeA.order[component.archive]!=-3)
                showNetwork(nodeA, gui.partColor[0]);
      if (!component.blocks.isEmpty())
        for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
          Vertex nodeA=i.previous().getLast();
          if (minorBlocks.value||giantBlock.value&&nodeA.order[component.archive]==-3) {
            if (showEdge.value) {
              int count=0;
              for (Vertex nodeB : nodeA.links) {
                if (nodeB.order[component.archive]==-2&&!tails.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
                  count++;
                else {
                  if (nodeB.order[component.archive]==-2)
                    stroke(gui.partColor[1].value);
                  else if (nodeB.order[component.archive]>-2)
                    stroke(gui.partColor[0].value);
                  else if (nodeB.order[component.archive]<-3)
                    stroke(gui.mainColor.value);
                  else if (nodeA.order[component.archive]==-1)
                    stroke(gui.partColor[0].value);
                  else
                    stroke(gui.mainColor.value);
                  displayLink(nodeA, nodeB);
                }
              }
              analyze(nodeA, nodeA.links.size()-count);
            }
            showSensor(nodeA);
          }
        }
    }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          for (Vertex nodeB : nodeA.links)
            if (goOn) {
              if (nodeB.order[component.archive]!=-2&&!giantComponent.value)
                count++;
              else
                displayLink(nodeA, nodeB);
            } else {
              if (nodeB.order[component.archive]<-3&&!giantBlock.value||nodeB.order[component.archive]>-2&&!minorBlocks.value||nodeB.order[component.archive]==-3&&!giantBlock.value&&!minorBlocks.value)
                count++;
              else
                displayLink(nodeA, nodeB);
            }
          analyze(nodeA, nodeA.links.size()-count);
        }
        showSensor(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              analyze(nodeA, nodeA.links.size());
              stroke(gui.partColor[2].value);
              for (Vertex nodeB : nodeA.links)
                displayLink(nodeA, nodeB);
            }
            showSensor(nodeA);
          }
  }
  void showNetwork(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[component.archive]==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order[component.archive]==-2?gui.partColor[1].value:colour.value);
          displayLink(nodeA, nodeB);
        }
      analyze(nodeA, nodeA.links.size()-count);
    }
    showSensor(nodeA);
  }
  void showSensor(Vertex nodeA) {
    if (showNode.value||showRegion.value) {
      ++_N;
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
    }
    if (showNode.value) {
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode(nodeA);
    }
    if (showRegion.value) {
      strokeWeight(edgeWeight.value);
      region.display(_N, nodeA);
    }
  }
  void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", _N, _N*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", showNode.value?_E*2.0/_N:0);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0/graph.vertex.length);
    word[4]="Components: "+components();
    if (!goOn)
      word[5]="Giant component blocks: "+component.blocks.size();
    int len=goOn?5:6;
    if (graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len+=2;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=_E-_N+components()+graph.topology.characteristic()-1;
      word[len-2]="Faces: "+faces;
      word[len-1]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
    }
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+i+1));
    fill(primary.value);
    text("Primary partite #"+(primary.index+1), gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+len+1));
    fill(gui.bodyColor[0].value);
    text(" & ", gui.thisFont.stepX(3)+textWidth("Primary partite #"+(primary.index+1)), gui.thisFont.stepY(startHeight+len+1));
    fill(relay.value);
    text("relay partite #"+(relay.index+1), gui.thisFont.stepX(3)+textWidth("Primary partite #"+(primary.index+1)+" & "), gui.thisFont.stepY(startHeight+len+1));
    if (modes.value==1) {
      barChart.showFrame(gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+len+1)+gui.thisFont.gap(), gui.margin(), gui.margin());
      barChart.showLabels(gui.thisFont.stepX(2)+gui.margin()-textWidth("Degree"), gui.thisFont.stepY(startHeight+len+3));
      strokeWeight(7.5);
      barChart.drawPlot[0].display();
      barChart.showMeasurement();
    } else
      table.display(gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+len+1)+gui.thisFont.gap());
  }
  void displayLink(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      displayEdge(nodeA, nodeB);
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart mode:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY());
    modes.display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY()+gui.thisFont.gap());
    if (modes.value==1) {
      fill(gui.headColor[2].value);
      text("Plots:", width-gui.margin()+gui.thisFont.stepX(), y+gui.thisFont.stepY(2)+gui.thisFont.gap()+modes.radioHeight);
      for (int i=0; i<plot.length; i++)
        plot[i].display(width-gui.margin()+gui.thisFont.stepX(2), y+gui.thisFont.stepY(2)+gui.thisFont.gap(2)+modes.radioHeight+(plot[0].checkerHeight+gui.thisFont.gap())*i);
    }
  }
  void moreMousePresses() {
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  void moreMouseReleases() {
    if (modes.active())
      modes.commit();
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (modes.value==1)
      for (int i=0; i<plot.length; i++)
        if (plot[i].active()) {
          plot[i].commit();
          barChart.setPlot(i, plot[i].value);
        }
    if (backbone.active())
      setComponent(round(backbone.value));
  }
  void moreKeyPresses() {
    switch(key) {
    case '+':
    case '=':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.max)
          regionAmount.setValue(regionAmount.min);
        else
          regionAmount.increaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case '-':
    case '_':
      if (showRegion.value) {
        if (regionAmount.value==regionAmount.min)
          regionAmount.setValue(regionAmount.max);
        else
          regionAmount.decreaseValue();
        region.amount=round(regionAmount.value);
      }
      break;
    case ',':
    case '<':
      if (backbone.value==backbone.min)
        backbone.setValue(backbone.max);
      else
        backbone.decreaseValue();
      setComponent(round(backbone.value));
      break;
    case '.':
    case '>':
      if (backbone.value==backbone.max)
        backbone.setValue(backbone.min);
      else
        backbone.increaseValue();
      setComponent(round(backbone.value));
    }
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.commit();
      break;
    case 't':
      showRegion.commit();
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    }
  }
  int components() {
    int amount=0;
    if (goOn) {
      if (giantComponent.value)
        amount=component.giant[1].isEmpty()?0:1;
      else if (tails.value) {
        component.countTails();
        amount=component.tails[0];
      }
    } else {
      if (giantBlock.value&&minorBlocks.value)
        amount=component.giant[0].isEmpty()?0:1;
      else if (giantBlock.value) {
        if (!component.giant[0].isEmpty())
          amount=1;
      } else if (minorBlocks.value) {
        amount=component.tails[4];
      }
      if (tails.value) {
        if (!giantBlock.value&&!minorBlocks.value)
          amount+=component.tails[0];
        else if (!giantBlock.value)
          amount+=component.tailsXMinors();
        else if (!minorBlocks.value)
          amount+=component.tailsXGiant();
      }
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
  void clearStatistics() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    domain.clear();
    switch(modes.value) {
    case 0:
      for (int i=0; i<8; i++)
        for (int j=0; j<plot.length; j++)
          table.setInt(i, j+1, 0);
      break;
    case 1:
      for (ArrayList<Float> point : barChart.points)
        for (int i=0; i<8; i++)
          point.set(i, 0f);
    }
  }
  void analyze(Vertex node, int degree) {
    int category=node.primeColor==primary?0:1;
    switch(modes.value) {
    case 0:
      table.setInt(7-degree, category+1, table.getInt(7-degree, category+1)+1);
      table.setInt(7-degree, 3, table.getInt(7-degree, 3)+1);
      break;
    case 1:
      barChart.points[category].set(degree, barChart.points[category].get(degree)+1);
      barChart.points[2].set(degree, barChart.points[2].get(degree)+1);
    }
  }
}
