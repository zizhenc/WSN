class Exhaustive extends Method {
  boolean connecting() {
    graph.vertex[index].mark=0;
    if (index==graph.vertex.length-1)
      return false;
    for (int j=index+1; j<graph.vertex.length; j++)
      if (graph.vertex[index].distance(graph.vertex[j])<graph.r) {
        graph.vertex[index].neighbors.addLast(graph.vertex[j]);
        graph.vertex[j].neighbors.addLast(graph.vertex[index]);
        graph._E++;
        graph.vertex[j].mark=0;
      }
    index++;
    return true;
  }
  void reset() {
    index=0;
  }
}
