class SphericalCell extends CircularCell {
  int[] theta=new int[2], phi=new int[2];
  ListIterator<Vertex>[] i=new ListIterator[2];
  int thetaN=(int)Math.floor(Math.PI/(4*Math.asin(graph.r/graph.topology.range)));
  SphericalCell() {
    if (thetaN==0)
      thetaN=1;
    ring=new ArrayList[2][thetaN];
    for (int category=0; category!=2; category++) {
      ring[category][0]=new ArrayList<LinkedList<Vertex>>();
      ring[category][0].add(new LinkedList<Vertex>());
    }
    double alpha=Math.PI/(2*thetaN);
    if (thetaN>1) {
      int size=(int)Math.floor(Math.PI/Math.asin(graph.r/(graph.topology.range*Math.sin(alpha))));
      double beta=2*Math.PI/size;
      for (int a=1; a<thetaN; a++) {
        if (graph.topology.range*Math.sin(a*alpha)*Math.sin(beta/2)>2*graph.r) {
          size*=2;
          beta=2*Math.PI/size;
        }
        for (int category=0; category<2; category++) {
          ring[category][a]=new ArrayList<LinkedList<Vertex>>();
          for (int b=0; b<size; b++)
            ring[category][a].add(new LinkedList<Vertex>());
        }
      }
    }
    for (Vertex node : graph.vertex) {
      int category=node.theta<Math.PI/2?0:1, index=(int)Math.floor((node.theta<Math.PI/2?node.theta:(Math.PI-node.theta))/alpha);
      if (index==thetaN)
        index--;
      ring[category][index].get((int)Math.floor(node.phi*ring[category][index].size()/(2*Math.PI))).addLast(node);
    }
  }
  void initialize() {
    for (int category=0; category<2; category++) {
      theta[category]=phi[category]=0;
      i[category]=ring[category][0].get(0).listIterator();
    }
  }
  boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    for (int category=0; category!=2; category++)
      if (i[category].hasNext())
        checkHemisphere(category, theta[category], phi[category], i[category], ring[category][theta[category]].get(phi[category]));
      else if (theta[category]<thetaN&&++phi[category]<ring[category][theta[category]].size())
        i[category]=ring[category][theta[category]].get(phi[category]).listIterator();
      else if (++theta[category]<thetaN) {
        phi[category]=0;
        i[category]=ring[category][theta[category]].get(0).listIterator();
      }
    return true;
  }
  void checkHemisphere(int category, int theta, int phi, ListIterator<Vertex> i, LinkedList<Vertex> cell) {
    Vertex nodeA=i.next();
    nodeA.lowpoint=0;
    count++;
    for (ListIterator<Vertex> j=cell.listIterator(i.nextIndex()); j.hasNext(); )
      link(nodeA, j.next());
    if (theta>0)
      for (Vertex nodeB : ring[category][theta].get(mod(phi+1, ring[category][theta].size())))
        link(nodeA, nodeB);
    if (theta+1<thetaN) {
      if (theta==0)
        for (LinkedList<Vertex> list : ring[category][1])
          for (Vertex nodeB : list)
            link(nodeA, nodeB);
      else {
        int index, number;
        if (ring[category][theta].size()<ring[category][theta+1].size()) {
          index=phi*2;
          number=4;
        } else {
          index=phi;
          number=3;
        }
        checkNeighbors(nodeA, category, theta+1, index, number);
      }
    } else if (category==0) {
      if (thetaN==1)
        for (Vertex nodeB : ring[1][0].get(0))
          link(nodeA, nodeB);
      else
        checkNeighbors(nodeA, 1, theta, phi, 3);
    }
  }
}
