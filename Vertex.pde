class Vertex {//value: vertex ID or list size; degree: degreeList index or degree when deleted; order: DFS order; lowpoint: DFS lowpoint or degree when deleted; sequence: 0->PYColor; 1->Uncolored; 2->Relay-colored 3->surplus
  int value, degree, order, lowpoint, sequence, mark=-1;//mark <0 notInGraph >=0 inGraph or traverse mark for tails
  float avgDegree, avgOrgDegree;
  double x, y, z, rho, pho, theta, phi;
  HashMap<Color, LinkedList<Vertex>> colorNeighbors;
  Color primeColor, relayColor;
  Vertex previous, next;
  LinkedList<Vertex> neighbors, arcs, links;
  LinkedList<Color>[] colorList;
  ListIterator<Vertex> edgeIndicator;
  Vertex () {
  }
  Vertex(int degree) {
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
  double distance(Vertex node) {
    return Math.sqrt(squaredDistance(node));
  }
  double squaredDistance(Vertex node) {
    return (x-node.x)*(x-node.x)+(y-node.y)*(y-node.y)+(z-node.z)*(z-node.z);
  }
  double arctan(double y, double x) {
    double ans=Math.atan2(y, x);
    return ans<0?Math.PI*2+ans:ans;
  }
  Vertex pop() {
    Vertex vertex=next;
    next=vertex.next;
    if (next!=null)
      next.previous=this;
    value--;
    return vertex;
  }
  LinkedList<Vertex> linksAt(Color colour) {
    LinkedList<Vertex> list=colorNeighbors.get(colour);
    return list==null?gui.mainColor.vertices:list;
  }
  void setEdgeIndicator() {
    edgeIndicator=links.listIterator();
  }
  void clearNeighbors() {
    neighbors.clear();
    mark=-1;
  }
  void clean() {
    next=null;
    value=0;
  }
  void push(Vertex vertex) {
    vertex.previous=this;
    vertex.next=next;
    if (next!=null)
      next.previous=vertex;
    next=vertex;
    value++;
  }
  void solo(Vertex head) {
    head.value--;
    previous.next=next;
    if (next!=null)
      next.previous=previous;
  }
  void categorize(Vertex node) {
    LinkedList<Vertex> list=colorNeighbors.putIfAbsent(node.primeColor, new LinkedList<Vertex>());
    if (list==null)
      colorNeighbors.get(node.primeColor).addLast(node);
    else
      list.addLast(node);
  }
  void clearColor(Color colour) {
    if (colour==primeColor) {
      primeColor=null;
      colorNeighbors.clear();
    }
    if (colour==relayColor)
      clearRelayColor();
  }
  void clearRelayColor() {
    for (LinkedList<Color> list : colorList)
      list.clear();
    relayColor=null;
    sequence=0;
  }
  void initialize(int value, int connectivity) {
    this.value=value;
    neighbors=new LinkedList<Vertex>();
    colorList=new LinkedList[connectivity-1];//0 means 2 in connectivity 
    for (int i=0; i<colorList.length; i++)
      colorList[i]=new LinkedList<Color>();
    colorNeighbors=new HashMap<Color, LinkedList<Vertex>>();
  }
  void setCoordinates(double x, double y, double z) {
    this.x=x;
    this.y=y;
    this.z=z;
  }
}
