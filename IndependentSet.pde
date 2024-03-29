abstract class IndependentSet extends Result implements Screen {
  int _E;
  Color colour;
  Slider partiteIndex=new Slider("Partite #", 1, 1), regionAmount=new Slider("Region amount", 1, 1);
  Region region=new Region();
  Vertex middleNode=new Vertex();
  Checker partite=new Checker("Partite");
  Switcher showRegion=new Switcher("Region [t]", "Region [t]"), showMeasurement=new Switcher("Measurement [m]", "Measurement [m]"), arrow=new Switcher("Arrow [k]", "Arrow [k]");
  HashSet<Vertex> domain=new HashSet<Vertex>();
  ArrayList<Color> colorPool;
  abstract void setColorPool();
  IndependentSet() {
    parts.addLast(partite);
    switches.addLast(showRegion);
    switches.addLast(showMeasurement);
    tunes.addLast(partiteIndex);
    showMeasurement.value=showRegion.value=false;
  }
  void setting() {
    initialize();
    setColorPool();
    partiteIndex.setPreference(1, colorPool.size());
    setPartite();
  }
  void show() {
    _E=0;
    for (ListIterator<Vertex> i=colour.vertices.listIterator(); i.hasNext(); ) {
      Vertex nodeA=i.next();
      if (showEdge.value)
        if (showMeasurement.value) {
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              middleNode.setCoordinates((nodeA.x+nodeB.x)/2, (nodeA.y+nodeB.y)/2, (nodeA.z+nodeB.z)/2);
              stroke(gui.partColor[nodeA.value<nodeB.value?1:2].value);
              displayEdge(nodeA, middleNode);
              stroke(gui.partColor[nodeA.value<nodeB.value?2:1].value);
              displayEdge(middleNode, nodeB);
              if (arrow.value)
                arrow((float)nodeA.x, (float)nodeA.y, (float)nodeA.z, (float)nodeB.x, (float)nodeB.y, (float)nodeB.z);
            }
        } else if (partite.value) {
          stroke(colour.value);
          for (Vertex nodeB : nodeA.arcs)
            if (nodeA.value<nodeB.value) {
              _E++;
              displayEdge(nodeA, nodeB);
            }
        }
      if (partite.value) {
        if (showRegion.value) {
          strokeWeight(edgeWeight.value);
          region.display(i.nextIndex(), nodeA);
        }
        if (showNode.value) {
          stroke(colour.value);
          displayNode(nodeA);
        }
      }
    }
  }
  void moreMousePresses() {
    if (showRegion.value&&regionAmount.active())
      region.amount=round(regionAmount.value);
    if (partiteIndex.active())
      setPartite();
  }
  void moreMouseReleases() {
    if (showRegion.active())
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
    if (showMeasurement.active())
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
    if (showMeasurement.value)
      arrow.active();
  }
  void moreKeyReleases() {
    switch (Character.toLowerCase(key)) {
    case 't':
      showRegion.commit();
      if (showRegion.value)
        tunes.addLast(regionAmount);
      else
        tunes.removeLast();
      break;
    case 'k':
      arrow.commit();
      break;
    case 'm':
      showMeasurement.commit();
      if (showMeasurement.value)
        switches.addLast(arrow);
      else
        switches.removeLast();
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
    while (colour.deploy==1)
      colour.deploying();
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
      vertex(0, -gui.unit(0.005), 0);
      vertex(gui.unit(0.004)*cos(angle), gui.unit(0.002), gui.unit(0.004)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    angle = 0;
    beginShape(TRIANGLE_FAN);
    vertex(0, gui.unit(0.003), 0);
    for (int i = 0; i < 5; i++) {
      vertex(gui.unit(0.004)*cos(angle), gui.unit(0.002), gui.unit(0.004)*sin(angle));
      angle += angleIncrement;
    }
    endShape();
    popMatrix();
  }
  void runtimeData(int startHeight) {
    fill(gui.headColor[2].value);
    text("Runtime data:", gui.thisFont.stepX(2), gui.thisFont.stepY(startHeight));
    fill(gui.bodyColor[0].value);
    word[0]=String.format("Nodes: %d (%.2f %%)", (showNode.value&&partite.value)?colour.vertices.size():0, ((showNode.value&&partite.value)?colour.vertices.size():0)*100.0/graph.vertex.length);
    word[1]=String.format("Edges: %d (%.2f %%)", _E, _E*100.0/graph._E);
    word[2]=String.format("Average degree: %.2f", (showNode.value&&partite.value)?_E*2.0/colour.vertices.size():0);
    int domination=partite.value&&showNode.value?colour.domination:0;
    word[3]=String.format("Dominates: %d (%.2f%%)", domination, domination*100.0/graph.vertex.length);
    word[4]=String.format("Maximum distance: %.3f", (_E==0)?0:colour.maxDistance);
    word[5]=String.format("Minimum distance: %.3f", (_E==0)?0:colour.minDistance);
    word[6]=String.format("Average distance: %.3f", (_E==0)?0:colour.distance/_E);
    int len=8;
    if (graph.topology.value<7) {//For torus and Klein bottle, if #of vertices is really small the cooresponding gabriel graph will change topology, then the face calculation would be wrong
      len=10;//another problem is to get rid of out face, which will influence cycle calculation if the # of vertices is small (Imagine if the out face has 3 or 4 boundaries, too).
      int faces=showEdge.value?_E-colour.vertices.size()+graph.topology.characteristic():0;
      word[7]="Faces: "+faces;
      word[8]=showEdge.value?String.format("Degree-3 faces: %d (%.2f%%)", colour.cycles, colour.cycles*100.0/faces):"Degree-3 faces: 0 (0.00%)";
    }
    word[len-1]="Color #"+colour.index;
    for (int i=0; i<len; i++)
      text(word[i], gui.thisFont.stepX(3), gui.thisFont.stepY(startHeight+1+i));
  }
}
