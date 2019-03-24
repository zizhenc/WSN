public class IO {
  StringBuffer path=new StringBuffer("Results");
  boolean mode, load;
  String[] graphInfo;
  String nodes;
  void saveGraph() {
    if (mode)
      selectOutput("Save graph to:", "graphFile", new File(path.toString()), this);
    else
      recordGraph(path+System.getProperty("file.separator")+"Graph ("+month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second()+").wsn");
  }
  void graphFile(File selection) {
    if (selection!=null)
      recordGraph(selection.getAbsolutePath());
  }
  void recordGraph(String path) {
    String records=graph.topology+": G("+graph.vertex.length+", "+graph.r+")"+System.getProperty("line.separator");
    for (Vertex node : graph.vertex)
      records+="("+node.value+", "+node.x+", "+node.y+", "+node.z+") ";
    PrintWriter out=createWriter(path);
    out.println(records);
    out.close();
    box.pop("Graph saved!", "Information", "Great");
  }
  void loadGraph(File selection) {
    if (selection!=null) {
      BufferedReader reader = createReader(selection.getAbsolutePath());
      try {
        graphInfo=splitTokens( reader.readLine(), "G(,)");
        nodes=reader.readLine();
        reader.close();
      } 
      catch (IOException e) {
        error.logOut("File read error - "+e.getMessage());
      }
      load=true;
      screen[navigation.page].setting();
    }
  }
}
