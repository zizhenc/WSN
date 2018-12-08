class Ball extends Topology {
  Ball() {
    range=xRange=yRange=zRange=2;
    value=8;
  }
  double getAvg(double r, int n) {
    double avg=8*n*r*r*r/(xRange*yRange*zRange)-1;
    if (avg>n-1)
      return n-1;
    else if (avg<0)
      return 0;
    else
      return avg;
  }
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.pow((avg+1)/n, 1.0/3)*range/2;
      return r>range?range:r;
    }
  }
  String toString() {
    return "Ball";
  }
  Vertex generateVertex(int value) {
    //return new Vertex(Math.pow(rnd.nextDouble(), 1/3.0), Math.sqrt(rnd.nextDouble())*Math.PI, rnd.nextDouble()*2*Math.PI, index);
    double u=Math.pow(rnd.nextDouble(), 1.0/3), a=rnd.nextDouble()*xRange-xRange/2, b=rnd.nextDouble()*yRange-yRange/2, c=rnd.nextDouble()*zRange-zRange/2;
    return new Vertex(value, xRange*u*a/(2*Math.sqrt(a*a+b*b+c*c)), yRange*u*b/(2*Math.sqrt(a*a+b*b+c*c)), zRange*u*c/(2*Math.sqrt(a*a+b*b+c*c)), connectivity());
  }
}
