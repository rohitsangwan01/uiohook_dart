import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:uiohook_dart/src/generated/generated_bindings.dart';
import 'package:uiohook_dart/src/models/event_type.dart';

class MouseWheelData {
  int? x;
  int? y;
  int? type;
  int? rotation;
  int? delta;
  int? direction;

  MouseWheelData({
    this.x,
    this.y,
    this.type,
    this.rotation,
    this.delta,
    this.direction,
  });

  static List<EventType> validEventType = [
    EventType.mouseWheel,
  ];

  static MouseWheelData? fromUioHookEvent(uiohook_event event) {
    return MouseWheelData(
      x: event.data.wheel.x,
      y: event.data.wheel.y,
      type: event.data.wheel.type,
      rotation: event.data.wheel.rotation,
      delta: event.data.wheel.delta,
      direction: event.data.wheel.direction,
    );
  }

  Pointer<uiohook_event> toNative(EventType eventType) {
    final event = malloc<uiohook_event>(sizeOf<uiohook_event>());
    event.ref.type = eventType.value;
    if (x != null) event.ref.data.wheel.x = x!;
    if (y != null) event.ref.data.wheel.y = y!;
    if (type != null) event.ref.data.wheel.type = type!;
    if (rotation != null) event.ref.data.wheel.rotation = rotation!;
    if (delta != null) event.ref.data.wheel.delta = delta!;
    if (direction != null) event.ref.data.wheel.direction = direction!;
    return event;
  }

  @override
  String toString() {
    return 'MouseWheelData{x: $x, y: $y, type: $type, rotation: $rotation, delta: $delta, direction: $direction}';
  }
}
