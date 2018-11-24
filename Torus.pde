class Torus extends Topology {
  Torus() {
    range=xRange=yRange=3;
    zRange=1;
    value=5;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(2*Math.PI*(avg+1)/n);
      return r>range?range:r;
    }
  }
  double getAvg(double r, int n) {
    double avg=n*r*r/(2*Math.PI)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }

  String toString() {
    return "Torus";
  }
  Vertex generateVertex(int index) {
    double[] u={rnd.nextDouble()*2*Math.PI, rnd.nextDouble()*2*Math.PI};
    return new Vertex(index, (1+Math.cos(u[1])/2)*Math.cos(u[0]), (1+Math.cos(u[1])/2)*Math.sin(u[0]), Math.sin(u[1])/2, plane());
  }
}
