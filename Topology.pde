abstract class Topology {
  int value;
  double range, xRange, yRange, zRange;//range means the max diameter for a cylinderal coordinate system.
  Random rnd=new Random();
  abstract double getR(double avg, int n);
  abstract double getAvg(double r, int n);
  abstract Vertex generateVertex(int value);
  int connectivity() {
    return value<6?5:8;
  }
  int characteristic() {//with outer face correction
    switch(value) {
    case 1:
    case 2:
    case 3:
      return 1;
    case 4:
      return 2;
    case 5:
    case 6:
      return 0;
    default:
      return -1;
    }
  }
}
