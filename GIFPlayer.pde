class GIFPlayer extends AnimationPlayer {
  GIFPlayer(String filename, int count) {
    animation=new GIF(filename, count);
  }
  void show(String time) {
    strokeWeight(gui.unit(2));
    playWidth=(playerWidth-textWidth(time)-gui.thisFont.stepX(2))/11;
    playHeight=playWidth*9/16;
    float barHeight=playHeight-gui.thisFont.gap(2), barWidth=playerWidth-playWidth-gui.thisFont.stepX(2)-textWidth(time);
    playerHeight=animation.animeHeight+gui.thisFont.gap()+playHeight;
    strokeWeight(gui.unit(2));
    noStroke();
    fill(gui.baseColor.value);
    rect(x+playWidth+gui.thisFont.stepX(2)+textWidth(time), y+animation.animeHeight+gui.thisFont.gap(2), barWidth*animation.position(), barHeight, gui.unit(8));
    noFill();
    stroke(gui.frameColor.value);
    rect(x+playWidth+gui.thisFont.stepX(2)+textWidth(time), y+animation.animeHeight+gui.thisFont.gap(2), barWidth, barHeight, gui.unit(8));
    textAlign(LEFT, CENTER);
    fill(gui.bodyColor[0].value);
    text(time, x+playWidth+gui.thisFont.stepX(), y+animation.animeHeight+gui.thisFont.gap(2)+barHeight/2);
    strokeWeight(gui.unit());
    line(x+playWidth+gui.thisFont.stepX(2)+textWidth(time)+barWidth*animation.position(), y+animation.animeHeight+gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX(2)+textWidth(time)+barWidth*animation.position(), y+playerHeight);
  }
}
