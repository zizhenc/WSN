class Image {
  PImage picture;
  float imageWidth, imageHeight;
  Image(String imageFile) {
    picture=loadImage(imageFile);
  }
  void display(float x, float y) {
    display(GUI.SCALE, x, y, 1);
  }
  void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      imageWidth=gui.unit(picture.width)*factor;
      imageHeight=gui.unit(picture.height)*factor;
      break;
    case GUI.WIDTH:
      imageWidth=factor;
      imageHeight=picture.height*factor/picture.width;
      break;
    case GUI.HEIGHT:
      imageWidth=picture.width*factor/picture.height;
      imageHeight=factor;
    }
    image(picture, x, y, imageWidth, imageHeight);
  }
}
