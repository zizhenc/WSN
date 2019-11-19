public class IO {
  String[] header={"Index", "Size", "Edges", "Average degree", "Maximum distance", "Minimum distance", "Average distance", "Faces", "Average face size", "3-cycle faces", "4-cycle faces", "Dominates"}, part={"Bipartite", "Giant component", "Two-core", "Giant block"}, factor={" size", " edge", " average degree", " faces", " average face size", " dominates"};
  ArrayList<Graph> results=new ArrayList<Graph>();
  LinkedList<String> resultLabels=new LinkedList<String>();
  StringBuffer path=new StringBuffer("Results");
  boolean mode, load;
  String[] info;
  String nodes, file;
  Table tableI=new Table(), tableII=new Table();
  int[] vertices=new int[part.length], degrees=new int[part.length], dominants=new int[part.length], coverage=new int[3];
  HashSet<Vertex> domain=new HashSet<Vertex>();
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
  IO() {
    for (String p : part)
      for (String f : factor)
        tableII.addColumn(p+f);
    for (String h : header)
      tableI.addColumn(h);
  }
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
    if (name.equals("Graph"))
      gui.thread=3;
    else if (name.equals("Graph summary"))
      gui.thread=4;
    else if (name.equals("Primary set summary"))
      gui.thread=5;
    else if (name.equals("Relay set summary"))
      gui.thread=6;
    else if (name.equals("Backbone summary"))
      gui.thread=7;
    else
      gui.thread=8;
    file=path+System.getProperty("file.separator")+name+" ("+month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second()+(gui.thread==3?").wsn":").csv");
    if (mode)
      selectOutput("Save "+name+" to:", "graphFile", new File(file), this);
    else
      thread("daemon");
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
    box.pop("Graph saved!", "Information", "Great");
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
    text+=String.format("Surplus I,%d (%.2f%%)", surplus, surplus*100.0/graph.vertex.length)+separator;
    for (Component component : graph.backbone)
      surplus+=component.primary.vertices.size()+component.relay.vertices.size()-component.giant[1].size();
    text+=String.format("Surplus II,%d (%.2f%%)", surplus, surplus*100.0/graph.vertex.length)+separator;
    for (Component component : graph.backbone)
      surplus+=component.degreeList[0].value;
    text+=String.format("Surplus III,%d (%.2f%%)", surplus, surplus*100.0/graph.vertex.length)+separator;
    for (Component component : graph.backbone)
      surplus+=component.primary.vertices.size()+component.relay.vertices.size()-component.giant[0].size();
    text+=String.format("Surplus IV,%d (%.2f%%)", surplus, surplus*100.0/graph.vertex.length);
    output(text);
    box.pop("Graph summary saved!", "Information", "Well done");
  }
  void primarySetSummary() {
    tableI.clearRows();
    if (navigation.end==5)
      for (Color colour : graph._PYColors)
        independentSet(colour);
    else
      for (Color colour : graph._RLColors)
        independentSet(graph._PYColors.get(colour.index-graph._SLColors.size()));
    saveTable(tableI, file);
    box.pop("Primary set summary have been saved!", "Information", "Cool");
  }
  void relaySetSummary() {
    tableI.clearRows();
    for (Color colour : graph._RLColors)
      independentSet(colour);
    saveTable(tableI, file);
    box.pop("Relay set summary have been saved!", "Information", "Cool");
  }
  void backboneSummary() {
    tableII.clearRows();
    graph.calculateBackbones();
    for (Component component : graph.backbone) {
      TableRow row=tableII.addRow();
      domain.clear();
      for (Vertex node : component.giant[0])
        pushDominants(node);
      dominants[3]=domain.size();
      if (dominants[3]==graph.vertex.length)
        dominants[0]=dominants[1]=dominants[2]=dominants[3];
      else {
        for (LinkedList<Vertex> list : component.blocks)
          if (list!=component.giant[0]) {
            for (Vertex node : list)
              if (node.order[1]!=-1&&node.order[1]!=-3)
                pushDominants(node);
            if (domain.size()==graph.vertex.length)
              break;
          }
        if (domain.size()<graph.vertex.length)
          for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
            Vertex node=i.previous().getLast();
            if (node.order[1]==-1)
              pushDominants(node);
          }
        dominants[2]=domain.size();
        if (dominants[2]==graph.vertex.length)
          dominants[0]=dominants[1]=dominants[2];
        else {
          for (Vertex node=component.degreeList[0].next; node!=null; node=node.next)
            pushDominants(node);
          dominants[1]=domain.size();
          if (dominants[1]==graph.vertex.length)
            dominants[0]=dominants[1];
          else {
            for (LinkedList<Vertex> list : component.components)
              if (list!=component.giant[1])
                for (Vertex node : list)
                  pushDominants(node);
            dominants[0]=domain.size();
          }
        }
      }
      vertices[0]=component.primary.vertices.size()+component.relay.vertices.size();
      vertices[1]=component.giant[1].size();
      vertices[2]=vertices[1]-component.degreeList[0].value;
      vertices[3]=component.giant[0].size();
      for (int i=0; i<part.length; i++) {
        row.setInt(i*factor.length, vertices[i]);
        degrees[i]=0;
      }
      for (LinkedList<Vertex> list : component.components) {
        for (Vertex node : list)
          if (list==component.giant[1]) {
            degrees[0]+=node.links.size();
            degrees[1]+=node.links.size();
          } else
            degrees[0]+=node.links.size();
      }
      degrees[2]=degrees[1]-component.degreeList[0].value*2;
      if (component.blocks.size()==1)
        degrees[3]=degrees[2];
      else {
        for (LinkedList<Vertex> list : component.blocks)
          if (component.giant[0]!=list)
            for (Vertex node : list)
              if (node.order[1]!=-1&&node.order[1]!=-3)
                degrees[3]+=node.links.size();
        for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
          Vertex nodeA=i.previous().getLast();
          if (nodeA.order[1]==-1)
            degrees[3]+=nodeA.links.size();
          else
            for (Vertex nodeB : nodeA.links)
              if (nodeB.order[1]>-2)
                degrees[3]++;
        }
        degrees[3]=degrees[2]-degrees[3]+component.tailsXGiant();
      }
      for (int i=0; i<part.length; i++) {
        row.setInt(i*factor.length+1, degrees[i]/2);
        row.setFloat(i*factor.length+2, degrees[i]*1.0/vertices[i]);
        row.setString(i*factor.length+5, String.format("%d (%.2f%%)", dominants[i], dominants[i]*100.0/graph.vertex.length));
      }
      if (graph.topology.value<5) {
        int faces=degrees[0]/2-vertices[0]+component.components.size()-1+component.components.getFirst().size()+graph.topology.characteristic()-1;
        row.setInt("Bipartite faces", faces);
        row.setFloat("Bipartite average face size", degrees[0]*1.0/faces);
        for (int i=1; i<part.length; i++) {
          faces=degrees[i]/2-vertices[i]+graph.topology.characteristic();
          row.setInt(i*factor.length+3, faces);
          row.setFloat(i*factor.length+4, degrees[i]*1.0/faces);
        }
      } else
        for (int i=0; i<part.length; i++) {
          row.setString(i*factor.length+3, "N/A");
          row.setString(i*factor.length+4, "N/A");
        }
    }
    saveTable(tableII, file);
    box.pop("Backbone summary have been saved!", "Information", "Excellent");
  }
  void kCoverage(){
    graph.calculateBackbones();
    StringBuffer text=new StringBuffer("Two-core"+System.getProperty("line.separator")+System.getProperty("line.separator"));
    int[][] primary=new int[12][graph.backbone.length], relay=new int[12][graph.backbone.length], total=new int[12][graph.backbone.length];
    for(int i=0;i<graph.backbone.length;i++){
      Component backbone=graph.getBackbone(i);
      for (Vertex node : graph.vertex)
        node.k[0]=node.k[1]=0;
      for (int j=1; j<backbone.degreeList.length; j++)
        for (Vertex node=backbone.degreeList[j].next; node!=null; node=node.next)
          cover(node,backbone);
      updateCoverage(primary,relay,total,i);
    }
    recordCoverage(text,primary,relay,total);
    calculateCoverage("Giant block", 0, text, primary, relay, total);
    calculateCoverage("Giant component", 1, text, primary, relay, total);
    output(text.toString());
    box.pop("Backbone k-coverages have been saved!", "Information", "Cool");
  }
  void calculateCoverage(String core, int coreIndex, StringBuffer text,int[][] primary, int[][] relay, int[][] total){
    text.append(core+System.getProperty("line.separator")+System.getProperty("line.separator"));
    for(int i=0;i<12;i++)
      for(int j=0;j<graph.backbone.length;j++){
        primary[i][j]=0;
        relay[i][j]=0;
        total[i][j]=0;
      }
    for(int i=0;i<graph.backbone.length;i++){
      Component backbone=graph.getBackbone(i);
      for (Vertex node : graph.vertex)
        node.k[0]=node.k[1]=0;
      for (Vertex node:backbone.giant[coreIndex])
        cover(node,backbone);
      updateCoverage(primary,relay,total,i);
    }
    recordCoverage(text,primary,relay,total);
  }
  void cover(Vertex nodeA, Component backbone){
    nodeA.k[0]=-1;
    for(Vertex nodeB:nodeA.neighbors)
      if(nodeB.k[0]>=0)
        nodeB.k[nodeA.primeColor==backbone.primary?0:1]++;
  }
  void updateCoverage(int[][] primary,int[][] relay, int[][] total, int backbone){
    for(Vertex node:graph.vertex)
      if(node.k[0]>=0){
        primary[11-node.k[0]][backbone]++;
        relay[11-node.k[1]][backbone]++;
        total[11-node.k[0]-node.k[1]][backbone]++;
      }
  }
  void recordCoverage(StringBuffer text, int[][] primary,int[][] relay, int[][] total){
    coverage[0]=coverage[1]=coverage[2]=-1;
    for(int i=0;i<12;i++){
      for(int j=0;j<graph.backbone.length;j++){
        if(coverage[0]<0&&primary[i][j]!=0)
          coverage[0]=i;
        if(coverage[1]<0&&relay[i][j]!=0)
          coverage[1]=i;
        if(coverage[2]<0&&total[i][j]!=0)
          coverage[2]=i;
        if(coverage[0]>=0&&coverage[1]>=0&&coverage[2]>=0)
          break;
      }
      if(coverage[0]>=0&&coverage[1]>=0&&coverage[2]>=0)
        break;
    }
    recordPartCoverage(text,"Primary",0,primary);
    recordPartCoverage(text,"Relay",1,relay);
    recordPartCoverage(text,"Total",2,total);
    text.append(System.getProperty("line.separator"));
  }
  void recordPartCoverage(StringBuffer text, String part, int partIndex, int[][] coverMatrix){
    text.append(part);
    for(int i=0;i<graph.backbone.length;i++)
      text.append(","+(i+1));
    text.append(System.getProperty("line.separator"));
    for(int i=coverage[partIndex];i<12;i++){
      text.append(11-i);
      for(int j=0;j<graph.backbone.length;j++)
        text.append(","+coverMatrix[i][j]);
      text.append(System.getProperty("line.separator"));
    }
    text.append(System.getProperty("line.separator"));
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
  void independentSet(Color colour) {
    TableRow row=tableI.addRow();
    row.setInt("Index", colour.index);
    row.setInt("Size", colour.vertices.size());
    colour.initialize(domain);
    while (colour.deploy==1)
      colour.deploying();
    int degree=0;
    for (Vertex node : colour.vertices)
      degree+=node.arcs.size();
    row.setInt("Edges", degree/2);
    row.setFloat("Average degree", degree*1.0/colour.vertices.size());
    row.setDouble("Maximum distance", colour.maxDistance);
    row.setDouble("Minimum distance", colour.minDistance);
    row.setDouble("Average distance", colour.distance*2/degree);
    row.setString("Dominates", String.format("%d (%.2f%%)", colour.domination, colour.domination*100.0/graph.vertex.length));
    if (graph.topology.value<5) {
      int faces=degree/2-colour.vertices.size()+graph.topology.characteristic();
      row.setInt("Faces", faces);
      row.setFloat("Average face size", degree*1.0/faces);
      row.setString("3-cycle faces", String.format("%d (%.2f%%)", colour.cycles[0], colour.cycles[0]*100.0/faces));
      row.setString("4-cycle faces", String.format("%d (%.2f%%)", colour.cycles[1], colour.cycles[1]*100.0/faces));
    } else {
      row.setString("Faces", "N/A");
      row.setString("Average face size", "N/A");
      row.setString("3-cycle faces", "N/A");
      row.setString("4-cycle faces", "N/A");
    }
  }
  void pushDominants(Vertex nodeA) {
    domain.add(nodeA);
    for (Vertex nodeB : nodeA.neighbors)
      domain.add(nodeB);
  }
}
