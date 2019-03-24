class Branch extends Tree {
  Branch(Tree parent, float x, float y, float angleOffset, float tall) {
    super(x, y, tall);
    branch=new Tree[3];
    branch[2]=parent;//null
    angle=parent.angle+angleOffset;
    this.angleOffset = angleOffset;
    birth();
  }
  void display() {
    x=branch[2].x+sin(branch[2].angle)*gui.unit(branch[2].tall)*branch[2].growth;
    y=branch[2].y+cos(branch[2].angle)*gui.unit(branch[2].tall)*branch[2].growth;
    windForce=branch[2].windForce*(1.0+5.0/tall)+blastForce;
    blastForce=(blastForce+sin(x/2+windAngle)*0.01/tall)*0.98;
    angle=branch[2].angle+angleOffset+windForce+blastForce;
    if (growth<1)
      growth+=0.02*branch[2].growth;
    show();
  }
  void drawBranch() {
    for (int i=0; i!=2; i++)
      if (branch[i]!=null)
        drawBranch(branch[i]);
  }
  void drawBranch(Tree child) {
    float xB=x+gui.unit(x-branch[2].x)*0.4, yB=y+gui.unit(y-branch[2].y)*0.4;
    stroke(floor(2000/tall));
    strokeWeight(gui.unit(tall/5));
    noFill();
    bezier(x, y, xB, yB, xB, yB, child.x, child.y);
    child.display();
  }
}
