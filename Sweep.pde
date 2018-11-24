class Sweep extends Method {
  int i;
  Vertex[] reference=graph.vertex.clone();
  int partition(Vertex[] vertex, int i, int j) {
    Vertex pivot=vertex[i];
    while (i<j) {
      while (i<j&&difference(vertex[j], pivot)>=0)
        j--;
      if (i<j)
        vertex[i++]=vertex[j];
      while (i<j&&difference(vertex[i], pivot)<=0)
        i++;
      if (i<j)
        vertex[j--]=vertex[i];
    }
    vertex[i]=pivot;
    return i;
  }
  double difference(Vertex nodeA, Vertex nodeB) {
    switch(index) {
    case 0:
      return nodeA.x-nodeB.x;
    case 1:
      return nodeA.pho-nodeB.pho;
    case 2:
      return nodeA.rho-nodeB.rho;
    default:
      return 0;
    }
  }
  boolean connecting() {
    reference[i].mark=0;
    if (i==reference.length-1)
      return false;
    for (int j=i+1; j<reference.length&&difference(reference[j], reference[i])<graph.r; j++)
      if (reference[i].distance(reference[j])<graph.r) {
        reference[i].neighbors.addLast(reference[j]);
        reference[j].neighbors.addLast(reference[i]);
        graph._E++;
        reference[j].mark=0;
      }
    i++;
    return true;
  }
  void quickSort(Vertex[] vertex, int low, int high) {
    int pivotpos;
    if (low<high) {
      pivotpos=partition(vertex, low, high);
      quickSort(vertex, low, pivotpos-1);
      quickSort(vertex, pivotpos+1, high);
    }
  }
  void setCoordinate(int index) {
    this.index=index;
    reset();
  }
  void reset() {
    i=0;
    quickSort(reference, 0, reference.length-1);
  }
}
