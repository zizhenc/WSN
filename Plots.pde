abstract class Plots extends Charts {
  Switcher showNode=new Switcher("Node", "Node"), showEdge=new Switcher("Edge", "Edge");
  Slider nodeWeight=new Slider("Node weight");
  abstract void moreSettings();
  Plots() {
    switches.addLast(showNode);
    switches.addLast(showEdge);
    tunes.addFirst(nodeWeight);
  }
  void setting() {
    nodeWeight.setPreference(gui.unit(6), gui.unit(), gui.unit(12), gui.unit(0.05));
    edgeWeight.setPreference(gui.unit(2), gui.unit(0.1), gui.unit(4), gui.unit(0.005));
    moreSettings();
  }
  void moreKeyReleases() {
    switch(Character.toLowerCase(key)) {
    case 'n':
      showNode.commit();
      break;
    case 'e':
      showEdge.commit();
    }
  }
}
