class CartesianCell extends CellSystem {
  int xN=graph.r==0?0:(int)Math.floor(graph.topology.xRange/graph.r)+1, yN=graph.r==0?0:(int)Math.floor(graph.topology.yRange/graph.r)+1, zN=graph.r==0?0:(int)Math.floor(graph.topology.zRange/graph.r)+1, x, y, z;
  LinkedList<Vertex>[][][] cell;
  ListIterator<Vertex> i;
  CartesianCell() {
    cell=new LinkedList[xN][yN][zN];
    for (int a=0; a<xN; a++)
      for (int b=0; b<yN; b++)
        for (int c=0; c<zN; c++)
          cell[a][b][c]=new LinkedList<Vertex>(); 
    if (graph.r==0)
      for (Vertex node : graph.vertex)
        cell[0][0][0].addLast(node);
    else
      for (Vertex node : graph.vertex)
        cell[(int)Math.floor((node.x+graph.topology.xRange/2)/graph.r)][(int)Math.floor((node.y+graph.topology.yRange/2)/graph.r)][(int)Math.floor((node.z+graph.topology.zRange/2)/graph.r)].addLast(node);
  }
  void initialize() {
    x=y=z=0;
    i=cell[x][y][z].listIterator();
  }
  boolean connecting() {
    if (count==graph.vertex.length)
      return false;
    if (i.hasNext()) {
      count++;
      Vertex nodeA=i.next();
      nodeA.lowpoint=0;
      for (ListIterator<Vertex> j=cell[x][y][z].listIterator(i.nextIndex()); j.hasNext(); )
        link(nodeA, j.next());
      if (x+1!=xN) {
        if (y-1!=-1)
          for (Vertex nodeB : cell[x+1][y-1][z])
            link(nodeA, nodeB);
        for (Vertex nodeB : cell[x+1][y][z])
          link(nodeA, nodeB);
        if (y+1!=yN)
          for (Vertex nodeB : cell[x+1][y+1][z])
            link(nodeA, nodeB);
      }
      if (y+1!=yN)
        for (Vertex nodeB : cell[x][y+1][z])
          link(nodeA, nodeB);
      if (z+1!=zN) {
        if (x-1!=-1) {
          if (y-1!=-1)
            for (Vertex nodeB : cell[x-1][y-1][z+1])
              link(nodeA, nodeB);
          for (Vertex nodeB : cell[x-1][y][z+1])
            link(nodeA, nodeB);
          if (y+1!=yN)
            for (Vertex nodeB : cell[x-1][y+1][z+1])
              link(nodeA, nodeB);
        }
        if (y-1!=-1)
          for (Vertex nodeB : cell[x][y-1][z+1])
            link(nodeA, nodeB);
        for (Vertex nodeB : cell[x][y][z+1])
          link(nodeA, nodeB);
        if (y+1!=yN)
          for (Vertex nodeB : cell[x][y+1][z+1])
            link(nodeA, nodeB);
        if (x+1!=xN) {
          if (y-1!=-1)
            for (Vertex nodeB : cell[x+1][y-1][z+1])
              link(nodeA, nodeB);
          for (Vertex nodeB : cell[x+1][y][z+1])
            link(nodeA, nodeB);
          if (y+1!=yN)
            for (Vertex nodeB : cell[x+1][y+1][z+1])
              link(nodeA, nodeB);
        }
      }
    } else {
      y++;
      if (y==yN) {
        y=0;
        x++;
        if (x==xN) {
          x=0;
          z++;
        }
      }
      i=cell[x][y][z].listIterator();
    }
    return true;
  }
}
