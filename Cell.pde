class Cell extends Method {
  CellSystem[] coordinate=new CellSystem[3];
  boolean connecting() {
    return coordinate[index].connecting();
  }
  void reset() {
    if (coordinate[index]==null)
      switch(index) {
      case 0:
        coordinate[0]=new CartesianCell();
        break;
      case 1:
        coordinate[1]=new CylindricalCell();
        break;
      case 2:
        coordinate[2]=new SphericalCell();
      }
    coordinate[index].reset();
  }
}
