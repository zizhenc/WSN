abstract class Star {
  float x, y, destination;
  float[] radius={gui.unit(random(5)), gui.unit(random(5, 10))};
  int points=round(random(3, 6));
  color colour;
  abstract void update();
  void display() {
    noStroke();
    fill(colour); 
    star(x, y, radius);
    update();
  }
  void star(float x, float y, float[] radius) {
    float angle = TWO_PI / points;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius[1];
      float sy = y + sin(a) * radius[1];
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius[0];
      sy = y + sin(a+halfAngle) * radius[0];
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
