class Disk extends Topology {
  Disk() {
    range=xRange=yRange=value=2;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt((avg+1)*xRange*yRange/n)/2;
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=4*n*r*r/(xRange*yRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  String toString() {
    return "Disk";
  }
  Vertex generateVertex(int index) {
    return new Vertex(Math.sqrt(rnd.nextDouble()*range/2), Math.PI/2, rnd.nextDouble()*2*Math.PI, index, connectivity());
  }
}
