class DegreeDistribution extends Charts implements Screen {
  Switcher showBar=new Switcher("Bar", "Bar");
  Checker degreeHistogram=new Checker("Degree histogram"), inDegreeHistogram=new Checker("Indegree histogram"), outDegreeHistogram=new Checker("Outdegree histogram");
  DegreeDistribution() {
    switches.addLast(showBar);
    parts.addLast(inDegreeHistogram);
    parts.addLast(degreeHistogram);
    parts.addLast(outDegreeHistogram);
    chart=new BarChart("Degree", "Node", gui.partColor, "Indegree", "Degree", "Outdegree");
  }
  void setting() {
    chart.setX(0, graph.maxDegree);
    chart.setPoints();
    for (int i=0; i<chart.points[0].size(); i++)
      chart.points[0].set(i, 0f);
    for (int i=0; i<chart.points[2].size(); i++)
      chart.points[2].set(i, 0f);
    for (Vertex node : graph.vertex) {
      chart.points[0].set(node.degree, chart.points[0].get(node.degree)+1);
      chart.points[2].set(node.neighbors.size()-node.degree, chart.points[2].get(node.neighbors.size()-node.degree)+1);
    }
    float maxSize=0;
    for (int i=0; i<=graph.maxDegree; i++) {
      chart.points[1].set(i, graph.degreeDistribution[i]+0f);
      float value=max(chart.points[0].get(i), chart.points[1].get(i), chart.points[2].get(i));
      if (maxSize<value)
        maxSize=value;
    }
    chart.setY(0, round(maxSize));
    interval.setPreference(0.01, 0.1, 0.001);
    chart.setInterval(interval.value);
    edgeWeight.setPreference(7, 0, 10, 1);
  }
  void show() {
    if (showBar.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[0].display();
    }
  }
  void moreKeyReleases() {
    if (Character.toLowerCase(key)=='b')
      showBar.commit();
  }
}
