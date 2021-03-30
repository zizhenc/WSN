class SweepComparator implements Comparator<Vertex> {
  int index;//coordinate index
  double difference(Vertex nodeA, Vertex nodeB) {
    switch(index) {
    case 0:
      return nodeA.x-nodeB.x;
    case 1:
      return nodeA.z-nodeB.z;
    case 2:
      return nodeA.rho-nodeB.rho;
    default:
      return 0;
    }
  }
  int compare(Vertex nodeA, Vertex nodeB) {
    double result=difference(nodeA, nodeB);
    if (result>0)
      return 1;
    else if (result==0)
      return 0;
    else
      return -1;
  }
  void setCoordinateIndex(int index) {
    this.index=index;
  }
}
