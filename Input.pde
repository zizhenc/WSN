class Input {
  int position;
  float x, y, inputWidth, inputHeight, promptLength, wordLength;
  String prompt, word="", value="";
  Input(String prompt) {
    this.prompt=prompt;
  }
  Input(String prompt, String value) {
    this(prompt);
    this.value=word=value;
    position=value.length();
  }
  boolean active() {
    if (mouseX>x&&mouseX<x+inputWidth&&mouseY>y&&mouseY<y+inputHeight) {
      if (mouseX-x-promptLength>0)
        position=round((mouseX-x-promptLength)*word.length()/wordLength);
      return true;
    }
    return false;
  }
  void cin(float x, float y) {
    pushStyle();
    initialize(x, y);
    text(prompt+word.substring(0, position)+(frameCount/10%2==0?' ':'|')+word.substring(position, word.length()), x, y+gui.thisFont.stepY());
    popStyle();
  }
  void display(float x, float y) {
    pushStyle();
    initialize(x, y);
    text(prompt+value, x, y+gui.thisFont.stepY());
    popStyle();
  }
  void initialize(float x, float y) {
    textAlign(LEFT);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    inputWidth=textWidth(prompt+value);
    inputHeight=gui.thisFont.stepY()+gui.thisFont.gap();
    wordLength=textWidth(word);
    promptLength=textWidth(prompt);
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
}
