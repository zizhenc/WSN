class Square extends Topology {
  Square() {
    xRange=yRange=value=1;
    range=Math.sqrt(2);
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt((avg+1)*xRange*yRange/(n*Math.PI));
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=n*Math.PI*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Square";
  }
  Vertex generateVertex(int index) {
    return new Vertex(index, rnd.nextDouble()*xRange-xRange/2, rnd.nextDouble()*yRange-yRange/2, zRange, connectivity());
  }
}
