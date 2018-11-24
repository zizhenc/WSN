abstract class CellSystem {
  int count;
  abstract boolean connecting();
  abstract void initialize();
  void reset() {
    count=0;
    initialize();
  }
  void link(Vertex nodeA, Vertex nodeB) {
    if (nodeA.distance(nodeB)<graph.r) {
      graph._E++;
      nodeB.mark=0;
      nodeA.neighbors.addLast(nodeB);
      nodeB.neighbors.addLast(nodeA);
    }
  }
}
