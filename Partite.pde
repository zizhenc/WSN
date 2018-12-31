abstract class Partite extends Procedure implements Screen {
  int _E;
  Color colour;
  Slider partiteIndex=new Slider("Partite #", 1, 1), regionAmount=new Slider("Region amount", 1, 1), edgeWeight=new Slider("Edge weight"), arrowWeight=new Slider("Arrow weight");
  Region region=new Region();
  Vertex nodeM=new Vertex();
  Checker partite=new Checker("Partite");
  Switcher showRegion=new Switcher("Region", "Region"), showEdge=new Switcher("Edge", "Edge"), directed=new Switcher("Undirected", "Directed"), showMeasurement=new Switcher("Measurement", "Measurement");
  HashSet<Vertex> domain=new HashSet<Vertex>();
  ArrayList<Color> colorPool;
  abstract void setColorPool();
  Partite() {
    parts.addLast(partite);
    switches.addLast(showEdge);
    switches.addLast(showRegion);
    switches.addLast(showMeasurement);
    switches.addLast(directed);
    tunes.addLast(edgeWeight);
    tunes.addLast(arrowWeight);
    tunes.addLast(partiteIndex);
  }
  void setting() {
    initialize();
    partite.value=true;
    showMeasurement.value=directed.value=showRegion.value=false;
    edgeWeight.setPreference(gui.unit(0.0005), gui.unit(0.000025), gui.unit(0.002), gui.unit(0.00025), gui.unit(1000));
    arrowWeight.setPreference(gui.unit(0.0005), gui.unit(0.000025), gui.unit(0.001), gui.unit(0.00025), gui.unit(1000));
    setColorPool();
    partiteIndex.setPreference(1, colorPool.size());
    setPartite();
    updateTunes();
  }
  void restart() {
    colour.restart();
  }
  void deploying() {
    for (int i=0; i<interval.value; i++)
      if (play.value&&!colour.deploying()) {
        if (navigation.auto) {
          if (partiteIndex.value<partiteIndex.max) {
            partiteIndex.increaseValue();
            setPartite();
          } else
            navigation.go(401);
        }
        play.value=navigation.auto;
      }
  }
  void updateTunes() {
    if (showEdge.value) {
      if (switches.getLast()!=directed) {
        switches.addLast(showMeasurement);
        switches.addLast(directed);
      }
    } else {
      if (switches.getLast()==directed) {
        switches.removeLast();
        switches.removeLast();
      }
    }
  }
  void show() {
    if (partite.value) {
      _E=0;
      for (ListIterator<Vertex> i=colour.vertices.listIterator(); i.hasNext(); ) {
        Vertex nodeA=i.next();
        if (showEdge.value) {
          stroke(gui.mainColor.value);
          strokeWeight(edgeWeight.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              if (showMeasurement.value) {
                nodeM.setCoordinates((nodeA.x+nodeB.x)/2, (nodeA.y+nodeB.y)/2, (nodeA.z+nodeB.z)/2);
                stroke(gui.partColor[nodeA.value<nodeB.value?1:2].value);
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeM.x, (float)nodeM.y, (float)nodeM.z);
                stroke(gui.partColor[nodeA.value<nodeB.value?2:1].value);
                line((float)nodeM.x, (float)nodeM.y, (float)nodeM.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              } else
                line((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
              if (directed.value) {
                if (nodeA.value<nodeB.value)
                  arrow((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
                else
                  arrow((float)nodeB.x, (float)nodeB.y, (float)nodeB.z, (float)nodeA.x, (float)nodeA.y, (float)nodeA.z);
              }
            }
        }
        if (showNode.value) {
          stroke(colour.value);
          displayNode(nodeA);
          if (showRegion.value) {
            strokeWeight(edgeWeight.value);
            region.display(i.nextIndex(), nodeA);
          }
        }
      }
    }
  }
  void moreMouseReleases() {
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
    if (partiteIndex.active())
      setPartite();
    if (showEdge.active())
      updateTunes();
    if (showRegion.active())
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 'e':
      showEdge.value=!showEdge.value;
      updateTunes();
      break;
    case 't':
      showRegion.value=!showRegion.value;
      if (showRegion.value) {
        if (tunes.getLast()!=regionAmount)
          tunes.addLast(regionAmount);
      } else if (tunes.getLast()==regionAmount)
        tunes.removeLast();
      break;
    case 'm':
      showMeasurement.value=!showMeasurement.value;
      break;
    case 'u':
      directed.value=!directed.value;
    }
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
      if (partiteIndex.value==partiteIndex.min)
        partiteIndex.setValue(partiteIndex.max);
      else
        partiteIndex.decreaseValue();
      setPartite();
      break;
    case '.':
    case '>':
      if (partiteIndex.value==partiteIndex.max)
        partiteIndex.setValue(partiteIndex.min);
      else
        partiteIndex.increaseValue();
      setPartite();
    }
  }
  void setPartite() {//start from 1
    if (colorPool.isEmpty())
      colour=gui.mainColor;
    else
      colour=colorPool.get(round(partiteIndex.value)-1);
    colour.initialize(domain);
    regionAmount.setPreference(1, colour.vertices.size());
    region.amount=round(regionAmount.value);
    interval.setPreference(1, ceil(colour.vertices.size()/3.0), 1);
  }
  void arrow(float x1, float y1, float z1, float x2, float y2, float z2) {
    noFill();
    PVector tangent=new PVector(x2-x1, y2-y1, z2-z1), yAxis=new PVector(0, 1, 0), normal=tangent.cross(yAxis);
    pushMatrix();
    translate((x1+x2)/2, (y1+y2)/2, (z1+z2)/2);
    rotate(-PVector.angleBetween(tangent, yAxis), normal.x, normal.y, normal.z);
    float angle = 0, angleIncrement = TWO_PI/4;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < 5; ++i) {
      vertex(0, -arrowWeight.value*5, 0);
      vertex(arrowWeight.value*4*cos(angle), arrowWeight.value*3, arrowWeight.value*4*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    angle = 0;
    beginShape(TRIANGLE_FAN);
    vertex(0, arrowWeight.value*3, 0);
    for (int i = 0; i < 5; i++) {
      vertex(arrowWeight.value*4*cos(angle), arrowWeight.value*3, arrowWeight.value*4*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    popMatrix();
  }
  void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Vertices: %d (%.2f %%)", (showNode.value&&partite.value)?colour.vertices.size():0, ((showNode.value&&partite.value)?colour.vertices.size():0)*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", (showNode.value&&partite.value)?_E*2.0/colour.vertices.size():0);
    word[3]=String.format("Dominates: %d (%.2f%%)", colour.domination, colour.domination*100.0/graph.vertex.length);
    word[4]=String.format("Maximum distance: %.3f", (_E==0)?0:colour.maxDistance);
    word[5]=String.format("Minimum distance: %.3f", (_E==0)?0:colour.minDistance);
    word[6]=String.format("Average distance: %.3f", (_E==0)?0:colour.distance/_E);
    int len=7;
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
}
