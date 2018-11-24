abstract class Bipartite extends Procedure implements Screen {
  int _N, _E, amount;
  Color primary, relay;
  Region region=new Region();
  Slider edgeWeight=new Slider("Edge weight"), backbone=new Slider("Backbone #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  ExTable table;
  int[][] nodes=new int[2][8];//0-> primary, 1-> relay
  String[] headers={"Degree", "Primary", "Relay", "Total"}, modalLabels={"Table", "Plot"};
  Plot plot=new Plot("Degree", "Vertex", 3);
  color[] colour={color(random(128, 256), random(128, 256), random(128, 256)), color(random(128, 256), random(128, 256), random(128, 256)), color(random(128, 256), random(128, 256), random(128, 256))};
  Component component;
  ListIterator<Checker> partsIterator;
  HashSet<Vertex> domain=new HashSet<Vertex>();
  Switcher showEdge=new Switcher("Edge", "Edge"), showRegion=new Switcher("Region", "Region");
  Checker minorComponents=new Checker("Minor components"), giantComponent=new Checker("Giant component"), tails=new Checker("Tails"), minorBlocks=new Checker("Minor blocks"), giantBlock=new Checker("Giant block"), primaryPlot=new Checker("Primary plot"), relayPlot=new Checker("Relay plot"), totalPlot=new Checker("Total plot");
  Radio modals=new Radio(modalLabels);
  Bipartite() {
    parts.addLast(minorComponents);
    parts.addLast(giantComponent);
    parts.addLast(tails);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    tunes.addLast(edgeWeight);
    tunes.addLast(backbone);
    table=new ExTable(headers, 8);
  }
  abstract void setComponent(int index);//index starts from 1
  void setting() {
    initialize();
    showNode.value=showEdge.value=minorComponents.value=giantComponent.value=minorBlocks.value=giantBlock.value=primaryPlot.value=relayPlot.value=totalPlot.value=true;
    tails.value=showRegion.value=false;
    edgeWeight.setPreference(gui.unit(0.0005), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    setComponent(1);
    backbone.setValue(1);
    backbone.setPreference(1, amount);
  }
  void resetParts() {
    partsIterator=parts.listIterator(1);
    if (partsIterator.next()==giantBlock) {
      partsIterator.remove();
      partsIterator.next();
      partsIterator.remove();
      partsIterator.add(giantComponent);
    }
  }
  void reset() {
    resetParts();
    if (component==null)
      component=new Component(primary, relay);
    else
      component.reset(primary, relay);
    plot.setRange(0, 7, 0, primary.vertices.size()+relay.vertices.size());
    region.amount=round(regionAmount.value);
    interval.setPreference(1, ceil((primary.vertices.size()+relay.vertices.size())/3.0), 1);
  }
  void restart() {
    component.restart();
    resetParts();
  }
  void deploying() {
    for (int i=0; i<interval.value; i++) {
      if (play.value&&!component.deleting()) {
        partsIterator=parts.listIterator(1);
        if (partsIterator.next()==giantComponent) {
          partsIterator.remove();
          partsIterator.add(giantBlock);
          partsIterator.add(minorBlocks);
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
    }
  }
  void show() {
    _N=_E=0;//mainColor->giantBlock partsColor[0]->minorBlocks partsColor[1]->tails partsColor[2]->minorComponents
    for (int i=0; i<2; i++)
      for (int j=0; j<8; j++)
        nodes[i][j]=0;
    domain.clear();
    if (component.goOn()) {
      if (giantComponent.value)
        for (int i=1; i<component.degreeList.length; i++)
          for (Vertex nodeA=component.degreeList[i].next; nodeA!=null; nodeA=nodeA.next) {
            if (showEdge.value) {
              int count=0;
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                if (nodeB.order==-2&&!tails.value)
                  count++;
                else {
                  stroke(nodeB.order==-2?gui.partColor[1].value:gui.mainColor.value);
                  displayEdge(nodeA, nodeB);
                }
              nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
            }
            displayNode(nodeA);
          }
    } else {
      if (giantBlock.value)
        for (Vertex nodeA : component.giant[0]) {
          if (showEdge.value) {
            int count=0;
            strokeWeight(edgeWeight.value);
            for (Vertex nodeB : nodeA.links)
              if (nodeB.order==-2&&!tails.value)
                count++;
              else if (nodeB.order>-2&&!minorBlocks.value)
                count++;
              else {
                if (nodeB.order==-2)
                  stroke(gui.partColor[1].value);
                else if (nodeB.order>-2)
                  stroke(gui.partColor[0].value);
                else
                  stroke(gui.mainColor.value);
                displayEdge(nodeA, nodeB);
              }
            nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
          }
          displayNode(nodeA);
        }
      if (minorBlocks.value) {
        for (LinkedList<Vertex> list : component.blocks)
          if (component.giant[0]!=list)
            for (Vertex nodeA : list)
              if (nodeA.order!=-1&&nodeA.order!=-3) {
                if (showEdge.value) {
                  stroke(gui.partColor[0].value);
                  strokeWeight(edgeWeight.value);
                  for (Vertex nodeB : nodeA.links)
                    displayEdge(nodeA, nodeB);
                  nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()]++;
                }
                displayNode(nodeA);
              }
        for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
          Vertex nodeA=i.previous().getLast();
          if (nodeA.order==-3) {
            if (!giantBlock.value) {
              if (showEdge.value) {
                int count=0;
                stroke(gui.partColor[0].value);
                strokeWeight(edgeWeight.value);
                for (Vertex nodeB : nodeA.links)
                  if (nodeB.order==-4)
                    count++;
                  else
                    displayEdge(nodeA, nodeB);
                nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()-count]++;
              }
              displayNode(nodeA);
            }
          } else {
            if (showEdge.value) {
              stroke(gui.partColor[0].value);
              strokeWeight(edgeWeight.value);
              for (Vertex nodeB : nodeA.links)
                displayEdge(nodeA, nodeB);
              nodes[nodeA.primeColor==primary?0:1][nodeA.links.size()]++;
            }
            displayNode(nodeA);
          }
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
            if (component.goOn())
              if (nodeB.order!=-2&&!giantComponent.value)
                count++;
              else
                displayEdge(nodeA, nodeB);
            else if (nodeB.order<-2&&!giantBlock.value||nodeB.order>-2&&!minorBlocks.value)
              count++;
            else
              displayEdge(nodeA, nodeB);
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
    if (region.amount!=_N) {
      region.amount=_N;
      regionAmount.max=_N;
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
    int len=6;
    if (!colour.nodeIterator.hasNext()&&graph.topology.value<5) {//Only calculate faces for 2D and sphere topologies since begin from topoloty torus, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len=11;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=showEdge.value?_E-colour.vertices.size()+graph.topology.characteristic():0;
      word[7]="Faces: "+faces;
      word[8]=String.format("Average face size: %.2f", faces>0?_E*2.0/faces:0);
      word[9]=showEdge.value?String.format("3-cycle faces: %d (%.2f%%)", colour.cycles[0], colour.cycles[0]*100.0/faces):"3-cycle faces: 0 (0.00%)";
      word[10]=showEdge.value?String.format("4-cycle faces: %d (%.2f%%)", colour.cycles[1], colour.cycles[1]*100.0/faces):"4-cycle faces: 0 (0.00%)";
    }
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+1+i));
  }
  void displayEdge(Vertex nodeA, Vertex nodeB) {
    if (nodeA.value<nodeB.value) {
      ++_E;
      line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
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
  void moreControls(float y) {
    fill(gui.headColor[2].value);
    text("Chart modals:", width-gui.margin()+gui.body.stepX(), y);
    modals.display(width-gui.margin()+gui.body.stepX(2), y+gui.body.stepY(0.5));
  }
  void moreMouseReleases() {
    if (backbone.active())
      setComponent(round(backbone.value));
    if (modals.active()) {
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
    if (showRegion.active())
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
  }
  void moreKeyPresses() {
    if (key==CODED)
      switch(keyCode) {
      case LEFT:
        if (backbone.value==backbone.min)
          backbone.setValue(backbone.max);
        else
          backbone.decreaseValue();
        setComponent(round(backbone.value));
        break;
      case RIGHT:
        if (backbone.value==backbone.max)
          backbone.setValue(backbone.min);
        else
          backbone.increaseValue();
        setComponent(round(backbone.value));
        break;
      case UP:
        if (showRegion.value) {
          if (regionAmount.value==regionAmount.max)
            regionAmount.setValue(regionAmount.min);
          else
            regionAmount.increaseValue();
          region.amount=round(regionAmount.value);
        }
        break;
      case DOWN:
        if (showRegion.value) {
          if (regionAmount.value==regionAmount.min)
            regionAmount.setValue(regionAmount.max);
          else
            regionAmount.decreaseValue();
          region.amount=round(regionAmount.value);
        }
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
  int components() {
    int amount=0;
    if (component.goOn()) {
      if (giantComponent.value)
        amount+=1;
      else if (tails.value) {
        component.countTails();
        amount+=component.tailsToTwoCore();
      }
    } else {
      if (giantBlock.value||minorBlocks.value)
        amount+=1;
      if (tails.value)
        if (!giantBlock.value&&!minorBlocks.value) {
          component.countTails();
          amount+=component.tailsToTwoCore();
        } else if (!giantBlock.value) {
          component.countTails();
          amount+=component.tailsToGiant();
        } else if (!minorBlocks.value) {
          component.countTails();
          amount+=component.tailsToMinors();
        }
    }
    if (minorComponents.value)
      amount+=component.components.size()-2+component.components.getFirst().size();
    return amount;
  }
  void setTable() {
    for (int i=0; i<8; i++) {
      table.setInt(7-i, 3, nodes[0][i]+nodes[1][i]);
      table.setInt(7-i, 0, i);
      for (int j=0; j<2; j++)
        table.setInt(7-i, j+1, nodes[j][i]);
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
}
