abstract class NewDeployment extends New {
  int method, coordinate, connectivity;
  float breakpoint;
  boolean mode;
  abstract void finish()throws Exception;
  NewDeployment() {
    inputLibrary.put("Select graph generating method (Exhaustive, Sweep or Cell): ", new Input("Select graph generating method (Exhaustive, Sweep or Cell): "));
    inputLibrary.put("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ", new Input("Choose a coordinate system (Cartesian, Cylindrical or Spherical): "));
    inputLibrary.put("Choose a coordinate system (Cartesian or Cylindrical): ", new Input("Choose a coordinate system (Cartesian or Cylindrical): "));
    inputLibrary.put("Select primary sets (quantity or percentage): ", new Input("Select primary sets (quantity or percentage): "));
    inputLibrary.put("Enter connectivity: ", new Input("Enter connectivity: "));
  }
  void enter() throws Exception {
    String prompt=inputs.get(index).prompt;
    String word=inputs.get(index).word.toString().toLowerCase();
    if (prompt.equals("Select graph generating method (Exhaustive, Sweep or Cell): ")) {
      if (word.contains("exhaustive")) {
        method=0;
        commit("Select primary sets: ");
      } else if (word.contains("sweep")) {
        method=1;
        commit("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ");
      } else if (word.contains("cell")) {
        method=2;
        commit(topology.value==4?"Choose a coordinate system (Cartesian, Cylindrical or Spherical): ":"Choose a coordinate system (Cartesian or Cylindrical): ");
      } else
        throw new Exception('\"'+word+"\": No such method");
    } else if (prompt.equals("Choose a coordinate system (Cartesian or Cylindrical): ")) {
      if (word.contains("cartesian"))
        coordinate=0;
      else if (word.contains("cylindrical"))
        coordinate=1;
      else
        throw new Exception('\"'+word+"\": No such coordinate system");
      commit("Select primary sets (quantity or percentage): ");
    } else if (prompt.equals("Choose a coordinate system (Cartesian, Cylindrical or Spherical): ")) {
      if (word.contains("cartesian"))
        coordinate=0;
      else if (word.contains("cylindrical"))
        coordinate=1;
      else if (word.contains("spherical"))
        coordinate=2;
      else
        throw new Exception('\"'+word+"\": No such coordinate system");
      commit("Select primary sets (quantity or percentage): ");
    } else if (prompt.equals("Select primary sets (quantity or percentage): ")) {
      if (word.contains("%")) {
        breakpoint=Float.parseFloat(word.substring(0, word.indexOf("%")));
        if (breakpoint<=0||breakpoint>100)
          throw new NumberFormatException('\"'+word+"\": Invalid breakpoint");
        mode=true;
      } else {
        breakpoint=Integer.parseInt(word);
        if (breakpoint<=0)
          throw new NumberFormatException('\"'+word+"\": Invalid amount");
        mode=false;
      }
      commit("Enter connectivity: ");
    } else if (prompt.equals("Enter connectivity: ")) {
      connectivity=Integer.parseInt(word);
      if (connectivity<0||connectivity>topology.connectivity())
        throw new NumberFormatException('\"'+word+"\": Invalid connectivity");
      commit("Deploy algorithms now? (Yes or No): ");
    } else if (prompt.equals("Deploy algorithms now? (Yes or No): ")) {
      if (word.contains("n")) {
        io.load=false;
        setting();
      } else if (word.contains("y"))
        finish();
      else
        throw new Exception('\"'+word+"\": Nonsense message");
    } else
      defaultEnter(prompt, word, "Select graph generating method (Exhaustive, Sweep or Cell): ");
  }
}
