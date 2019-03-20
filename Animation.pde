abstract class Animation {
  float animeWidth, animeHeight;
  boolean isPlaying;
  abstract void play();
  abstract void pause();
  abstract void repeat();
  abstract void end();
  abstract void jump(float percent);
  abstract void display(int mode, float x, float y, float factor);
  abstract int hours();
  abstract int minutes();
  abstract int seconds();
  abstract float position();
  void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
}
