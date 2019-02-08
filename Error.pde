class Error {
  String folder="Logs";
  PrintWriter out;
  void clean() {
    if (out!=null)
      out.close();
  }
  void logOut(String message) {
    if (out==null) {
      String timeStamp=month()+"-"+day()+"-"+year()+"_"+hour()+"-"+minute()+"-"+second();
      out=createWriter(folder+System.getProperty("file.separator")+"WSN-"+timeStamp+".log");
    }
    String timeStamp=month()+"/"+day()+"/"+year()+" "+hour()+":"+minute()+":"+second()+":"+millis();
    println("["+timeStamp+"]: "+message+"!");
    out.println("["+timeStamp+"]: "+message+".");
    gui.messageBox(message+"!", "Error Alert");
  }
}
