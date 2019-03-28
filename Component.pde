class Component {
  int order, archive;//order for block determination (dfs for block selection), archive is for indicating random combination or aimed backbones (if archive==-1 then need reset)
  Color primary, relay;
  Vertex[] degreeList;
  Stack<Vertex> stack=new Stack<Vertex>();
  LinkedList<Vertex>[] giant=new LinkedList[2];//giant[0]->giant block; giant[1]->giant component
  LinkedList<LinkedList<Vertex>> blocks=new LinkedList<LinkedList<Vertex>>(), components=new LinkedList<LinkedList<Vertex>>();//first component is for singletons
  int[] tails=new int[5];//0->tails, 1->tailsTouchGiantBlock, 2->tailsTouchMinorBlocks, 3->tailsTouchBothBlocks, 4->block components
  Component(Color primary, Color relay) {
    degreeList=new Vertex[8];
    initialize(primary, relay);
  }
  Component(Color primary, Color relay, int maxDegree) {
    archive=1;
    degreeList=new Vertex[maxDegree+1];
    initialize(primary, relay);
  }
  void initialize(Color primary, Color relay) {
    components.addLast(new LinkedList<Vertex>());
    for (int i=0; i<degreeList.length; i++)
      degreeList[i]=new Vertex(i);
    setPartites(primary, relay);
  }
  void reset(Color primary, Color relay, int archive) {
    this.archive=archive;
    tails[4]=order=0;
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
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      node.order[archive]=0;
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
        while (index<degreeList.length&&degreeList[index].value==0)
          index++;
        if (index<degreeList.length) {
          depthFirstSearch(degreeList[index].next, null);
          for (LinkedList<Vertex> block : blocks)
            if (giant[0].size()<block.size())
              giant[0]=block;
          for (ListIterator<LinkedList<Vertex>> j=blocks.listIterator(blocks.size()-1); j.hasPrevious(); )
            j.previous().getLast().order[archive]=-1;//separating vertex in minor blocks indicator
          for (Vertex node : giant[0])
            if (node.order[archive]==-1) {
              node.order[archive]=-3;
              tails[4]++;
            } else
              node.order[archive]=-4;//-3: separating vertex in giant block indicator, -4: giant block indicator
        }
        countTails();
      }
      return false;
    } else {
      Vertex nodeA=degreeList[1].pop();
      nodeA.order[archive]=-2;//tail indicator
      degreeList[0].push(nodeA);
      for (Vertex nodeB : nodeA.links)
        if (nodeB.order[archive]!=-2) {
          nodeB.solo(degreeList[nodeB.lowpoint]);
          nodeB.lowpoint--;
          degreeList[nodeB.lowpoint].push(nodeB);
          if (nodeB.lowpoint==0)
            nodeB.order[archive]=-2;
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
      for (Vertex nodeB : nodeA.linksAt(primary)) {
        nodeA.links.addLast(nodeB);
        nodeB.links.addLast(nodeA);
      }
      if (nodeA.links.isEmpty()) {
        nodeA.order[archive]=0;//minor components indicator
        components.getFirst().addLast(nodeA);
      }
    }
    for (Vertex nodeA : primary.vertices)
      if (nodeA.links.isEmpty()) {
        nodeA.order[archive]=0;//minor components indicator
        components.getFirst().addLast(nodeA);
      } else if (nodeA.order[archive]==1) {
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
      node.mark=true;
      node.lowpoint=node.links.size();
      degreeList[node.lowpoint].push(node);
    }
  }
  void initialMarks(Color colour) {
    for (Vertex node : colour.vertices) {
      node.order[archive]=1;//temporary mark for dfs to determine components
      if (node.links==null)
        node.links=new LinkedList<Vertex>();
      else
        node.links.clear();
    }
  }
  void countTails() {
    tails[0]=tails[1]=tails[2]=tails[3]=0;
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      node.mark=true;
    for (Vertex node=degreeList[0].next; node!=null; node=node.next)
      if (node.mark) {
        tails[0]++;
        tailTraverse(node);
      }
  }
  void tailTraverse(Vertex nodeA) {//determine # of tail components
    switch(nodeA.order[archive]) {
    case -2://tail
      nodeA.mark=false;
      for (Vertex nodeB : nodeA.links)
        if (nodeB.mark)
          tailTraverse(nodeB);
      break;
    case -3://touch separating vertices in the giant block (it touches both blocks)
      tails[3]++;
      break;
    case -4://touch the giant block
      tails[1]++;
      break;
    default://touch minor blocks
      tails[2]++;
    }
  }
  int tailsXGiant() {//tails exclude gianttails
    return tails[0]-tails[1]-tails[3];
  }
  int tailsXMinors() {//tails exclude minortails
    return tails[0]-tails[2]-tails[3];
  }
  void depthFirstSearch(Vertex nodeA) {
    nodeA.order[archive]=0;//minor component indicator
    components.getLast().addLast(nodeA);
    for (Vertex nodeB : nodeA.links)
      if (nodeB.order[archive]==1)
        depthFirstSearch(nodeB);
  }
  void depthFirstSearch(Vertex nodeA, Vertex precessor) {
    if (nodeA.order[archive]==0) {
      nodeA.order[archive]=nodeA.lowpoint=++order;
      stack.push(nodeA);
      while (nodeA.edgeIndicator.hasNext()) {
        Vertex nodeB=nodeA.edgeIndicator.next();
        if (nodeB!=precessor&&nodeB.order[archive]!=-2)
          depthFirstSearch(nodeB, nodeA);
      }
      if (precessor!=null)
        if (precessor.order[archive]==1)
          seperate(nodeA, precessor); 
        else if (nodeA.lowpoint<precessor.order[archive])
          precessor.lowpoint=min(precessor.lowpoint, nodeA.lowpoint);
        else
          seperate(nodeA, precessor);
    } else
      precessor.lowpoint=min(precessor.lowpoint, nodeA.order[archive]);
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
