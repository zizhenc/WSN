abstract class CircularCell extends CellSystem {
  ArrayList<LinkedList<Vertex>>[][] ring;
  int mod(int value, int size) {
    if (value<0) {
      int x=value%size; 
      if (x==0)
        return x; 
      else
        return size+x;
    } else
      return value%size;
  }
  void checkNeighbors(Vertex nodeA, int z, int pho, int index, int number) {
    int k=-(number-1)/2;
    for (int j=mod(index+k, ring[z][pho].size()); k<=number/2&&j<ring[z][pho].size(); k++, j++)
      for (Vertex nodeB : ring[z][pho].get(j))
        link(nodeA, nodeB);
    for (int j=0; k<=number/2; k++, j++)
      for (Vertex nodeB : ring[z][pho].get(j))
        link(nodeA, nodeB);
  }
}
