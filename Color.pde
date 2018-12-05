class Color extends SysColor {
  int index;
  int[] cycles={-1, -1};//cycles are used to count 3,4-cycles, cycles[0] also used to determine cycle counting complete, cycles[1] to determine whether the colour needs initialize
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
    return cycles[1]>-1&&nodeIterator!=null&&nodeIterator.nextIndex()>0;
  }
  void reset() {
    cycles[1]=-1;
  }
  boolean deploying() {
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
    } else if (cycles[0]==-1) {
      cycles[0]=0;
      for (nodeIterator=vertices.listIterator(); nodeIterator.hasNext(); ) {
        Vertex nodeA=nodeIterator.next();
        for (ListIterator<Vertex> i=nodeA.arcs.listIterator(); i.hasNext(); ) {
          Vertex nodeI=i.next();
          if (nodeI.value>nodeA.value)
            for (ListIterator<Vertex> j=nodeA.arcs.listIterator(i.nextIndex()); j.hasNext(); ) {
              Vertex nodeJ=j.next();
              if (nodeJ.value>nodeA.value)
                if (nodeI.arcs.contains(nodeJ))
                  cycles[0]++;
                else {
                  boolean getOut=false;
                  for (Vertex nodeB : nodeI.arcs) {
                    for (Vertex nodeC : nodeJ.arcs)
                      if (nodeB!=nodeA&&nodeB==nodeC&&!nodeA.arcs.contains(nodeC)) {
                        cycles[1]++;
                        getOut=true;
                        break;
                      }
                    if (getOut)
                      break;
                  }
                }
            }
        }
      }
    } else
      return false;
    return true;
  }
  void initialize() {
    if (cycles[1]==-1) {
      cycles[1]=0;
      restart();
    }
  }
  void restart() {
    for (Vertex node : vertices)
      if (node.arcs==null)
        node.arcs=new LinkedList<Vertex>();
      else
        node.arcs.clear();
    nodeIterator=vertices.listIterator();
    distance=maxDistance=0;
    minDistance=Integer.MAX_VALUE;
  }
  void clean() {
    for (Vertex node : vertices)
      node.clearColor(this);
    vertices.clear();
    cycles[0]=cycles[1]=-1;//reset cycles
  }
}
