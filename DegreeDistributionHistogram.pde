class DegreeDistribution extends Charts implements Screen {
  int maxSize;
  Checker degreeHistogram=new Checker("Degree histogram"), inDegreeHistogram=new Checker("Indegree histogram"), outDegreeHistogram=new Checker("Outdegree histogram");
  DegreeDistribution() {
    parts.addLast(inDegreeHistogram);
    parts.addLast(degreeHistogram);
    parts.addLast(outDegreeHistogram);
    chart=new BarChart("Degree", "Vertex", new String[]{"Indegree", "Degree", "Outdegree"});
  }
  void setting() {
    initialize();
    chart.setX(0, graph.maxDegree);
    if (maxSize<0) {
      for (ArrayList<Float> point : chart.points)
        for (int i=0; i<=graph.maxDegree; i++)
          point.set(i, 0f);
    }
    maxSize=0;
    for (Vertex node : graph.vertex) {
      chart.points[0].set(node.degree, chart.points[0].get(node.degree)+1);
      chart.points[2].set(node.neighbors.size()-node.degree, chart.points[2].get(node.neighbors.size()-node.degree)+1);
    }
    for (int i=0; i<=graph.maxDegree; i++) {
      if (maxSize<graph.degreeDistribution[i])
        maxSize=graph.degreeDistribution[i];
      chart.points[1].set(i, graph.degreeDistribution[i]+0f);
    }
    chart.setY(0, maxSize);
  }
}
