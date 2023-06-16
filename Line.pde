class Line extends Topology {
  Line() {
    xRange=range=1;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=(avg+1)/(2*n);
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=2*n*r-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Line";
  }
  Vertex generateVertex(int index) {
    return new Vertex(index, rnd.nextDouble()*xRange-xRange/2, yRange, zRange, connectivity());
  }
}
