public class IO {
  ArrayList<Graph> results=new ArrayList<Graph>();
  LinkedList<String> resultLabels=new LinkedList<String>();
  StringBuffer path=new StringBuffer("Results");
  boolean mode, load;
  String[] info;
  String nodes, file;
  int[] size=new int[8];//0->bipartite, 1->giant component, 2->two-core, 3->giant block, 4->surplus I, 5->surplus II, 6->surplus III, 7->surplus IV
  Action loadAction=new Action() {
    void go() {
      switch(box.option) {
      case 0:
        if (navigation.page==0)
          screen[0].setting();
        else
          navigation.go(103);
        break;
      case 1:
        if (navigation.page==19)
          screen[19].setting();
        navigation.go(102);
        break;
      case 2:
        if (navigation.page==20)
          screen[20].setting();
        navigation.go(101);
      }
    }
  }
  , recordAction=new Action() {
    void go() {
      if (box.option==0) {
        graph=results.get(box.entry.value);
        if (navigation.page>11&&navigation.page<19&&navigation.page!=15)
          screen[navigation.page].setting();
      }
    }
  };
  void record() {
    results.add(graph);
    resultLabels.addLast("Graph #"+graph.index+": "+graph.topology);
  }
  void selectGraph() {
    if (results.isEmpty())
      error.logOut("Graph selection error - No graph computed");
    else
      box.pop(resultLabels, "Records", recordAction, "Confirm", "Cancel");
  }
  void saveAs(String name) {
    if (name.equals("graph"))
      gui.thread=3;
    else if (name.equals("graph summary"))
      gui.thread=4;
    if (mode)
      selectOutput("Save "+name+" to:", "graphFile", new File(path.toString()), this);
    else {
      file=path+System.getProperty("file.separator")+name+" ("+month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second()+").wsn";
      thread("daemon");
    }
  }
  void graphFile(File selection) {
    if (selection!=null) {
      file=selection.getAbsolutePath();
      thread("daemon");
    }
  }
  void graphInfo() {
    String text=graph.topology+": G("+graph.vertex.length+", "+graph.r+")"+System.getProperty("line.separator");
    for (Vertex node : graph.vertex)
      text+="("+node.value+", "+node.x+", "+node.y+", "+node.z+") ";
    output(text);
    box.pop("Graph saved!", "Information", "Great!");
  }
  void graphSummary() {
    graph.calculateBackbones();
    String separator=System.getProperty("line.separator");
    String text="Topology,"+graph.topology+separator;
    text+="N,"+graph.vertex.length+separator;
    text+="r,"+graph.r+separator;
    text+="Edge,"+graph._E+separator;
    text+="Average degree,"+graph._E*2.0/graph.vertex.length+separator;
    text+="Maximum degree,"+graph.maxDegree+separator;
    text+="Minimum degree,"+graph.minDegree+separator;
    text+="Maximum minimum-degree,"+graph.maxMinDegree+separator;
    text+="Termial clique size,"+graph.clique.size()+separator;
    text+="Colors,"+graph._SLColors.size()+separator;
    text+="Primary colors,"+graph._PYColors.size()+separator;
    text+="Relay colors,"+graph._RLColors.size()+separator;
    text+=String.format("Partition percentile,%.2f%%", graph.primaries*100.0/graph.vertex.length)+separator;
    int surplus=graph.surplus();
    text+=String.format("Surplus,%d(%.2f%%)", surplus, surplus*100.0/graph.vertex.length);
    output(text);
    box.pop("Graph summary saved.", "Information", "Well done!");
  }
  void output(String text) {
    PrintWriter out=createWriter(file);
    out.println(text);
    out.close();
  }
  void loadGraph(File selection) {
    if (selection!=null) {
      BufferedReader reader = createReader(selection.getAbsolutePath());
      try {
        info=splitTokens( reader.readLine(), "G(,)");
        nodes=reader.readLine();
        reader.close();
      } 
      catch (IOException e) {
        error.logOut("File read error - "+e.getMessage());
      }
      load=true;
      box.pop("Load success! New graph, computation or demonstraction?", "Option", loadAction, "Graph", "Comp", "Demo");
    }
  }
  void loadVertices() {
    String[] coordinate=splitTokens(nodes, "(,) ");
    try {
      for (int i=0; i<graph.vertex.length; i++) {
        int value=int(coordinate[i*4]);
        double x=Double.parseDouble(coordinate[i*4+1]), y=Double.parseDouble(coordinate[i*4+2]), z=Double.parseDouble(coordinate[i*4+3]);
        graph.vertex[value]=new Vertex(value, x, y, z, graph.topology.connectivity());
      }
    }
    catch(NumberFormatException e) {
      error.logOut("Load graph error - "+e.getMessage());
      load=false;
    }
    load=false;
  }
}
