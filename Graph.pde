class Graph {
  int index, _E, maxDegree, minDegree, maxMinDegree, methodIndex, connectivity=2, coordinateIndex, primaries=-1;//primaries is order of selected graph adjusted back 1 for mark when the algorithm stopped or continue.
  int[] degreeDistribution;
  float breakpoint;
  double r;
  boolean mode;//partitioning mode, true means auto mode, false means manual mode
  ArrayList<Color> colorLibrary=new ArrayList<Color>(), _SLColors=new ArrayList<Color>(), _RLColors=new ArrayList<Color>(), _PYColors=new ArrayList<Color>();
  ArrayList<Vertex> degreeList=new ArrayList<Vertex>();
  Vertex[] vertex;
  Method[] method=new Method[3];
  Topology topology;
  Component[] backbone;
  LinkedList<Vertex> clique=new LinkedList<Vertex>();
  LinkedList<Vertex>[] relayList;
  Graph(Topology topology, int _N, double r) {
    this.topology=topology;
    this.r=r;
    relayList=new LinkedList[topology.connectivity()];//2D possible max degree=5, 3D is 7
    for (int i=0; i<relayList.length; i++)
      relayList[i]=new LinkedList<Vertex>();
    vertex=new Vertex[_N];
  }
  Graph(Topology topology, int _N, double r, int methodIndex, int coordinateIndex, boolean mode, float breakpoint, int connectivity) {
    this(topology, _N, r);
    this.methodIndex=methodIndex;
    this.coordinateIndex=coordinateIndex;
    this.mode=mode;
    this.breakpoint=breakpoint;
    this.connectivity=connectivity;
  }
  Graph(int index, Topology topology, int _N, double r, int methodIndex, int coordinateIndex, boolean mode, float breakpoint, int connectivity) {
    this(topology, _N, r, methodIndex, coordinateIndex, mode, breakpoint, connectivity);
    this.index=index;
  }
  void compute() {
    for (int i=0; i<vertex.length; i++)
      vertex[i]=topology.generateVertex(i);
    int linkms=millis();
    initialize();
    while (method[methodIndex].connecting());
    linkms=millis()-linkms;
    int _SLColorms=millis();
    generateDegreeList();
    int[] degree={_E, 2*_E};
    Vertex[] list=new Vertex[2];
    list[1]=degreeList.get(maxDegree);
    int amount=vertex.length;
    while (amount>0) {
      order(amount, degree, list);
      amount--;
    }
    boolean[] slot=new boolean[maxMinDegree+1];
    while (amount<vertex.length) {
      colour(amount, slot);
      amount++;
    }
    _SLColorms=millis()-_SLColorms;
    int _RLColorms=millis();
    while (primaries<0)
      selectPrimarySet();
    for (int i=_PYColors.size(); i<_SLColors.size(); i++)
      for (Vertex nodeA : _SLColors.get(i).vertices)
        for (Vertex nodeB : nodeA.neighbors)
          nodeA.categorize(nodeB);
    generateRelayList(connectivity);
    for (amount=relayList.length; amount>=connectivity; amount=colour(slot, amount));
    _RLColorms=millis()-_RLColorms;
    navigation.end=7;
    box.pop("Graph "+index+" computation acomplished!\nLink generation: "+linkms+" ms\nSmallest-last coloring: "+_SLColorms+" ms\nRelay coloring: "+_RLColorms+" ms\n", "Information", "Gotcha");
  }
  void initialize() {
    if (method[methodIndex]==null)
      switch(methodIndex) {
      case 0:
        method[0]=new Exhaustive();
        break;
      case 1:
        method[1]=new Sweep();
        break;
      case 2:
        method[2]=new Cell();
      }
    method[methodIndex].setCoordinate(coordinateIndex);
  }
  void generateDegreeList() {
    for (Vertex node : vertex) {
      node.degree=node.neighbors.size();
      while (node.degree>=degreeList.size())
        degreeList.add(new Vertex(degreeList.size()));
      degreeList.get(node.degree).push(node);
    }
    maxDegree=degreeList.size()-1;
    while (degreeList.get(minDegree).value==0)
      minDegree++;
    degreeDistribution=new int[maxDegree+1];
    for (int i=minDegree; i<=maxDegree; i++)
      degreeDistribution[i]=degreeList.get(i).value;
  }
  void order(int vertices, int[] degree, Vertex[] list) {
    list[0]=degreeList.get(0);//list[0] means minDegreeList
    while (list[0].value==0)
      list[0]=degreeList.get(list[0].degree+1);
    while (list[1].value==0)
      list[1]=degreeList.get(list[1].degree-1);
    if (list[0]==list[1]&&clique.isEmpty())
      for (Vertex node=list[0].next; node!=null; node=node.next)
        clique.addLast(node);
    if (maxMinDegree<list[0].degree)
      maxMinDegree=list[0].degree;
    Vertex nodeA=list[0].pop();
    if (nodeA.value!=vertices-1) {
      Vertex nodeB=vertex[vertices-1];
      vertex[vertices-1]=nodeA;
      vertex[nodeA.value]=nodeB;
      nodeB.value=nodeA.value;
      nodeA.value=vertices-1;
    }
    nodeA.avgDegree=degree[0]*2f/vertices;
    nodeA.avgOrgDegree=degree[1]*1f/vertices;
    for (Vertex nodeB : nodeA.neighbors)
      if (nodeB.value<nodeA.value) {
        nodeB.solo(degreeList.get(nodeB.degree));
        nodeB.degree--;
        degreeList.get(nodeB.degree).push(nodeB);
      }
    degree[1]-=nodeA.neighbors.size();
    degree[0]-=nodeA.degree;//degree when deleted
  }
  void colour(int index, boolean[] slot) {//smallest-last coloring
    for (int i=0; i<=maxMinDegree; i++)
      slot[i]=false;
    for (Vertex node : vertex[index].neighbors)
      if (node.value<vertex[index].value&&node.primeColor!=null)
        slot[node.primeColor.index]=true;
    int i=0;
    for (; slot[i]; i++);
    vertex[index].primeColor=getColor(i);
    if (vertex[index].primeColor.vertices.isEmpty())
      _SLColors.add(vertex[index].primeColor);
    vertex[index].primeColor.vertices.addLast(vertex[index]);
  }
  void selectPrimarySet() {
    if (primaries<0) {
      if (mode) {
        if ((primaries+1)*-100.0/vertex.length<breakpoint)
          addPrimaryColor();
        else {
          primaries=-(primaries+1);
          int offset=_PYColors.get(_PYColors.size()-1).vertices.size();
          if (primaries*100.0/vertex.length-breakpoint>breakpoint-(primaries-offset)*100.0/vertex.length) {
            primaries-=offset;
            _PYColors.remove(_PYColors.size()-1);
          }
        }
      } else if (_PYColors.size()==round(breakpoint))
        primaries=-primaries-1;
      else
        addPrimaryColor();
    }
  }
  void addPrimaryColor() {
    Color colour=_SLColors.get(_PYColors.size());
    primaries-=colour.vertices.size();
    _PYColors.add(colour);
  }
  void generateRelayList(int connectivity) {
    for (int i=_PYColors.size(); i<_SLColors.size(); i++)
      for (Vertex node : _SLColors.get(i).vertices) {
        for (Color colour : _PYColors) {
          int size=node.linksAt(colour).size();
          if (size>=connectivity)
            node.colorList[size-2].addLast(colour);
        }
        pushRelayList(relayList.length, node);
      }
  }
  int colour(boolean[] slot, int connection) {//relay coloring //connection is the index+1
    if (relayList[connection-1].isEmpty())
      connection--;
    else {
      Vertex nodeA=relayList[connection-1].removeFirst();
      for (int i=0; i<_PYColors.size(); i++)
        slot[i]=false;
      for (int i=_PYColors.size(); i<_SLColors.size(); i++)
        for (Vertex nodeB : nodeA.linksAt(_SLColors.get(i)))
          if (nodeB.relayColor!=null)
            slot[nodeB.relayColor.index-_SLColors.size()]=true;
      for (Color colour : nodeA.colorList[connection-2])
        if (!slot[colour.index]) {
          nodeA.relayColor=getColor(colour.index+_SLColors.size());
          if (nodeA.relayColor.vertices.isEmpty())
            _RLColors.add(nodeA.relayColor);
          nodeA.relayColor.vertices.addLast(nodeA);
          break;
        }
      if (nodeA.relayColor==null)
        pushRelayList(connection-1, nodeA);
    }
    return connection;
  }
  void initailizeBackbones() {
    if (backbone==null||backbone.length<_RLColors.size())
      backbone=new Component[_RLColors.size()];
  }
  Component getBackbone(int index) {
    if (backbone[index]==null)
      if (_RLColors.isEmpty())
        backbone[index]=new Component(gui.mainColor, gui.mainColor, topology.connectivity());
      else
        backbone[index]=new Component(_PYColors.get(_RLColors.get(index).index-_SLColors.size()), _RLColors.get(index), topology.connectivity());
    else if (backbone[index].archive==-1)
      if (_RLColors.isEmpty())
        backbone[index].reset(gui.mainColor, gui.mainColor, 1);
      else
        backbone[index].reset(_PYColors.get(_RLColors.get(index).index-_SLColors.size()), _RLColors.get(index), 1);
    return backbone[index];
  }
  void calculateBackbones() {
    initailizeBackbones();
    for (int i=0; i<_RLColors.size(); i++)
      while (getBackbone(i).deleting());
  }
  void pushRelayList(int index, Vertex node) {
    while (--index>0&&node.colorList[index-1].isEmpty());
    relayList[index].addLast(node);
    if (index<connectivity-1)
      node.order[1]=-5;//surplus indicator
  }
  Color getColor(int index) {
    while (index>=colorLibrary.size())
      colorLibrary.add(generateColor(colorLibrary.size()));
    return colorLibrary.get(index);
  }
  Color generateColor(int index) {
    float division=11184810.6667/(maxMinDegree+1);
    int value=floor(random(16777216-division*(index+1), 16777216-division*index));
    return new Color(value, index);
  }
  int surplus() {
    int order=0;
    for (int i=0; i<connectivity-1; i++)
      order+=relayList[i].size();
    return order;
  }
}
