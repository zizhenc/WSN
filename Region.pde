class Region {
  int amount;
  PVector upVector=new PVector(0, 1, 0);
  void display(int _N, Vertex vertex) {
    if (_N<=amount) {
      pushStyle();
      switch(graph.topology.value) {
      case 1:
      case 2:
      case 3:
        parallel(vertex);
        break;
      case 4:
        sphereTangency(vertex);
        break;
      case 5:
        torusTangency(vertex);
        break;
      case 6:
      case 7:
      case 8:
        space(vertex);
      }
      popStyle();
    }
  }
  void sphereTangency(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    PVector node=new PVector((float)vertex.x, (float)vertex.y, (float)vertex.z);
    PVector axis=upVector.cross(node);
    pushMatrix();
    translate(node.x, node.y, node.z);
    rotate(PVector.angleBetween(upVector, node), axis.x, axis.y, axis.z);
    line(0, 0, 0, 0.05);
    pushMatrix();
    rotateX(HALF_PI);
    circle(0, 0, (float)graph.r*2);
    popMatrix();
    popMatrix();
  }
  void torusTangency(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    PVector origin=new PVector((float)vertex.x, (float)vertex.y, 0);
    origin.normalize();
    PVector node=new PVector((float)vertex.x, (float)vertex.y, (float)vertex.z);
    node.sub(origin);
    PVector axis=upVector.cross(node);
    pushMatrix();
    translate((float)vertex.x, (float)vertex.y, (float)vertex.z);
    rotate(PVector.angleBetween(upVector, node), axis.x, axis.y, axis.z);
    line(0, 0, 0, 0.05);
    pushMatrix();
    rotateX(HALF_PI);
    circle(0, 0, (float)graph.r*2);
    popMatrix();
    popMatrix();
  }
  void parallel(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    fill(gui.colour[2].value, 70);
    circle((float)vertex.x, (float)vertex.y, (float)graph.r*2);
  }
  void space(Vertex vertex) {
    stroke(gui.colour[2].value, 70);
    sphereDetail(12);
    noFill();
    pushMatrix();
    translate((float)vertex.x, (float)vertex.y, (float)vertex.z);
    sphere((float)graph.r);
    popMatrix();
  }
}
