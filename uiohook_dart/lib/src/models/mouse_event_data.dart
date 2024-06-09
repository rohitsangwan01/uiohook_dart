import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:uiohook_dart/src/generated/generated_bindings.dart';
import 'package:uiohook_dart/src/models/event_type.dart';

class MouseEventData {
  int? button;
  int? clicks;
  int? x;
  int? y;

  MouseEventData({
    this.button,
    this.clicks,
    this.x,
    this.y,
  });

  static List<EventType> validEventType = [
    EventType.mouseClicked,
    EventType.mousePressed,
    EventType.mouseReleased,
    EventType.mouseMoved,
    EventType.mouseDragged
  ];

  static MouseEventData? fromUioHookEvent(uiohook_event event) {
    return MouseEventData(
      button: event.data.mouse.button,
      clicks: event.data.mouse.clicks,
      x: event.data.mouse.x,
      y: event.data.mouse.y,
    );
  }

  Pointer<uiohook_event> toNative(EventType eventType) {
    final event = malloc<uiohook_event>(sizeOf<uiohook_event>());
    event.ref.type = eventType.value;
    if (x != null) event.ref.data.mouse.x = x!;
    if (y != null) event.ref.data.mouse.y = y!;
    if (button != null) event.ref.data.mouse.button = button!;
    if (clicks != null) event.ref.data.mouse.clicks = clicks!;
    return event;
  }

  @override
  String toString() {
    return 'MouseEventData{button: $button, clicks: $clicks, x: $x, y: $y}';
  }
}
