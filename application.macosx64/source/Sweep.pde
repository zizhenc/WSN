class Sweep extends Method {
  int i;
  SweepComparator comparator=new SweepComparator();
  boolean connecting() {
    graph.vertex[i].lowpoint=0;
    if (i==graph.vertex.length-1)
      return false;
    for (int j=i+1; j<graph.vertex.length&&comparator.difference(graph.vertex[j], graph.vertex[i])<graph.r; j++)
      if (graph.vertex[i].distance(graph.vertex[j])<graph.r) {
        graph.vertex[i].neighbors.addLast(graph.vertex[j]);
        graph.vertex[j].neighbors.addLast(graph.vertex[i]);
        graph._E++;
        graph.vertex[j].lowpoint=0;
      }
    i++;
    return true;
  }
  void reset() {
    i=0;
    comparator.setCoordinateIndex(index);
    Arrays.sort(graph.vertex, comparator);
    for (int i=0; i<graph.vertex.length; i++)
      graph.vertex[i].value=i;
  }
}
