class NewGraph extends New {
  NewGraph() {
    animation=new GIF("Tesseract", 48);
  }
  void enter() throws Exception {
    String prompt=inputs.get(index).prompt;
    String word=inputs.get(index).word.toString().toLowerCase();
    if (prompt.equals("Deploy algorithms now? (Yes or No): "))
      if (word.contains("n")) {
        io.load=false;
        setting();
      } else if (word.contains("y")) {
        graph=new Graph(topology, _N, r);
        if (io.load)
          io.loadVertices();
        navigation.end=0;
        io.load=navigation.auto=false;
        navigation.go(410);
      } else
        throw new Exception('\"'+word+"\": Nonsense message");
    else
      defaultEnter(prompt, word, "Deploy algorithms now? (Yes or No): ");
  }
}
