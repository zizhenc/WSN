class Rocket extends Star {
  Firework firework;
  boolean explode=true;
  Rocket() {
    x=mouseX;
    y=height;
    destination=mouseY;
    colour=color(random(120, 255), random(120, 255), random(120, 255));
  }
  void update() {
    if (firework!=null)
      firework.display();
    if (explode&&y<destination) {
      firework=new Firework(x, y, colour);
      explode=false;
    } else
      y-=3;
  }
}
