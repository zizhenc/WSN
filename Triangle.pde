class Triangle extends Topology {
  Triangle() {
    xRange=1;
    yRange=Math.sqrt(3)/2;
    range=Math.sqrt(7)/2;
    value=3;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(Math.sqrt(3)*(avg+1)/(n*Math.PI))/2;
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=2*Math.PI*n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Triangle";
  }
  Vertex generateVertex(int index) {
    double[] r={rnd.nextDouble(), rnd.nextDouble()};
    return new Vertex(index, (1-Math.sqrt(r[0]))/2-r[1]*Math.sqrt(r[0])/2, (Math.sqrt(r[0])-1)*Math.sqrt(3)/6-r[1]*Math.sqrt(r[0])*Math.sqrt(3)/6+(Math.sqrt(r[0])*(1-r[1]))*Math.sqrt(3)/3-Math.sqrt(3)/12, zRange, plane());
  }
}
