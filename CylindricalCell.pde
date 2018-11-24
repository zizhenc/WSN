class CylindricalCell extends CircularCell {
  int phoN=graph.r==0?0:(int)Math.floor(graph.topology.range/(2*graph.r))+1, zN=graph.r==0?0:(int)Math.floor(graph.topology.zRange/graph.r)+1, z, pho, phi;
  ListIterator<Vertex> i;
  CylindricalCell() {
    ring=new ArrayList[zN][phoN];
    for (int a=0; a!=zN; a++) {
      int size=6;
      ring[a][0]=new ArrayList<LinkedList<Vertex>>();
      for (int b=0; b!=size; b++)
        ring[a][0].add(new LinkedList<Vertex>());
      for (int b=1; b!=phoN; b++) {
        ring[a][b]=new ArrayList<LinkedList<Vertex>>();
        if (Math.sin(Math.PI/size)*b>1)
          size*=2;
        for (int c=0; c!=size; c++)
          ring[a][b].add(new LinkedList<Vertex>());
      }
    }
    if (graph.r==0)
      for (Vertex node : graph.vertex)
        ring[0][0].get((int)Math.floor(node.phi*3/Math.PI)).addLast(node);
    else
      for (Vertex node : graph.vertex) {
        z=(int)Math.floor((node.z+graph.topology.zRange/2)/graph.r);
        pho=(int)Math.floor(node.pho/graph.r);
        ring[z][pho].get((int)Math.floor(node.phi*ring[z][pho].size()/(2*Math.PI))).addLast(node);
      }
  }
  void initialize() {
    z=pho=phi=0;
    i=ring[0][0].get(0).listIterator();
  }
  boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    if (i.hasNext()) {
      count++;
      Vertex nodeA=i.next();
      nodeA.mark=0;
      for (ListIterator<Vertex> j=ring[z][pho].get(phi).listIterator(i.nextIndex()); j.hasNext(); )
        link(nodeA, j.next());
      if (pho==0) {
        for (int j=phi+1; j<ring[z][0].size(); j++)
          for (Vertex nodeB : ring[z][0].get(j))
            link(nodeA, nodeB);
        if (phoN>1)
          checkNeighbors(nodeA, z, 1, phi, 5);
        if (z+1!=zN) {
          for (LinkedList<Vertex> list : ring[z+1][0])
            for (Vertex nodeB : list)
              link(nodeA, nodeB);
          if (phoN>1)
            checkNeighbors(nodeA, z+1, 1, phi, 5);
        }
      } else if (pho==1) {
        for (Vertex nodeB : ring[z][1].get (mod (phi+1, ring[z][1].size())))
          link(nodeA, nodeB);
        if (phoN>2)
          checkNeighbors(nodeA, z, 2, phi, 3);
        if (z+1!=zN) {
          checkNeighbors(nodeA, z+1, 0, phi, 5);
          checkNeighbors(nodeA, z+1, 1, phi, 3);
          if (phoN>2)
            checkNeighbors(nodeA, z+1, 2, phi, 3);
        }
      } else {
        for (Vertex nodeB : ring[z][pho].get (mod (phi+1, ring[z][pho].size())))
          link(nodeA, nodeB);
        int index, number;
        if (pho+1!=phoN) {
          if (ring[z][pho].size()<ring[z][pho+1].size()) {
            index=phi*2;
            number=4;
          } else {
            index=phi;
            number=3;
          }
          checkNeighbors(nodeA, z, pho+1, index, number);
        }
        if (z+1!=zN) {
          index=ring[z+1][pho-1].size()<ring[z+1][pho].size()?phi/2:phi;
          checkNeighbors(nodeA, z+1, pho-1, index, 3);
          checkNeighbors(nodeA, z+1, pho, phi, 3);
          if (pho+1!=phoN) {
            if (ring[z+1][pho].size()<ring[z+1][pho+1].size()) {
              index=phi*2;
              number=4;
            } else {
              index=phi;
              number=3;
            }
            checkNeighbors(nodeA, z+1, pho+1, index, number);
          }
        }
      }
    } else {
      if (++phi==ring[z][pho].size()) {
        phi=0;
        if (++pho==phoN) {
          pho=0;
          z++;
        }
      }
      i=ring[z][pho].get(phi).listIterator();
    }
    return true;
  }
}
