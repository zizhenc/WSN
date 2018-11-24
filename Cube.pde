class Cube extends Topology {
  Cube() {
    value=7;
    xRange=yRange=zRange=1;
    range=Math.sqrt(2);
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.pow((avg+1)*3*xRange*yRange*zRange/(4*n*Math.PI), 1.0/3);
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=4*n*Math.PI*r*r*r/(3*xRange*yRange*zRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  Vertex generateVertex(int value) {
    return new Vertex(value, rnd.nextDouble()*xRange-xRange/2, rnd.nextDouble()*yRange-yRange/2, rnd.nextDouble()*zRange-zRange/2, plane());
  }
  String toString() {
    return "Cube";
  }
}
