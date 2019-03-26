class Firework {
  LinkedList<Particle> particles=new LinkedList<Particle>();
  float x, y;
  color colour;
  Firework(float x, float y, color colour) {
    this.x=x;
    this.y=y;
    this.colour=colour;
    for (float angle = PI; angle < TWO_PI; angle += PI/7)
      particles.addLast(new Particle(x, y, angle, colour));
  }
  void display() {
    for (Particle particle : particles)
      particle.display();
  }
}
