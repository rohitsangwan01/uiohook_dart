import 'dart:ffi';

import 'package:uiohook_dart/src/generated/generated_bindings.dart';
import 'package:uiohook_dart/src/models/event_type.dart';
import 'package:uiohook_dart/src/models/keyboard_event_data.dart';
import 'package:uiohook_dart/src/models/mouse_event_data.dart';
import 'package:uiohook_dart/src/models/wheel_event_data.dart';

class HookEvent {
  int? time;
  int? mask;
  EventType type;
  KeyboardEventData? keyboardEventData;
  MouseEventData? mouseEventData;
  MouseWheelData? mouseWheelData;

  HookEvent({
    required this.type,
    this.time,
    this.mask,
    this.keyboardEventData,
    this.mouseEventData,
    this.mouseWheelData,
  });

  static HookEvent fromUioHookEvent(Pointer<uiohook_event> eventPointer) {
    EventType type = EventType.fromValue(eventPointer.ref.type);
    return HookEvent(
      type: type,
      time: eventPointer.ref.time,
      mask: eventPointer.ref.mask,
      keyboardEventData: KeyboardEventData.validEventType.contains(type)
          ? KeyboardEventData.fromUioHookEvent(eventPointer.ref)
          : null,
      mouseEventData: MouseEventData.validEventType.contains(type)
          ? MouseEventData.fromUioHookEvent(eventPointer.ref)
          : null,
      mouseWheelData: MouseWheelData.validEventType.contains(type)
          ? MouseWheelData.fromUioHookEvent(eventPointer.ref)
          : null,
    );
  }

  @override
  String toString() {
    return 'HookEvent{type: $type, time: $time, mask: $mask, keyboardEventData: $keyboardEventData, mouseEventData: $mouseEventData, mouseWheelData: $mouseWheelData}';
  }
}
