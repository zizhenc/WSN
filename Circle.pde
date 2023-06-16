class Circle extends Topology {
  Circle() {
    xRange=yRange=range=2;
    value=-1;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=(avg+1)*Math.PI/n;
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=n*r/Math.PI-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Circle";
  }
  Vertex generateVertex(int index) {
    return new Vertex(1.0, Math.PI/2, rnd.nextDouble()*2*Math.PI, index, connectivity());
  }
}
