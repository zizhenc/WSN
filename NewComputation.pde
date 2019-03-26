class NewComputation extends NewDeployment {
  int index;
  NewComputation() {
    animation=new GIF("Rasengan", 58);
  }
  void finish()throws Exception {
    graph=new Graph(index, topology, _N, r, method, coordinate, mode, breakpoint, connectivity);
    if (io.load)
      io.loadVertices();
    gui.thread=2;
    thread("daemon");
    setting();
    index++;
  }
}
