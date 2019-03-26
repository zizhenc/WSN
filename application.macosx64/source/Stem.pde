class Stem extends Tree {
  Stem(float x, float y, float angleOffset, float tall) {
    super(x, y, tall);
    angle=angleOffset;//PI
    this.angleOffset = random(-PI/12, PI/12);
    branch=new Branch[2];
    birth();
  }
  void display() {
    pushStyle();
    windForce=sin(windAngle+=0.05)*0.02;
    if (growth<1)
      growth+=0.02;
    show();
    popStyle();
  }
  void drawBranch() {
    float xB=x+sin(angle+angleOffset)*gui.unit(tall)*0.3, yB=y+cos(angle+angleOffset)*gui.unit(tall)*0.3;
    stroke(floor(2000/tall));
    strokeWeight(gui.unit(tall/5));
    noFill();
    Tree b=branch[0]==null?branch[1]:branch[0];
    bezier(x, y, xB, yB, xB, yB, b.x, b.y);
    for (int i=0; i!=2; i++)
      if (branch[i]!=null)
        branch[i].display();
  }
}
