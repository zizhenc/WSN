class NewDemonstration extends NewDeployment {
  NewDemonstration() {
    animation=new GIF("Infinity", 91);
  }
  void finish()throws Exception {
    graph=new Graph(topology, _N, r, method, coordinate, mode, breakpoint, connectivity);
    if (io.load)
      io.loadVertices();
    navigation.auto=true;
    navigation.end=0;
    navigation.go(410);
  }
}
