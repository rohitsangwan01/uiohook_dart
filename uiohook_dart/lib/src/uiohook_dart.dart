import 'dart:async';

import 'package:uiohook_dart/src/isolate_handler/uiohook_listener_isolate.dart';
import 'package:uiohook_dart/src/models/hook_event.dart';
import 'package:uiohook_dart/src/models/event_type.dart';
import 'package:uiohook_dart/src/models/keyboard_event_data.dart';
import 'package:uiohook_dart/src/models/mouse_event_data.dart';
import 'package:uiohook_dart/src/models/screen_data.dart';
import 'package:uiohook_dart/src/models/wheel_event_data.dart';
import 'package:uiohook_dart/src/isolate_handler/uiohook_main_isolate.dart';

typedef HookInterceptor = bool Function(HookEvent);
typedef HookListener = Function(HookEvent);

class UioHookDart {
  static late String _binaryPath;
  static final UioHookMainIsolate _mainIsolate = UioHookMainIsolate();

  static Future<void> init(String binary) async {
    UioHookDart._binaryPath = binary;
    await _mainIsolate.init(binary);
  }

  static Future<void> dispose() => _mainIsolate.dispose();

  /// Start listener and get updates from `setEventListener` callback
  static Future<void> startListener({
    HookListener? onEvents,
    HookInterceptor? interceptor,
    Function(int)? onComplete,
  }) {
    return UiohookListenerIsolate.startListener(
      binaryPath: _binaryPath,
      hookListener: onEvents,
      interceptor: interceptor,
      onComplete: onComplete,
    );
  }

  /// Stop listener
  static Future<int> stopListener() async =>
      await _mainIsolate.call('hook_stop');

  /// Send Mouse data, to MoveMouse, ClickMouse buttons etc..
  static Future<void> sendMouseData(
    MouseEventData mouseEventData,
    EventType eventType,
  ) {
    return _mainIsolate.call("sendMouseData", {
      "event": mouseEventData,
      "eventType": eventType,
    });
  }

  /// Send Keyboard related data to press a key etc..
  static Future<void> sendKeyboardData(
    KeyboardEventData data,
    EventType eventType,
  ) {
    return _mainIsolate.call("sendKeyboardData", {
      "event": data,
      "eventType": eventType,
    });
  }

  /// Send MouseWheel related data to scroll
  static Future<void> sendMouseWheelData(
    MouseWheelData data,
    EventType eventType,
  ) {
    return _mainIsolate.call("sendMouseWheelData", {
      "event": data,
      "eventType": eventType,
    });
  }

  /// Retrieves monitors layout and size.
  static Future<List<ScreenData>> getScreenData() async =>
      await _mainIsolate.call('getScreenData');

  /// Retrieves the keyboard auto repeat rate.
  static Future<int> getKeyboardAutoRepeatRate() async =>
      await _mainIsolate.call('getKeyboardAutoRepeatRate');

  /// Retrieves the keyboard auto repeat delay
  static Future<int> getKeyboardAutoRepeatDelay() async =>
      await _mainIsolate.call('getKeyboardAutoRepeatDelay');

  /// Retrieves the mouse acceleration multiplier.
  static Future<int> getPointerAccelerationMultiplier() async =>
      await _mainIsolate.call('getPointerAccelerationMultiplier');

  /// Retrieves the mouse acceleration threshold.
  static Future<int> hookGetPointerAccelerationThreshold() async =>
      await _mainIsolate.call('hookGetPointerAccelerationThreshold');

  /// Retrieves the mouse sensitivity.
  static Future<int> getPointerSensitivity() async =>
      await _mainIsolate.call('getPointerSensitivity');

  /// Retrieves the double/triple click interval.
  static Future<int> getMultiClickTime() async =>
      await _mainIsolate.call('getMultiClickTime');
}
