class Sphere extends Topology {
  Sphere() {
    value=4;
    range=xRange=yRange=zRange=2;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=range*Math.sqrt((avg+1)/n);
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Sphere";
  }
  Vertex generateVertex(int index) {
    return new Vertex(range/2, Math.acos(2*rnd.nextDouble()-1), 2*Math.PI*rnd.nextDouble(), index, plane());
  }
}
