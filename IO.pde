public class IO {
  String[] header={"Color#", "Order", "Size", "Average degree", "Maximum distance", "Minimum distance", "Average distance", "Faces", "Degree-3 faces", "Dominates"}, part={"Bipartite", "Giant component", "Two-core", "Giant block"}, factor={" order", " size", " average degree", " faces", " primary dominates", " relay domminates", " dominates"};
  ArrayList<Graph> results=new ArrayList<Graph>();
  LinkedList<String> resultLabels=new LinkedList<String>();
  StringBuffer path=new StringBuffer("Results");
  boolean mode, load;
  String[] info;
  String nodes, file;
  Table tableI=new Table(), tableII=new Table();
  int[] vertices=new int[part.length], degrees=new int[part.length], coverage=new int[3];
  int[][] dominants={new int[part.length], new int[part.length], new int[part.length]};//dominaents[0]->total, dominants[1]->primary, dominants[2]->relay
  HashSet<Vertex>[] domain=new HashSet[3];//domain[0]->total, domain[1]->primary, domain[2]->relay
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
    for (int i=0; i<3; i++)
      domain[i]=new HashSet<Vertex>();
    tableII.addColumn("Primary color#");
    tableII.addColumn("Relay color#");
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
    text+="Termial clique order,"+graph.clique.size()+separator;
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
      row.setInt("Primary color#",component.primary.index);
      row.setInt("Relay color#",component.relay.index);
      for (int i=0; i<3; i++)
        domain[i].clear();
      for (Vertex node : component.giant[0])
        pushDominants(node, component.primary);
      for (int i=0; i<3; i++)
        dominants[i][3]=domain[i].size();
      if (dominants[2][3]==graph.vertex.length&&dominants[1][3]==graph.vertex.length)
        for (int i=0; i<3; i++)
          dominants[i][0]=dominants[i][1]=dominants[i][2]=dominants[i][3];
      else {
        for (LinkedList<Vertex> list : component.blocks)
          if (list!=component.giant[0]) {
            for (Vertex node : list)
              if (node.order[1]!=-1&&node.order[1]!=-3)
                pushDominants(node, component.primary);
            if (domain[2].size()==graph.vertex.length&&domain[1].size()==graph.vertex.length)
              break;
          }
        if (domain[2].size()<graph.vertex.length||domain[1].size()<graph.vertex.length)
          for (ListIterator<LinkedList<Vertex>> i=component.blocks.listIterator(component.blocks.size()-1); i.hasPrevious(); ) {
            Vertex node=i.previous().getLast();
            if (node.order[1]==-1)
              pushDominants(node, component.primary);
          }
        for (int i=0; i<3; i++)
          dominants[i][2]=domain[i].size();
        if (dominants[2][2]==graph.vertex.length&&dominants[1][2]==graph.vertex.length)
          for (int i=0; i<3; i++)
            dominants[i][0]=dominants[i][1]=dominants[i][2];
        else {
          for (Vertex node=component.degreeList[0].next; node!=null; node=node.next)
            pushDominants(node, component.primary);
          for (int i=0; i<3; i++)
            dominants[i][1]=domain[i].size();
          if (dominants[2][1]==graph.vertex.length&&dominants[1][1]==graph.vertex.length)
            for (int i=0; i<3; i++)
              dominants[i][0]=dominants[i][1];
          else {
            for (LinkedList<Vertex> list : component.components)
              if (list!=component.giant[1])
                for (Vertex node : list)
                  pushDominants(node, component.primary);
            for (int i=0; i<3; i++)
              dominants[i][0]=domain[i].size();
          }
        }
      }
      vertices[0]=component.primary.vertices.size()+component.relay.vertices.size();
      vertices[1]=component.giant[1].size();
      vertices[2]=vertices[1]-component.degreeList[0].value;
      vertices[3]=component.giant[0].size();
      for (int i=0; i<part.length; i++) {
        row.setInt(i*factor.length+2, vertices[i]);
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
        row.setInt(i*factor.length+1+2, degrees[i]/2);
        row.setFloat(i*factor.length+2+2, degrees[i]*1.0/vertices[i]);
        row.setString(i*factor.length+4+2, String.format("%d (%.2f%%)", dominants[1][i], dominants[1][i]*100.0/graph.vertex.length));
        row.setString(i*factor.length+5+2, String.format("%d (%.2f%%)", dominants[2][i], dominants[2][i]*100.0/graph.vertex.length));
        row.setString(i*factor.length+6+2, String.format("%d (%.2f%%)", dominants[0][i], dominants[0][i]*100.0/graph.vertex.length));
      }
      if (graph.topology.value<6) {
        int faces=degrees[0]/2-vertices[0]+component.components.size()-1+component.components.getFirst().size()+graph.topology.characteristic()-1;
        row.setInt("Bipartite faces", faces);
        for (int i=1; i<part.length; i++) {
          faces=degrees[i]/2-vertices[i]+graph.topology.characteristic();
          row.setInt(i*factor.length+3+2, faces);
        }
      } else
        for (int i=0; i<part.length; i++)
          row.setString(i*factor.length+3+2, "N/A");
    }
    saveTable(tableII, file);
    box.pop("Backbone summary have been saved!", "Information", "Excellent");
  }
  void kCoverage() {
    graph.calculateBackbones();
    StringBuffer text=new StringBuffer("Two-core"+System.getProperty("line.separator")+System.getProperty("line.separator"));
    int[][] primary=new int[13][graph.backbone.length], relay=new int[13][graph.backbone.length], total=new int[13][graph.backbone.length];
    String[] primeColor=new String[graph.backbone.length], relayColor=new String[graph.backbone.length], totalColor=new String[graph.backbone.length];
    for (int i=0; i<graph.backbone.length; i++) {
      Component backbone=graph.getBackbone(i);
      primeColor[i]=backbone.primary.index+"";
      relayColor[i]=backbone.relay.index+"";
      totalColor[i]=backbone.primary.index+"|"+backbone.relay.index;
      for (Vertex node : graph.vertex)
        node.k[0]=node.k[1]=0;
      for (int j=1; j<backbone.degreeList.length; j++)
        for (Vertex node=backbone.degreeList[j].next; node!=null; node=node.next)
          node.k[0]=-1;
      for (int j=1; j<backbone.degreeList.length; j++)
        for (Vertex node=backbone.degreeList[j].next; node!=null; node=node.next)
          cover(node, backbone);
      updateCoverage(primary, relay, total, i);
    }
    recordCoverage(text, primary, relay, total, primeColor, relayColor, totalColor);
    calculateCoverage("Giant block", 0, text, primary, relay, total, primeColor, relayColor, totalColor);
    calculateCoverage("Giant component", 1, text, primary, relay, total, primeColor, relayColor, totalColor);
    output(text.toString());
    box.pop("Backbone k-coverages have been saved!", "Information", "Cool");
  }
  void calculateCoverage(String core, int coreIndex, StringBuffer text, int[][] primary, int[][] relay, int[][] total, String[] primeColor, String[] relayColor, String[] totalColor) {
    text.append(core+System.getProperty("line.separator")+System.getProperty("line.separator"));
    for (int i=0; i<total.length; i++)
      for (int j=0; j<graph.backbone.length; j++) {
        primary[i][j]=0;
        relay[i][j]=0;
        total[i][j]=0;
      }
    for (int i=0; i<graph.backbone.length; i++) {
      Component backbone=graph.getBackbone(i);
      for (Vertex node : graph.vertex)
        node.k[0]=node.k[1]=0;
      for (Vertex node : backbone.giant[coreIndex]){
        node.k[0]=-1;
        cover(node, backbone);
      }
      updateCoverage(primary, relay, total, i);
    }
    recordCoverage(text, primary, relay, total, primeColor, relayColor, totalColor);
  }
  void cover(Vertex nodeA, Component backbone) {
    for (Vertex nodeB : nodeA.neighbors)
      if (nodeB.k[0]>=0)
        nodeB.k[nodeA.primeColor==backbone.primary?0:1]++;
  }
  void updateCoverage(int[][] primary, int[][] relay, int[][] total, int backbone) {
    for (Vertex node : graph.vertex)
      if (node.k[0]>=0) {
        primary[node.k[0]][backbone]++;
        relay[node.k[1]][backbone]++;
        total[node.k[0]+node.k[1]][backbone]++;
      }
  }
  void recordCoverage(StringBuffer text, int[][] primary, int[][] relay, int[][] total, String[] primeColor, String[] relayColor, String[] totalColor) {
    coverage[0]=coverage[1]=coverage[2]=-1;
    for (int i=total.length-1; i>=0; i--) {
      for (int j=0; j<graph.backbone.length; j++) {
        if (coverage[0]<0&&primary[i][j]>0)
          coverage[0]=i;
        if (coverage[1]<0&&relay[i][j]>0)
          coverage[1]=i;
        if (coverage[2]<0&&total[i][j]>0)
          coverage[2]=i;
        if (coverage[0]>=0&&coverage[1]>=0&&coverage[2]>=0)
          break;
      }
      if (coverage[0]>=0&&coverage[1]>=0&&coverage[2]>=0)
        break;
    }
    text.append("Primary#");
    for (int i=0; i<graph.backbone.length; i++)
      text.append(","+primeColor[i]);
    recordPartCoverage(text, 0, primary);
    text.append("Relay#");
    for (int i=0; i<graph.backbone.length; i++)
      text.append(","+relayColor[i]);
    recordPartCoverage(text, 1, relay);
    text.append("Total#|#");
    for (int i=0; i<graph.backbone.length; i++)
      text.append(","+totalColor[i]);
    recordPartCoverage(text, 2, total);
    text.append(System.getProperty("line.separator"));
  }
  void recordPartCoverage(StringBuffer text, int partIndex, int[][] coverMatrix) {
    text.append(System.getProperty("line.separator"));
    for (int i=coverage[partIndex]; i>=0; i--) {
      text.append(i);
      for (int j=0; j<graph.backbone.length; j++)
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
    row.setInt("Color#", colour.index);
    row.setInt("Order", colour.vertices.size());
    colour.initialize(domain[0]);
    while (colour.deploy==1)
      colour.deploying();
    int degree=0;
    for (Vertex node : colour.vertices)
      degree+=node.arcs.size();
    row.setInt("Size", degree/2);
    row.setFloat("Average degree", degree*1.0/colour.vertices.size());
    row.setDouble("Maximum distance", colour.maxDistance);
    row.setDouble("Minimum distance", colour.minDistance);
    row.setDouble("Average distance", colour.distance*2/degree);
    row.setString("Dominates", String.format("%d (%.2f%%)", colour.domination, colour.domination*100.0/graph.vertex.length));
    if (graph.topology.value<6) {
      int faces=degree/2-colour.vertices.size()+graph.topology.characteristic();
      row.setInt("Faces", faces);
      row.setString("Degree-3 faces", String.format("%d (%.2f%%)", colour.cycles, colour.cycles*100.0/faces));
    } else {
      row.setString("Faces", "N/A");
      row.setString("Degree-3 faces", "N/A");
    }
  }
  void pushDominants(Vertex nodeA, Color prime) {
    HashSet<Vertex> subDomain=nodeA.primeColor==prime?domain[1]:domain[2];
    if (domain[0].size()<graph.vertex.length) {
      domain[0].add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        domain[0].add(nodeB);
    }
    if (subDomain.size()<graph.vertex.length) {
      subDomain.add(nodeA);
      for (Vertex nodeB : nodeA.neighbors)
        subDomain.add(nodeB);
    }
  }
}
