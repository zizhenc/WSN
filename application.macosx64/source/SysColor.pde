class SysColor {
  int r, g, b;
  color value;
  SysColor() {
    setValue(0);
  }
  SysColor(int v) {
    setValue(v);
  }
  SysColor(int r, int g, int b) {
    setValue(r, g, b);
  }
  void setValue(int v) {
    r=v/65536%256;
    g=v/256%256;
    b=v%256;
    setValue(r, g, b);
  }
  void setValue(int r, int g, int b) {
    this.r=r;
    this.g=g;
    this.b=b;
    value=color(r, g, b);
  }
}
