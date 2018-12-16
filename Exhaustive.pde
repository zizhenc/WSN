class Exhaustive extends Method {
  boolean connecting() {
    graph.vertex[index].lowpoint=0;
    if (index==graph.vertex.length-1)
      return false;
    for (int i=index+1; i<graph.vertex.length; i++)
      if (graph.vertex[index].distance(graph.vertex[i])<graph.r) {
        graph.vertex[index].neighbors.addLast(graph.vertex[i]);
        graph.vertex[i].neighbors.addLast(graph.vertex[index]);
        graph._E++;
        graph.vertex[i].lowpoint=0;
      }
    index++;
    return true;
  }
  void reset() {
    index=0;
  }
}
