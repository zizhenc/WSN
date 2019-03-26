abstract class Method {
  int index;//coordinateIndex
  abstract boolean connecting();
  abstract void reset();
  void setCoordinate(int index) {
    this.index=index;
    reset();
  }
}
