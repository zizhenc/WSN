abstract class AnimationPlayer {
  float x, y, playerWidth, playerHeight, playWidth, playHeight, barWidth, barX, barY, barHeight, gap;
  Animation animation;
  abstract void show(String time);
  void display(int mode, float x, float y, float factor) {
    this.x=screenX(x, y);
    this.y=screenY(x, y);
    playerWidth=animation.animeWidth;
    pushStyle();
    imageMode(CORNER);
    animation.display(mode, x, y, factor);
    rectMode(CORNER);
    noFill();
    strokeWeight(gui.unit());
    stroke(gui.frameColor.value);
    rect(x, y, playerWidth, animation.animeHeight);
    show(String.format("%02d:%02d:%02d", animation.hours(), animation.minutes(), animation.seconds()));
    strokeWeight(gui.unit(2));
    stroke(gui.frameColor.value);
    if (inPlay())
      fill(gui.highlightColor.value, 100);
    else
      noFill();
    rect(x, y+animation.animeHeight+gui.thisFont.gap(), playWidth, playHeight, gui.unit(8));
    if (animation.isPlaying) {
      stroke(gui.bodyColor[mousePressed?0:2].value);
      strokeWeight(playWidth/15);
      line(x+playWidth*3/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight/3, x+playWidth*3/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight*2/3);
      line(x+playWidth*4/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight/3, x+playWidth*4/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight*2/3);
    } else {
      fill(gui.bodyColor[mousePressed?0:2].value);
      noStroke();
      triangle(x+playWidth*3/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight/3, x+playWidth*3/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight*2/3, x+playWidth*4/7, y+animation.animeHeight+gui.thisFont.gap()+playHeight/2);
    }
    popStyle();
  }
  boolean inPlay() {
    return mouseX>x&&mouseX<playWidth&&mouseY<y+playerHeight&&mouseY>y+playerHeight-playHeight;
  }
  void mouseRelease() {
    if (inPlay())
      if (animation.isPlaying)
        animation.pause();
      else
        animation.play();
  }
  void keyRelease() {
    switch(Character.toLowerCase(key)) {
    case 'p':
    case ' ':
      if (animation.isPlaying)
        animation.pause();
      else
        animation.play();
      break;
    }
  }
}
