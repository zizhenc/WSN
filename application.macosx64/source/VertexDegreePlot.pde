class VertexDegreePlot extends Plots implements Screen {
  Checker originalDegree=new Checker("Original degree"), averageDegree=new Checker("Average degree when deleted"), averageOriginalDegree=new Checker("Average original degree"), degreeDeleted=new Checker("Degree when deleted");
  VertexDegreePlot() {
    parts.addLast(originalDegree);
    parts.addLast(averageOriginalDegree);
    parts.addLast(averageDegree);
    parts.addLast(degreeDeleted);
    chart=new Plot("Vertex", "Degree", gui.partColor, "Original degree", "Average degree when deleted", "Average original degree", "Degree when deleted");
  }
  void moreSettings() {
    chart.setX(0, graph.vertex.length-1);
    chart.setY(0, graph.maxDegree);
    chart.setPoints();
    for (int i=0; i!=graph.vertex.length; i++) {
      chart.points[0].set(i, graph.vertex[i].neighbors.size()+0f);
      chart.points[1].set(i, graph.vertex[i].avgOrgDegree);
      chart.points[2].set(i, graph.vertex[i].avgDegree);
      chart.points[3].set(i, graph.vertex[i].degree+0f);
    }
  }
  void show() {
    if (showEdge.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display();
    }
    if (showNode.value) {
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display();
    }
  }
  void moreMouseReleases() {
    for (ListIterator<Checker> i=parts.listIterator(); i.hasNext(); ) {
      Checker checker=i.next();
      if (checker.active())
        chart.setPlot(i.previousIndex(), checker.value);
    }
  }
}
