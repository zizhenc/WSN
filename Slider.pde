class Slider {
  float x, y, sliderLeft, sliderRight, sliderTop, sliderBottom, min, max, value, step, scale=1, sliderWidth, sliderHeight;
  String label;
  Slider(String label) {
    this.label=label;
  }
  Slider(String label, float min) {
    this.label=label;
    this.min=min;
  }
  Slider(String label, float min, float step) {
    this.label=label;
    this.min=min;
    this.step=step;
  }
  Slider(String label, float value, float min, float max, float step) {
    this.min=min;
    this.max=max;
    this.value=constrain(value, min, max);
    this.step=step;
    this.label=label;
  }
  boolean active() {
    return mouseX>x&&mouseX<x+sliderWidth&&mouseY>sliderTop&&mouseY<sliderBottom;
  }
  boolean activeLeft() {
    return mouseX>x&&mouseX<sliderLeft&&mouseY>sliderTop&&mouseY<sliderBottom;
  }
  boolean activeRight() {
    return mouseX>sliderRight&&mouseX<x+sliderWidth&&mouseY>sliderTop&&mouseY<sliderBottom;
  }
  void decreaseValue() {
    value=constrain(value-step, min, max);
  }
  void increaseValue() {
    value=constrain(value+step, min, max);
  }
  void setMax(float max) {
    this.max=max(min, max);
  }
  void setValue(float value) {
    this.value=constrain(value, min, max);
  }
  void setPreference(float value, float max) {
    this.max=max;
    this.value=constrain(value, min, max);
  }
  void setPreference(float value, float max, float step) {
    this.max=max;
    this.value=constrain(value, min, max);
    this.step=step;
  }
  void setPreference(float value, float min, float max, float step, float scale) {
    this.min=min;
    this.max=max;
    this.value=constrain(value, min, max);
    this.step=step;
    this.scale=scale;
  }
  void display(float x, float y, float sliderWidth) {
    pushStyle();
    textAlign(LEFT);
    rectMode(CORNER);
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    this.sliderWidth=sliderWidth;
    sliderHeight=gui.thisFont.stepY(2)+gui.thisFont.gap();
    sliderLeft=this.x+gui.thisFont.stepY();
    sliderRight=this.x+sliderWidth-gui.thisFont.stepY();
    sliderTop=this.y+gui.thisFont.stepY()+gui.thisFont.gap();
    sliderBottom=this.y+sliderHeight;
    fill(gui.bodyColor[0].value);
    float range=sliderWidth-gui.thisFont.stepY(2)-gui.thisFont.stepX(2);
    text(String.format("%s: %.3f", label, value*scale), x, y+gui.thisFont.stepY());
    if (active()) {
      gui.kind=HAND;
      if (mouseX<sliderLeft) {
        noStroke();
        if (mousePressed)
          fill(gui.mainColor.value);
        else
          fill(gui.highlightColor.value, 100);
        triangle(x, y+sliderHeight-gui.thisFont.stepY(0.5), x+gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+gui.thisFont.stepY(), y+sliderHeight);
      }
      if (mouseX>sliderRight) {
        noStroke();
        if (mousePressed)
          fill(gui.mainColor.value);
        else
          fill(gui.highlightColor.value, 100);
        triangle(x+sliderWidth, y+sliderHeight-gui.thisFont.stepY(0.5), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight);
      }
      if (mousePressed&&mouseX>sliderLeft+gui.thisFont.stepX()&&mouseX<sliderRight-gui.thisFont.stepX())
        value=min+(mouseX-sliderLeft-gui.thisFont.stepX())*(max-min)/range;
      if (step%1==0)
        value=round(value);
    }
    stroke(gui.mainColor.value);
    strokeWeight(gui.unit(2));
    float position=(value-min)*range/(max-min);
    line(x+gui.thisFont.stepX()+gui.thisFont.stepY(), y+gui.thisFont.stepY(1.5)+gui.thisFont.gap(), x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+gui.thisFont.stepY(1.5)+gui.thisFont.gap());
    stroke(gui.frameColor.value);
    strokeWeight(gui.unit(2));
    line(x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+sliderHeight-gui.thisFont.stepY()+gui.unit(), x+gui.thisFont.stepX()+gui.thisFont.stepY()+position, y+sliderHeight-gui.unit());
    noFill();
    rect(x+gui.thisFont.stepX()+gui.thisFont.stepY(), y+gui.thisFont.stepY(1.25)+gui.thisFont.gap(), range, gui.thisFont.stepY(0.5), gui.unit(3));
    triangle(x, y+sliderHeight-gui.thisFont.stepY(0.5), x+gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+gui.thisFont.stepY(), y+sliderHeight);
    triangle(x+sliderWidth, y+sliderHeight-gui.thisFont.stepY(0.5), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight-gui.thisFont.stepY(), x+sliderWidth-gui.thisFont.stepY(), y+sliderHeight);
    popStyle();
  }
}
