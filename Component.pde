class Component {
  int order;
  Color primary, relay;
  Vertex[] degreeList;
  Stack<Vertex> stack=new Stack<Vertex>();
  LinkedList<Vertex>[] giant=new LinkedList[2];
  LinkedList<LinkedList<Vertex>> blocks=new LinkedList<LinkedList<Vertex>>(), components=new LinkedList<LinkedList<Vertex>>();//first component is for singletons
  int[] tails=new int[3];//0->tailsTouchGiantBlock, 1->tailsTouchMinorBlocks, 2->tailsTouchBothBlocks
  Component(Color primary, Color relay) {
    degreeList=new Vertex[8];
    initialize(primary, relay);
  }
  Component(Color primary, Color relay, int maxDegree) {
    degreeList=new Vertex[maxDegree+1];
    initialize(primary, relay);
  }
  void initialize(Color primary, Color relay) {
    components.addLast(new LinkedList<Vertex>());
    for (int i=0; i<degreeList.length; i++)
      degreeList[i]=new Vertex(i);
    setPartites(primary, relay);
  }
  void reset(Color primary, Color relay) {
    order=0;
    stack.clear();
    blocks.clear();
    for (Vertex list : degreeList)
      list.clean();
    while (components.size()>1)
      components.removeLast();
    components.getFirst().clear();
    setPartites(primary, relay);
  }
  void restart() {
    for (Vertex list : degreeList)
      list.clean();
    generateDegreeList();
  }
  boolean deleting() {
    if (degreeList[1].value==0) {
      if (order==0) {
        for (int i=2; i<degreeList.length; i++)
          for (Vertex node=degreeList[i].next; node!=null; node=node.next)
            node.setEdgeIndicator();
        int index=2;
        while (degreeList[index].value==0&&index<degreeList.length)
          index++;
        if (index<degreeList.length) {
          depthFirstSearch(degreeList[index].next, null);
          for (LinkedList<Vertex> block : blocks)
            if (giant[0].size()<block.size())
              giant[0]=block;
          for (ListIterator<LinkedList<Vertex>> j=blocks.listIterator(blocks.size()-1); j.hasPrevious(); )
            j.previous().getLast().order=-1;//separating vertex in minor blocks indicator
          for (Vertex node : giant[0])
            node.order=node.order==-1?-3:-4;//-3: separating vertex in giant block indicator, -4: giant block indicator
        }
      }
      return false;
    } else {
      Vertex nodeA=degreeList[1].pop();
      nodeA.order=-2;//tail indicator
      degreeList[0].push(nodeA);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order!=-2) {
          nodeB.solo(degreeList[nodeB.lowpoint]);
          nodeB.lowpoint--;
          degreeList[nodeB.lowpoint].push(nodeB);
          if (nodeB.lowpoint==0)
            nodeB.order=-2;
          break;
        }
      return true;
    }
  }
  void setPartites(Color primary, Color relay) {
    giant[0]=giant[1]=gui.mainColor.vertices;
    this.primary=primary;
    this.relay=relay;
    initialMarks(primary);
    initialMarks(relay);
    for (Vertex nodeA : relay.vertices) {
      for (Vertex nodeB : nodeA.colorNeighbors.get(primary.index)) {
        nodeA.links.addLast(nodeB);
        nodeB.links.addLast(nodeA);
      }
      if (nodeA.links.isEmpty())
        components.getFirst().addLast(nodeA);
    }
    for (Vertex nodeA : primary.vertices)
      if (nodeA.links.isEmpty())
        components.getFirst().addLast(nodeA);
      else if (nodeA.order==1) {
        components.addLast(new LinkedList<Vertex>());
        depthFirstSearch(nodeA);
      }
    for (ListIterator<LinkedList<Vertex>> i=components.listIterator(1); i.hasNext(); ) {
      LinkedList<Vertex> component=i.next();
      if (giant[1].size()<component.size())
        giant[1]=component;
    }
    generateDegreeList();
  }
  void generateDegreeList() {
    for (Vertex node : giant[1]) {
      node.mark=0;
      node.lowpoint=node.links.size();
      degreeList[node.lowpoint].push(node);
    }
  }
  void initialMarks(Color colour) {
    for (Vertex node : colour.vertices) {
      node.order=1;//singleton indicator
      if (node.links==null)
        node.links=new LinkedList<Vertex>();
      else
        node.links.clear();
    }
  }
  boolean goOn() {
    return degreeList[1].value>0;
  }
  void clearTailCounts() {
    tails[0]=tails[1]=tails[2]=0;
  }
  void countTails() {
    if (degreeList[1].value>0) {
      for (Vertex node=degreeList[0].next; node!=null; node=node.next)
        node.mark=0;
      for (Vertex node=degreeList[0].next; node!=null; node=node.next)
        if (node.mark==0)
          tailTraverse(node);
    }
  }
  void tailTraverse(Vertex nodeA) {//determine # of tail components
    switch(nodeA.order) {
    case -1://touch separating vertices in minor blocks
      tails[1]++;
      break;
    case -2://tail
      nodeA.mark=1;
      for (Vertex nodeB : nodeA.links)
        if (nodeB.mark==0)
          tailTraverse(nodeB);
      break;
    case -3://touch separating vertices in the giant block (it touches both blocks)
      tails[2]++;
      break;
    case -4://touch the giant block
      tails[0]++;
      break;
    default://touch minor blocks
      tails[1]++;
    }
  }
  int tailsToGiant() {
    return tails[0]+tails[2];
  }
  int tailsToMinors() {
    return tails[1]+tails[2];
  }
  int tailsToTwoCore() {
    return tails[0]+tails[1]+tails[2];
  }
  void depthFirstSearch(Vertex nodeA) {
    nodeA.order=0;//minor component indicator
    components.getLast().addLast(nodeA);
    for (Vertex nodeB : nodeA.links)
      if (nodeB.order==1)
        depthFirstSearch(nodeB);
  }
  void depthFirstSearch(Vertex nodeA, Vertex precessor) {
    if (nodeA.order==0) {
      nodeA.order=nodeA.lowpoint=++order;
      stack.push(nodeA);
      while (nodeA.edgeIndicator.hasNext()) {
        Vertex nodeB=nodeA.edgeIndicator.next();
        if (nodeB!=precessor&&nodeB.order!=-2)
          depthFirstSearch(nodeB, nodeA);
      }
      if (precessor!=null)
        if (precessor.order==1)
          seperate(nodeA, precessor); 
        else if (nodeA.lowpoint<precessor.order)
          precessor.lowpoint=min(precessor.lowpoint, nodeA.lowpoint);
        else
          seperate(nodeA, precessor);
    } else
      precessor.lowpoint=min(precessor.lowpoint, nodeA.order);
  }
  void seperate(Vertex node, Vertex precessor) {
    blocks.addLast(new LinkedList<Vertex>());
    Vertex s=stack.pop();
    while (s!=node) {
      blocks.getLast().addLast(s);
      s=stack.pop();
    }
    blocks.getLast().addLast(s);
    blocks.getLast().addLast(precessor);
  }
}
