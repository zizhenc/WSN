abstract class Method {
  int index;
  abstract boolean connecting();
  abstract void reset();
  void setCoordinate(int index) {
    reset();
  }
}
