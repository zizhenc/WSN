class NewGraph extends New {
  NewGraph() {
    inputLibrary.put("Deploy algorithms now? (Yes or No): ", new Input("Deploy algorithms now? (Yes or No): "));
    animation=new GIF("Tesseract", 48);
  }
  void enter() throws Exception {
    String prompt=inputs.get(index).prompt;
    String word=inputs.get(index).word.toLowerCase();
    if (prompt.equals("Deploy algorithms now? (Yes or No): "))
      if (word.contains("n"))
        setting();
      else if (word.contains("y")) {
        graph=new Graph(topology, _N, r);
        navigation.end=0;
        navigation.auto=false;
        navigation.go(410);
      } else
        throw new Exception('\"'+inputs.get(index).word+"\" - Nonsense message");
    else
      defaultEnter(prompt, word, "Deploy algorithms now? (Yes or No): ");
  }
}
