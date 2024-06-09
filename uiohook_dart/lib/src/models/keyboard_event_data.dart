import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:uiohook_dart/src/generated/generated_bindings.dart';
import 'package:uiohook_dart/src/models/event_type.dart';

class KeyboardEventData {
  int? keycode;
  int? rawCode;
  int? keyChar;

  KeyboardEventData({
    this.keycode,
    this.rawCode,
    this.keyChar,
  });

  static List<EventType> validEventType = [
    EventType.keyTyped,
    EventType.keyPressed,
    EventType.keyReleased
  ];

  factory KeyboardEventData.fromUioHookEvent(uiohook_event event) {
    return KeyboardEventData(
      keycode: event.data.keyboard.keycode,
      rawCode: event.data.keyboard.rawcode,
      keyChar: event.data.keyboard.keychar,
    );
  }

  Pointer<uiohook_event> toNative(EventType eventType) {
    final event = malloc<uiohook_event>(sizeOf<uiohook_event>());
    event.ref.type = eventType.value;
    if (keycode != null) event.ref.data.keyboard.keycode = keycode!;
    if (rawCode != null) event.ref.data.keyboard.rawcode = rawCode!;
    if (keyChar != null) event.ref.data.keyboard.keychar = keyChar!;
    return event;
  }

  @override
  String toString() {
    return 'KeyboardEventData{keycode: $keycode, rawcode: $rawCode, keychar: $keyChar}';
  }
}
