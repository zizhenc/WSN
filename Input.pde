class Input {
  int position;
  float x, y, inputWidth, inputHeight, promptLength, wordLength;
  String prompt, value="";
  StringBuffer word;
  Input(String prompt) {
    this(prompt, new StringBuffer(""));
  }
  Input(String prompt, StringBuffer word) {
    this.prompt=prompt;
    this.word=word;
    value=word.toString();
    position=word.length();
  }
  boolean active() {
    if (mouseX>x&&mouseX<x+inputWidth&&mouseY>y&&mouseY<y+inputHeight) {
      if (mouseX-x-promptLength>0)
        position=round((mouseX-x-promptLength)*word.length()/wordLength);
      return true;
    }
    return false;
  }
  void setValue(String value) {
    this.value=value;
    position=value.length();
    word.delete(0, word.length());
    word.append(value);
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
    wordLength=textWidth(word.toString());
    promptLength=textWidth(prompt);
  }
  void commit() {
    value=word.toString();
  }
  void abstain() {
    word.delete(0, word.length());
    word.append(value);
  }
  void clean() {
    value="";
    word.delete(0, word.length());
    position=0;
  }
  void keyType() {
    word.insert(position, key);
    position++;
  }
  void keyPress() {
    switch(key) {
    case BACKSPACE:
      if (position>0) {
        position--;
        word.deleteCharAt(max(0, position));
      }
      break;
    case DELETE:
      if (position<word.length())
        word.deleteCharAt(position);
      break;
    case CODED:
      if (keyCode==RIGHT)
        if (word.length()>position)
          position++;
      if (keyCode==LEFT)
        if (position>0)
          position--;
    }
  }
}
