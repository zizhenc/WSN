abstract class Tree {
  float x, y, angle, angleOffset, tall, windForce, windAngle, blastForce, growth;
  Tree[] branch;
  abstract void display();
  abstract void drawBranch();
  Tree(float x, float y, float tall) {
    this.x = x;//width/2
    this.y = y;//height
    this.tall = tall;
  }
  void birth() {
    float xB=x+sin(angle)*tall, yB=y+cos(angle)*tall;
    if (tall>10) {
      if (tall+random(tall)>40)
        branch[0]=new Branch(this, xB, yB, random(-0.5, -0.1)+((angle%TWO_PI)>PI?-1/tall:1/tall), tall*random(0.6, 0.9));
      if (tall+random(tall) > 40)
        branch[1]=new Branch(this, xB, yB, random(0.1, 0.5)+((angle%TWO_PI)>PI?-1/tall:1/tall), tall*random(0.6, 0.9));
    }
  }
  void show() {
    if (branch[0]==null&&branch[1]==null) {
      pushMatrix();
      translate(x, y);
      rotate(-angle);
      stroke(#5d6800);
      strokeWeight(gui.unit(2));
      line(0, 0, 0, gui.unit(24));
      noStroke();
      fill(#749600);
      bezier(0, gui.unit(12), gui.unit(-12), gui.unit(24), gui.unit(-12), gui.unit(24), 0, gui.unit(36));
      bezier(0, gui.unit(36), gui.unit(12), gui.unit(24), gui.unit(12), gui.unit(24), 0, gui.unit(12));
      fill(#8bb800);
      bezier(0, gui.unit(18), 0, gui.unit(26), 0, gui.unit(26), 0, gui.unit(36));
      bezier(0, gui.unit(36), gui.unit(12), gui.unit(26), gui.unit(12), gui.unit(26), 0, gui.unit(18));
      stroke(#659000);
      noFill();
      bezier(0, gui.unit(18), gui.unit(-2), gui.unit(22), gui.unit(-2), gui.unit(24), 0, gui.unit(30));
      popMatrix();
    } else
      drawBranch();
  }
}
