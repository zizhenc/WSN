class Graph {
  int _E, maxDegree, minDegree, maxMinDegree, primaries, methodIndex, connectivity=2, coordinateIndex;
  int[] degreeDistribution;
  float breakpoint;
  double r;
  String timeStamp;
  boolean partitionModal;
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
    list[0]=degreeList.get(0);
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
    nodeA.avgDegree=degree[0]*2.0/vertices;
    nodeA.avgOrgDegree=degree[1]*1.0/vertices;
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
    for (int i=0; i<slot.length; i++)
      slot[i]=false;
    for (Vertex node : vertex[index].neighbors)
      if (node.value<vertex[index].value&&node.primeColor!=null)
        slot[node.primeColor.index]=true;
    int i=0;
    while (slot[i])
      i++;
    vertex[index].primeColor=getColor(i);
    if (vertex[index].primeColor.vertices.isEmpty())
      _SLColors.add(vertex[index].primeColor);
    for (Vertex node : vertex[index].neighbors)
      node.categorize(vertex[index]);
    vertex[index].primeColor.vertices.addLast(vertex[index]);
  }
  int selectPrimarySet(int pivot) {
    if (primaries<=0)
      if (partitionModal&&-primaries*100.0/vertex.length>=breakpoint) {
        primaries=-primaries;
        int offset=_PYColors.get(_PYColors.size()-1).vertices.size();
        if (abs(primaries*100.0/vertex.length-breakpoint)>abs((primaries-offset)*100.0/vertex.length-breakpoint)) {
          primaries-=offset;
          _PYColors.remove(_PYColors.size()-1);
          pivot--;
        }
      } else if (_PYColors.size()==round(breakpoint))
        primaries=-primaries;
      else {
        Color colour=_SLColors.get(pivot);
        primaries-=colour.vertices.size();
        _PYColors.add(colour);
        pivot++;
      }
    return pivot;
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
  int colour(boolean[] slot, int index) {//relay coloring
    if (relayList[index].isEmpty())
      return index-1;
    else {
      Vertex nodeA=relayList[index].removeFirst();
      for (int i=0; i<_PYColors.size(); i++)
        slot[i]=false;
      for (int i=_PYColors.size(); i<_SLColors.size(); i++)
        for (Vertex nodeB : nodeA.linksAt(_SLColors.get(i)))
          if (nodeB.relayColor!=null)
            slot[nodeB.relayColor.index-_SLColors.size()]=true;
      for (Color colour : nodeA.colorList[index-1])
        if (!slot[colour.index]) {
          nodeA.relayColor=getColor(colour.index+_SLColors.size());
          if (nodeA.relayColor.vertices.isEmpty())
            _RLColors.add(nodeA.relayColor);
          nodeA.relayColor.vertices.addLast(nodeA);
          nodeA.sequence=2;//relayColored indicator
          break;
        }
      if (nodeA.relayColor==null)
        pushRelayList(index, nodeA);
      return index;
    }
  }
  Component getBackbone(int index) {
    if (backbone==null)
      backbone=new Component[_RLColors.size()];
    if (backbone[index]==null)
      backbone[index]=new Component(_PYColors.get(_RLColors.get(index).index-_SLColors.size()), _RLColors.get(index), topology.connectivity());
    return backbone[index];
  }
  void pushRelayList(int index, Vertex node) {
    while (--index>0&&node.colorList[index-1].isEmpty());
    relayList[index].addLast(node);
    node.sequence=index<connectivity-1?3:1;//surplus:uncolored
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
}
