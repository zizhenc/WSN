class Vertex {
  int value, degree, lowpoint=-1;//value: vertex ID or list size; degree: degreeList index or degree when deleted; order: DFS order; lowpoint: DFS lowpoint or degree when deleted and isGraph mark;
  int[] order={-5, -6};//order[0] for random combined bipartite, order[1] for archived backbones; 0->minor components, >0->minor blocks, -1->MB separates, -2->tails, -3->GB separates -4->giant block -5->surplus
  float avgDegree, avgOrgDegree;
  double x, y, z, rho, pho, theta, phi;
  boolean mark;//mark for tail counting
  HashMap<Color, LinkedList<Vertex>> coloredNeighbors;
  Color primeColor, relayColor;
  Vertex previous, next;
  LinkedList<Vertex> neighbors, arcs, links;//arcs used in independent set for gabriel graph, links used in bipartite subgraph
  LinkedList<Color>[] colorList;//used in relay coloring color list according to relay degree
  int[] k=new int[5];//k coverage for all backbones 0: tails, 1 is for giant block without separating nodes, 2 is for minor blocks without separating nodes, 3 is for separating nodes, 4 is for minor components
  ListIterator<Vertex> edgeIndicator;
  Vertex () {
  }
  Vertex(int degree) {//degreeList is a doubly linked list with head
    this.degree=degree;
  }
  Vertex(int value, double x, double y, double z, int connectivity) {//cartesian system
    this.x=x;
    this.y=y;
    this.z=z;
    pho=Math.sqrt(x*x+y*y);
    rho=Math.sqrt(x*x+y*y+z*z);
    phi=arctan(y, x);
    theta=rho==0?0:Math.acos(z/rho);
    initialize(value, connectivity);
  }
  Vertex(double rho, double theta, double phi, int value, int connectivity) {//spherical system
    this.rho=rho;
    this.theta=theta;
    this.phi=phi;
    x=rho*(theta==Math.PI/2?1:Math.sin(theta))*Math.cos(phi);
    y=rho*(theta==Math.PI/2?1:Math.sin(theta))*Math.sin(phi);
    z=theta==Math.PI/2?0:rho*Math.cos(theta);
    pho=theta==Math.PI/2?rho:Math.sqrt(x*x+y*y);
    initialize(value, connectivity);
  }
  double arctan(double y, double x) {
    double ans=Math.atan2(y, x);
    return ans<0?Math.PI*2+ans:ans;
  }
  double distance(Vertex node) {
    return Math.sqrt(squaredDistance(node));
  }
  double squaredDistance(Vertex node) {
    return (x-node.x)*(x-node.x)+(y-node.y)*(y-node.y)+(z-node.z)*(z-node.z);
  }
  Vertex pop() {//pop out the 1st node
    if (next==null)
      return this;
    else {
      Vertex vertex=next;
      next=vertex.next;
      if (next!=null)
        next.previous=this;
      value--;
      return vertex;
    }
  }
  LinkedList<Vertex> linksAt(Color colour) {//return neighbors according to color from hashmap
    LinkedList<Vertex> list=coloredNeighbors.get(colour);
    return list==null?gui.mainColor.vertices:list;
  }
  void setEdgeIndicator() {//reset listIterator of links
    edgeIndicator=links.listIterator();
  }
  void setCoordinates(double x, double y, double z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }
  void clearColor(Color colour) {
    if (colour==primeColor) {//use if else to achieve the clearColor(null) usage, which clear relays only
      primeColor=null;
      coloredNeighbors.clear();
    } else {
      for (LinkedList<Color> list : colorList)
        list.clear();
      relayColor=null;
      order[1]=-6;
    }
  }
  void initialize(int value, int connectivity) {
    this.value=value;
    neighbors=new LinkedList<Vertex>();
    colorList=new LinkedList[connectivity-1];//0 means 2 in connectivity 
    for (int i=0; i<colorList.length; i++)
      colorList[i]=new LinkedList<Color>();
    coloredNeighbors=new HashMap<Color, LinkedList<Vertex>>();
  }
  void categorize(Vertex node) {//push node to corresponding coloredNeighbors
    if (coloredNeighbors.containsKey(node.primeColor))
      coloredNeighbors.get(node.primeColor).addLast(node);
    else {
      LinkedList<Vertex> list=new LinkedList<Vertex>();
      list.addLast(node);
      coloredNeighbors.put(node.primeColor, list);
    }
  }
  void clean() {//clear the list
    next=null;
    value=0;
  }
  void push(Vertex vertex) {//push node to the list at 1st location
    vertex.previous=this;
    vertex.next=next;
    if (next!=null)
      next.previous=vertex;
    next=vertex;
    value++;
  }
  void solo(Vertex head) {//solo from a list
    head.value--;
    previous.next=next;
    if (next!=null)
      next.previous=previous;
  }
}
