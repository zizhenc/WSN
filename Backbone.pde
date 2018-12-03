class Backbone extends Result implements Screen {
  int _N, _E;
  int[][] nodes=new int[2][8];//0-> primary, 1-> relay
  String[] headers={"Degree", "Primary", "Relay", "Total"}, modalLabels={"Table", "Bar chart"};
  Color primary, relay;
  Radio modals=new Radio(modalLabels);
  Region region=new Region();
  Slider edgeWeight=new Slider("Edge weight"), backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  ExTable table;
  BarChart barChart=new BarChart("Degree", "Vertex", new String[]{"Primary", "Relay", "Total"});
  Component component;
  ListIterator<Checker> partsIterator;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  Checker minorComponents=new Checker("Minor components"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block");
  Checker[] plot={new Checker("Primary"), new Checker("Relay"), new Checker("Total")};
  Backbone() {
    word=new String[13];
    parts.addLast(minorComponents);
    parts.addLast(giantBlock);
    parts.addLast(minorBlocks);
    parts.addLast(tails);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    tunes.addLast(edgeWeight);
    tunes.addLast(backbone);
    table=new ExTable(headers, 8);
  }
  void setting() {
    initialize();
    showNode.value=showEdge.value=giantBlock.value=plot[0].value=plot[1].value=plot[2].value=true;
    tails.value=showRegion.value=minorComponents.value=minorBlocks.value=false;
    edgeWeight.setPreference(gui.unit(0.0005), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    for (int i=0; i<plot.length; i++)
      barChart.setPlot(i, plot[i].value);
    setComponent(1);
    backbone.setPreference(1, graph._RLColors.size());
  }
  void setComponent(int index) {
    if (graph._RLColors.isEmpty()) {
      primary=relay=gui.mainColor;
      component=new NeoComponent(primary, relay);
    } else {
      if (graph.component[index]==null) {
        relay=graph._RLColors.get(index);
        primary=graph._PYColors.get(relay.index-graph._SLColors.size());
        component=graph.component[index]=new NeoComponent(primary, relay);
      } else {
        component=graph.component[index];
        primary=component.primary;
        relay=component.relay;
      }
    }
    region.amount=round(regionAmount.value);
    plot.setRange(0, 7, 0, primary.vertices.size()+relay.vertices.size());
  }
  void show() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    for (int i=0; i<2; i++)
      for (int j=0; j<8; j++)
        nodes[i][j]=0;
    domain.clear();
    if (goOn) {
      if (giantComponent.value)
        for (int i=1; i<component.degreeList.length; i++)
          for (Vertex nodeA=component.degreeList[i].next; nodeA!=null; nodeA=nodeA.next) {
            displayEdge(nodeA, gui.mainColor);
            displayNode(nodeA);
          }
    } else {
      if (giantBlock.value)
        for (Vertex nodeA : component.giant[0])
          if (nodeA.order!=-3) {
            displayEdge(nodeA, gui.mainColor);
            displayNode(nodeA);
          }
      if (minorBlocks.value)
        for (LinkedList<Vertex> list : component.blocks)
          if (component.giant[0]!=list)
            for (Vertex nodeA : list)
              if (nodeA.order!=-1&&nodeA.order!=-3) {
                displayEdge(nodeA, gui.partColor[0]);
                displayNode(nodeA);
              }
      if (!component.blocks.isEmpty())
        for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
          Vertex nodeA=i.previous().getLast();
          if (minorBlocks.value||giantBlock.value&&nodeA.order==-3) {
            if (showEdge.value) {
              int count=0;
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links) {
                if (nodeB.order==-2&&!tails.value||nodeB.order>-2&&!minorBlocks.value||nodeB.order<-2&&!giantBlock.value)
                  count++;
                else {
                  if (nodeB.order==-2)
                    stroke(gui.partColor[1].value);
                  else if (nodeB.order>-2)
                    stroke(gui.partColor[0].value);
                  else if (nodeB.order<-2)
                    stroke(gui.mainColor.value);
                  displayEdge(nodeA, nodeB);
                }
              }
              nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
            }
            displayNode(nodeA);
          }
        }
    }
    if (tails.value)
      for (Vertex nodeA=component.degreeList[0].next; nodeA!=null; nodeA=nodeA.next) {
        if (showEdge.value) {
          int count=0;
          stroke(gui.partColor[1].value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.links)
            if (goOn) {
              if (nodeB.order!=-2&&!giantComponent.value)
                count++;
              else
                displayEdge(nodeA, nodeB);
            } else {
              if (nodeB.order<-2&&!giantBlock.value||nodeB.order>-2&&!minorBlocks.value)
                count++;
              else
                displayEdge(nodeA, nodeB);
            }
          nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
        }
        displayNode(nodeA);
      }
    if (minorComponents.value)
      for (LinkedList<Vertex> list : component.components)
        if (list!=component.giant[1])
          for (Vertex nodeA : list) {
            if (showEdge.value) {
              nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()]++;
              stroke(gui.partColor[2].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
            }
            displayNode(nodeA);
          }
  }
  void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
    }
  }
  void displayEdge(Vertex nodeA, SysColor colour) {
    if (showEdge.value) {
      int count=0;
      strokeWeight(edgeWeight.value);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order==-2&&!tails.value)
          count++;
        else {
          stroke(nodeB.order==-2?gui.partColor[1].value:colour.value);
          displayEdge(nodeA, nodeB);
        }
      nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
    }
  }
  void displayNode(Vertex nodeA) {
    if (showNode.value) {
      domain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain.add(nodeB);
      ++_N;
      if (showRegion.value)
        region.display(_N, nodeA);
      stroke((nodeA.primeColor==primary?primary:relay).value);
      displayNode((float)nodeA.x, (float)nodeA.y, (float)nodeA.z);
    }
  }
  void setDomains(Vertex nodeA) {
    domain.add(nodeA);
    for (Vertex nodeB : nodeA.neighbors)
      domain.add(nodeB);
  }
  void setTable() {
    for (int i=0; i<8; i++) {
      table.setInt(7-i, 3, round(nodes[0][i]+nodes[1][i]));
      table.setInt(7-i, 0, i);
      for (int j=0; j<2; j++)
        table.setInt(7-i, j+1, round(nodes[j][i]));
    }
  }
  void setPlot() {
    plot.clean();
    for (int i=0; i<8; i++) {
      plot.points[0].addLast(nodes[0][i]+0.0);
      plot.points[1].addLast(nodes[1][i]+0.0);
      plot.points[2].addLast(nodes[0][i]+nodes[1][i]+0.0);
    }
  }
  int components() {
    if (component.giant.isEmpty())
      return 0;
    else {
      int sum=0;
      if (minorComponents.value)
        sum+=component.minors.size();
      if (giantBlock.value&&minorBlocks.value)
        sum+=1;
      else {
        if (tails.value) {
          sum+=component.tailSize[0];
          if (giantBlock.value)
            sum-=component.tailSize[1]-1;
          else if (minorBlocks.value)
            sum-=component.tailSize[2]-component.block.minorSize;
        } else if (giantBlock.value)
          sum+=1;
        else if (minorBlocks.value)
          sum+=component.block.minorSize;
      }
      return sum;
    }
  }
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart modals:", width-gui.body.margin()+gui.body.stepX(), y);
    modals.display(width-gui.body.margin()+gui.body.stepX(2), y+gui.body.stepY(0.5));
  }
  void moreMouseReleases() {
    if (backbone.inRange())
      setComponent(round(backbone.value)-1);
    if (modals.inRange()) {
      if (modals.value==0) {
        if (parts.getLast()==totalPlot)
          for (int i=0; i<3; i++)
            parts.removeLast();
      } else if (parts.getLast()!=totalPlot) {
        parts.addLast(primaryPlot);
        parts.addLast(relayPlot);
        parts.addLast(totalPlot);
      }
    }
    if (showRegion.inRange())
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
    if (showRegion.value&&regionAmount.inRange())
      region.amount=round(regionAmount.value);
  }
  void data() {
    fill(gui.headColor[1].value);
    text("Backbones...", gui.body.stepX(), gui.body.stepY());
    fill(gui.headColor[2].value);
    text("Graph information:", gui.body.stepX(2), gui.body.stepY(2));
    word[0]="Topology: "+graph.topology;
    word[1]="N: "+graph.vertex.length;
    word[2]=String.format("r: %.3f", graph.r);
    word[3]="E: "+graph._E;
    word[4]="Deg(Max.): "+graph.maxDegree;
    word[5]="Deg(Min.): "+graph.minDegree;
    word[6]=String.format("Deg(Avg.): %.2f", graph._E*2.0/graph.vertex.length);
    word[7]="Terminal clique size: "+(graph.cliques.isEmpty()?0:graph.cliques.getFirst().size());
    word[8]="Maximum min-degree: "+graph.maxMinDegree;
    word[9]="Smallest-last coloring colors: "+graph._SLColors.size();
    word[10]=String.format("Primary colors: %d (%.2f %%)", graph._PYColors.size(), graph.primaries*100.0/graph.vertex.length);
    word[11]=String.format("Relay colors: %d (%.2f%%)", graph._RLColors.size(), (graph.vertex.length-graph.primaries-graph.surplus.size())*100.0/graph.vertex.length);
    word[12]=String.format("Surplus size: %d (%.2f%%)", graph.surplus.size(), graph.surplus.size()*100.0/graph.vertex.length);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<12; i++)
      text(word[i], gui.body.stepX(3), gui.body.stepY(3+i));
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.body.stepX(2), gui.body.stepY(15));
    word[0]="Vertices: "+_N;
    word[1]="Edges: "+_E;
    word[2]=String.format("Average degree: %.2f", _E*2.0/_N);
    word[3]=String.format("Dominates: %d (%.2f%%)", domain.size(), domain.size()*100.0/graph.vertex.length);
    word[4]="Components: "+components();
    int len=graph.topology.value<5?9:7;
    if (graph.topology.value<5) {
      int faces=getFaces(_E, _N, components());
      word[5]="Faces: "+faces;
      word[6]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
    }
    word[len-2]="Giant component blocks: "+(component.block.giant==gui.mainColor.vertices?0:component.block.minors.size()+1);
    word[len-1]="Primary set #"+(primary.index+1)+" & relay set #"+round(backbone.value);
    fill(gui.bodyColor[0].value);
    for (int i=0; i<len; i++)
      text(word[i], gui.body.stepX(3), gui.body.stepY(16+i));
    if (modals.value==1) {
      setPlot();
      plot.initialize(gui.body.stepX(2), gui.body.stepY(16+len), gui.body.margin(), gui.body.margin());
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
      table.display(gui.body.stepX(2), gui.body.stepY(16+len));
    }
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      break;
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
    }
  }
}
