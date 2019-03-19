class VideoPlayer extends AnimationPlayer {
  float volume=0.7;
  VideoPlayer(WSN wsn, String path) {
    animation=new Video(wsn, path);
  }
  void show(String time) {
    playWidth=(playerWidth-textWidth(time)-gui.thisFont.stepX(3))/13;
    playHeight=playWidth*9/16;
    float volumeWidth=playWidth*2, barWidth=playerWidth-playWidth-volumeWidth-gui.thisFont.stepX(3)-textWidth(time), barHeight=playHeight-gui.thisFont.gap(2);
    playerHeight=animation.animeHeight+gui.thisFont.gap()+playHeight;
    strokeWeight(gui.unit(2));
    noStroke();
    fill(gui.baseColor.value);
    triangle(x+playWidth+gui.thisFont.stepX(), y+playerHeight-gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX()+volumeWidth*volume, y+playerHeight-gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX()+volumeWidth*volume, y+playerHeight-gui.thisFont.gap()-barHeight*volume);
    rect(x+playWidth+volumeWidth+gui.thisFont.stepX(3)+textWidth(time), y+animation.animeHeight+gui.thisFont.gap(2), barWidth*animation.position(), barHeight, gui.unit(8));
    noFill();
    stroke(gui.frameColor.value);
    triangle(x+playWidth+gui.thisFont.stepX(), y+playerHeight-gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX()+volumeWidth, y+playerHeight-gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX()+volumeWidth, y+animation.animeHeight+gui.thisFont.gap(2));
    rect(x+playWidth+volumeWidth+gui.thisFont.stepX(3)+textWidth(time), y+animation.animeHeight+gui.thisFont.gap(2), barWidth, barHeight, gui.unit(8));
    textAlign(LEFT, CENTER);
    fill(gui.bodyColor[0].value);
    text(time, x+playWidth+volumeWidth+gui.thisFont.stepX(2), y+animation.animeHeight+gui.thisFont.gap(2)+barHeight/2);
    strokeWeight(gui.unit());
    line(x+playWidth+gui.thisFont.stepX()+volumeWidth*volume, y+animation.animeHeight+gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX()+volumeWidth*volume, y+playerHeight);
    line(x+playWidth+gui.thisFont.stepX(3)+volumeWidth+textWidth(time)+barWidth*animation.position(), y+animation.animeHeight+gui.thisFont.gap(), x+playWidth+gui.thisFont.stepX(3)+volumeWidth+textWidth(time)+barWidth*animation.position(), y+playerHeight);
  }
}
