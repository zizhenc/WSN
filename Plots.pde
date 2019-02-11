/*
abstract class Plots extends Charts {
 Switcher showNode=new Switcher("Node", "Node"), showEdge=new Switcher("Edge", "Edge");
 Slider nodeWeight=new Slider("Node weight", false), edgeWeight=new Slider("Edge weight", false);
 Plot plot;
 Plots() {
 switches.addLast(showNode);
 switches.addLast(showEdge);
 tunes.addLast(nodeWeight);
 tunes.addLast(edgeWeight);
 }
 void setting() {
 initialize();
 edgeWeight.setPreference(gui.mutaFactor/2, gui.mutaFactor/20, gui.mutaFactor, gui.mutaFactor/10);
 moreSettings();
 }
 abstract void moreSettings();
 abstract void moreShows();
 void show() {
 plot.initialize(gui.text.stepX(1), gui.text.stepX(1), gui.text.side(), height);
 plot.frame();
 moreShows();
 if (showMeasurement.value)
 plot.measure();
 }
 void moreKeyReleases() {
 switch(Character.toLowerCase(key)) {
 case 'n':
 showNode.value=!showNode.value;
 break;
 case 'e':
 showEdge.value=!showEdge.value;
 }
 }
 }*/
