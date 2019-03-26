class ColorSizePlot extends Plots implements Screen {
  Checker _SLColors=new Checker("Smallest-last color sets"), primarySets=new Checker("Primary sets"), relayCandidates=new Checker("Relay candidates"), relaySets=new Checker("Relay sets");
  ExTable[] table={new ExTable(1, "Part", "Covered graph"), new ExTable(3, "Part", "Covered graph"), new ExTable(4, "Part", "Covered graph")};
  ColorSizePlot() {
    chart=new Plot("Color", "Vertex", gui.partColor, "Smallest-last-colored sets", "Selected sets", "Relay candidates", "Relay-colored sets");
    chart.setPlot(0, true);
    parts.addLast(_SLColors);
    table[0].setString(0, 0, "SL-colored");
    table[1].setString(0, 0, "SL-colored");
    table[1].setString(1, 0, "Selected");
    table[1].setString(2, 0, "Candidates");
    table[2].setString(0, 0, "SL-colored");
    table[2].setString(1, 0, "Selected");
    table[2].setString(2, 0, "Candidates");
    table[2].setString(3, 0, "RL-colored");
  }
  void moreSettings() {
    chart.setX(0, graph._SLColors.size()-1);
    chart.setPoints(0);
    int maxSize=0;
    for (int i=0; i<graph._SLColors.size(); i++) {
      int size=graph._SLColors.get(i).vertices.size();
      if (maxSize<size)
        maxSize=size;
      chart.points[0].set(i, size+0f);
    }
    chart.setY(0, maxSize);
    if (navigation.end==4) {
      primarySets.value=relayCandidates.value=relaySets.value=false;
      for (int i=1; i<4; i++)
        chart.setPlot(i, false);
      if (parts.getLast()==relayCandidates) {
        parts.removeLast();
        parts.removeLast();
      } else if (parts.getLast()==relaySets) {
        for (int i=0; i<3; i++)
          parts.removeLast();
      }
    } else {
      chart.setPoints(1, 0, graph._PYColors.size()-1);
      chart.setPoints(2, graph._PYColors.size(), graph._SLColors.size()-1);
      for (int i=0; i<graph._PYColors.size(); i++) 
        chart.points[1].set(i, graph._PYColors.get(i).vertices.size()+0f);
      for (int i=graph._PYColors.size(); i<graph._SLColors.size(); i++) 
        chart.points[2].set(i-graph._PYColors.size(), graph._SLColors.get(i).vertices.size()+0f);
      if (navigation.end==5) {  
        relaySets.value=false;
        chart.setPlot(3, false);
        if (parts.getLast()==_SLColors) {
          primarySets.value=relayCandidates.value=true;
          chart.setPlot(1, true);
          chart.setPlot(2, true);
          parts.addLast(primarySets);
          parts.addLast(relayCandidates);
        } else if (parts.getLast()==relaySets)
          parts.removeLast();
      } else {
        chart.setPoints(3, 0, graph._RLColors.size()-1);
        for (int i=0; i<graph._RLColors.size(); i++) 
          chart.points[3].set(graph._RLColors.get(i).index-graph._SLColors.size(), graph._RLColors.get(i).vertices.size()+0f);
        if (parts.getLast()==_SLColors) {
          parts.addLast(primarySets);
          parts.addLast(relayCandidates);
          parts.addLast(relaySets);
          primarySets.value=relaySets.value=true;
          chart.setPlot(1, true);
          chart.setPlot(3, true);
        } else if (parts.getLast()==relayCandidates) {
          parts.addLast(relaySets);
          relaySets.value=true;
          chart.setPlot(3, true);
        }
      }
    }
  }
  void show() {
    if (_SLColors.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(0);
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(0);
    }
    if (primarySets.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(1);
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(1);
    }
    if (relayCandidates.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(2, graph._PYColors.size());
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(2, graph._PYColors.size());
    }
    if (relaySets.value) {
      strokeWeight(edgeWeight.value);
      chart.drawPlot[1].display(3, graph._PYColors.size());
      strokeWeight(nodeWeight.value);
      chart.drawPlot[0].display(3, graph._PYColors.size());
      chart.showScaleX(chart.getX(graph._PYColors.size()), chart.yStart-gui.thisFont.stepY(2), graph._SLColors.size(), graph._SLColors.size()+graph._RLColors.size()-1);
      chart.arrow(chart.getX(graph._PYColors.size()), chart.yStart-gui.thisFont.stepY(2), chart.getX(graph._PYColors.size())-1, chart.yStart-gui.thisFont.stepY(2));
      chart.arrow(chart.getX(graph._PYColors.size()+graph._RLColors.size())-1, chart.yStart-gui.thisFont.stepY(2), chart.getX(graph._PYColors.size()+graph._RLColors.size()), chart.yStart-gui.thisFont.stepY(2));
    }
    if (showMeasurement.value) {
      chart.showMeasurements();
      if (chart.active()) {
        int amount=0, index=round(chart.getX());
        switch(navigation.end) {
        case 4:
          for (int i=0; i<=index; i++)
            amount+=chart.points[0].get(i);
          table[0].setString(0, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
          showTable(table[0]);
          break;
        case 5:
          if (index<graph._PYColors.size()) {
            for (int i=0; i<=index; i++)
              amount+=chart.points[1].get(i);
            table[1].setString(0, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[1].setString(1, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[1].setString(2, 1, String.format("%.2f%%", 0f));
          } else {
            table[1].setString(1, 1, String.format("%.2f%%", graph.primaries*100.0/graph.vertex.length));
            for (int i=0; i<=index-graph._PYColors.size(); i++)
              amount+=chart.points[2].get(i);
            table[1].setString(2, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[1].setString(0, 1, String.format("%.2f%%", (graph.primaries+amount)*100.0/graph.vertex.length));
          }
          showTable(table[1]);
          break;
        default:
          if (index<graph._PYColors.size()) {
            for (int i=0; i<=index; i++)
              amount+=chart.points[1].get(i);
            table[2].setString(0, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[2].setString(1, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[2].setString(2, 1, String.format("%.2f%%", 0f));
            table[2].setString(3, 1, String.format("%.2f%%", 0f));
          } else {
            table[2].setString(1, 1, String.format("%.2f%%", graph.primaries*100.0/graph.vertex.length));
            for (int i=0; i<=index-graph._PYColors.size(); i++)
              amount+=chart.points[2].get(i);
            table[2].setString(2, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
            table[2].setString(0, 1, String.format("%.2f%%", (graph.primaries+amount)*100.0/graph.vertex.length));
            amount=0;
            for (int i=0; i<=index-graph._PYColors.size()&&i<graph._RLColors.size(); i++)
              amount+=chart.points[3].get(i);
            table[2].setString(3, 1, String.format("%.2f%%", amount*100.0/graph.vertex.length));
          }
          showTable(table[2]);
        }
      }
      if (!_SLColors.value&&primarySets.value&&relayCandidates.value)
        chart.dottedLine(chart.getX(graph._PYColors.size()-1), chart.getY(chart.points[0].get(graph._PYColors.size()-1)), chart.getX(graph._PYColors.size()), chart.getY(chart.points[0].get(graph._PYColors.size())));
      if (primarySets.value&&relaySets.value)
        chart.dottedLine(chart.getX(graph._PYColors.size()-1), chart.getY(chart.points[0].get(graph._PYColors.size()-1)), chart.getX(graph._PYColors.size()), chart.getY(chart.points[3].get(0)));
    }
  }
  void showTable(ExTable table) {
    table.display(mouseX<chart.x+chart.chartWidth/2?mouseX+textWidth(" ("):mouseX-table.tableWidth()-textWidth(" ("), mouseY<chart.y+chart.chartHeight/2?mouseY+gui.thisFont.stepY()+gui.thisFont.gap(2):mouseY-table.tableHeight()-gui.thisFont.stepY()-gui.thisFont.gap(2));
  }
}
