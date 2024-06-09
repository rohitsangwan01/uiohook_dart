enum EventType {
  hookEnabled(1),
  hookDisabled(2),
  keyTyped(3),
  keyPressed(4),
  keyReleased(5),
  mouseClicked(6),
  mousePressed(7),
  mouseReleased(8),
  mouseMoved(9),
  mouseDragged(10),
  mouseWheel(11);

  const EventType(this.value);
  final int value;

  factory EventType.fromValue(int value) {
    return EventType.values.firstWhere((e) => e.value == value);
  }
}
