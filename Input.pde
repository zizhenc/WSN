class Input {
  int position;
  float x, y;
  String prompt, word="", value="";
  Input(String prompt) {
    this.prompt=prompt;
  }
  boolean active() {
    return mouseX>x&&mouseX<x+textWidth(prompt+word)&&mouseY>y-gui.thisFont.stepY()&&mouseY<y;
  }
  void cin(float x, float y) {
    initialize(x, y);
    text(prompt+word.substring(0, position)+(frameCount/10%2==0?' ':'|')+word.substring(position, word.length()), x, y);
  }
  void display(float x, float y) {
    initialize(x, y);
    text(prompt+value, x, y);
  }
  void initialize(float x, float y) {
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    if (active())
      gui.kind=TEXT;
  }
  void commit() {
    value=word;
  }
  void abstain() {
    word=value;
  }
  void back() {
    if (position>0)
      position--;
  }
  void clean() {
    value=word="";
    position=0;
  }
  void keyType() {
    word=word.substring(0, position)+key+word.substring(position, word.length());
    position++;
  }
  void keyPress() {
    switch(key) {
    case BACKSPACE:
      word=word.substring(0, max(0, position-1))+word.substring(position, word.length());
      back();
      break;
    case DELETE:
      word=word.substring(0, position)+word.substring(min(position+1, word.length()), word.length());
      break;
    case CODED:
      if (keyCode==RIGHT)
        if (word.length()>position)
          position++;
      if (keyCode==LEFT)
        back();
    }
  }
  void mousePress() {
    float offset=mouseX-x-textWidth(prompt);
    float step=textWidth(word)/word.length();
    if (offset>0)
      position=round(offset/step);
  }
}
