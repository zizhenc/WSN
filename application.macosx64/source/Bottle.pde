class Bottle extends Topology {
  Bottle() {
    range=4.58;
    yRange=4.4;
    xRange=3.712;
    zRange=22.0/15;
    value=6;
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
  double getR(double avg, int n) {
    if (n==0)
      return 0;
    else {
      double r=Math.sqrt(2*Math.PI*(avg+1)/n);
      return r>range?range:r;
    }
  }
  String toString() {
    return "Bottle";
  }
  Vertex generateVertex(int index) {
    double[] u={rnd.nextDouble()*Math.PI, rnd.nextDouble()*2*Math.PI};
    return new Vertex(index, 2*Math.cos(u[0])*(30*Math.sin(u[0])+60*Math.sin(u[0])*Math.pow(Math.cos(u[0]), 6)-3*Math.cos(u[1])-5*Math.sin(u[0])*Math.cos(u[0])*Math.cos(u[1])-90*Math.sin(u[0])*Math.pow(Math.cos(u[0]), 4))/15, 
      -2+Math.sin(u[0])*(3*Math.cos(u[0])*Math.cos(u[0])*Math.cos(u[1])+48*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 4)+60*Math.sin(u[0])+5*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 3)+80*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 5)-3*Math.cos(u[1])-48*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 6)-5*Math.sin(u[0])*Math.cos(u[0])*Math.cos(u[1])-80*Math.sin(u[0])*Math.cos(u[1])*Math.pow(Math.cos(u[0]), 7))/15, 
      Math.sin(u[1])*2*(3+5*Math.sin(u[0])*Math.cos(u[0]))/15, connectivity());
  }
}
