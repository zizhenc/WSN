abstract class Animation {
  int animeWidth, animeHeight;
  String filename;
  abstract void display(int mode, float x, float y, float factor);
  void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
}
