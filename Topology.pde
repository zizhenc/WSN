abstract class Topology {
  int value;
  double range, xRange, yRange, zRange;//range means the max diameter for a cylinderal coordinate system.
  Random rnd=new Random();
  abstract double getR(double avg, int n);
  abstract double getAvg(double r, int n);
  abstract Vertex generateVertex(int value);
  boolean plane() {
    return value<6;
  }
  int characteristic() {
    return (value==5||value==6)?0:2;
  }
}
