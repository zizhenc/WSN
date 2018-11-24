class Image {
  PImage picture;
  Image(String imageFile) {
    picture=loadImage(imageFile);
  }
  void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
  void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      image(picture, x, y, gui.unit(picture.width)*factor, gui.unit(picture.height)*factor);
      break;
    case GUI.WIDTH:
      image(picture, x, y, factor, picture.height*factor/picture.width);
      break;
    case GUI.HEIGHT:
      image(picture, x, y, picture.width*factor/picture.height, factor);
    }
  }
}
