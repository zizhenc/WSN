class Particle extends Star {
  float angle, distance;
  Particle(float x, float y, float angle, color colour) {
    this.x=x;
    this.y=y;
    this.colour=colour;
    this.angle=angle;
    destination=gui.unit(random(15));
  }
  void update() {
    if (distance<destination) {
      x+=cos(angle)*distance;
      y+=sin(angle)*distance;
      distance+=0.1;
    }
  }
}
