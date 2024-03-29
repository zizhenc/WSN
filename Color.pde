class Color extends SysColor {//Color set has 3 status:0. no change, 1. reset, 2. restart
  int index, domination, deploy;//0: nochange, -1 algorithm stop ready to restart, 1 deploy
  int cycles=-2;//cycles<0 means calculating cycles, cycles==-2 means reset status (recalculating domain)
  double distance, maxDistance, minDistance;
  LinkedList<Vertex> vertices=new LinkedList<Vertex>();
  ListIterator<Vertex> nodeIterator;
  Color(int v, int index) {
    super(v);
    this.index=index;
  }
  Color(int r, int g, int b, int index) {
    super(r, g, b);
    this.index=index;
  }
  boolean deployed() {
    return cycles>-2&&deploy==1&&nodeIterator.nextIndex()>0;
  }
  void deploying() {
    if (deploy==1)
      if (nodeIterator.hasNext()) {
        Vertex nodeA=nodeIterator.next();
        for (ListIterator<Vertex> i=vertices.listIterator(nodeIterator.nextIndex()); i.hasNext(); ) {
          Vertex nodeB=i.next();
          boolean connect=true;
          double squaredDistance=nodeA.squaredDistance(nodeB);
          for (Vertex nodeC : vertices)
            if (nodeC!=nodeA&&nodeC!=nodeB)
              if (nodeA.squaredDistance(nodeC)+nodeB.squaredDistance(nodeC)<=squaredDistance) {
                connect=false;
                break;
              }
          if (connect) {
            double d=Math.sqrt(squaredDistance);
            distance+=d;
            if (d>maxDistance)
              maxDistance=d;
            if (d<minDistance)
              minDistance=d;
            nodeA.arcs.addLast(nodeB);
            nodeB.arcs.addLast(nodeA);
          }
        }
      } else {
        if (cycles==-1) {
          cycles=0;
          while (nodeIterator.hasPrevious()) {
            Vertex nodeA=nodeIterator.previous();
            for (ListIterator<Vertex> i=nodeA.arcs.listIterator(); i.hasNext(); ) {
              Vertex nodeI=i.next();
              if (nodeI.value>nodeA.value)
                for (ListIterator<Vertex> j=nodeA.arcs.listIterator(i.nextIndex()); j.hasNext(); ) {
                  Vertex nodeJ=j.next();
                  if (nodeJ.value>nodeA.value)
                    if (nodeI.arcs.contains(nodeJ))
                      cycles++;
                }
            }
          }
        }
        deploy=0;
      }
  }
  void initialize() {
    deploy=1;
    for (Vertex node : vertices)
      if (node.arcs==null)
        node.arcs=new LinkedList<Vertex>();
      else
        node.arcs.clear();
    distance=maxDistance=0;
    minDistance=Integer.MAX_VALUE;
  }
  void initialize(HashSet<Vertex> domain) {
    if (cycles==-2) {
      cycles=-1;
      nodeIterator=vertices.listIterator();
      domain.clear();
      for (Vertex nodeA : vertices) {
        domain.add(nodeA);
        for (Vertex nodeB : nodeA.neighbors)
          domain.add(nodeB);
      }
      domination=domain.size();
      initialize();
    } else if (deploy==-1)
      restart();
  }
  void restart() {
    initialize();
    while (nodeIterator.hasPrevious())
      nodeIterator.previous();
  }
  void clean() {
    for (Vertex node : vertices)
      node.clearColor(this);
    vertices.clear();
    cycles=-1;
  }
}
