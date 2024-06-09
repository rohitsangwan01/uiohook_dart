import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:uiohook_dart/src/generated/generated_bindings.dart';
import 'package:uiohook_dart/src/models/background_hook_arg.dart';

import 'package:ffi/ffi.dart';
import 'package:uiohook_dart/src/models/event_type.dart';
import 'package:uiohook_dart/src/models/keyboard_event_data.dart';
import 'package:uiohook_dart/src/models/mouse_event_data.dart';
import 'package:uiohook_dart/src/models/screen_data.dart';
import 'package:uiohook_dart/src/models/wheel_event_data.dart';

class UioHookMainIsolate {
  int _uniqueMethodId = 0;
  Isolate? _isolate;
  StreamSubscription? _receiverPortSubscription;
  ReceivePort? _receiverPort;
  SendPort? _sendPort;
  StreamController<Map>? _resultStreamController;

  Future<void> init(String binaryPath) async {
    _receiverPort = ReceivePort();
    _resultStreamController = StreamController.broadcast();
    Completer<SendPort> completer = Completer();
    _receiverPortSubscription = _receiverPort?.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      } else {
        _resultStreamController?.add(message);
      }
    });
    _isolate = await Isolate.spawn(
      _UioHookIsolateHandler.init,
      IsolateArgs(_receiverPort!.sendPort, null, binaryPath),
    );
    _sendPort = await completer.future;
  }

  Future call(String method, [dynamic data]) async {
    _uniqueMethodId++;
    _sendPort?.send({"id": _uniqueMethodId, "type": method, "data": data});
    var result = await _resultStreamController?.stream.firstWhere(
      (e) => e["id"] == _uniqueMethodId,
    );
    return result?['result'];
  }

  Future<void> dispose() async {
    _receiverPortSubscription?.cancel();
    _isolate?.kill();
    _receiverPort?.close();
    _resultStreamController?.close();
  }
}

class _UioHookIsolateHandler {
  static late SendPort _sendPort;
  static late NativeLibrary _nativeLib;
  static late DynamicLibrary _dynamicLibrary;

  static init(IsolateArgs arg) {
    _sendPort = arg.sendPort;
    _dynamicLibrary = DynamicLibrary.open(arg.dynamicLibPath);
    _nativeLib = NativeLibrary(_dynamicLibrary);
    final commandPort = ReceivePort();
    _sendPort.send(commandPort.sendPort);
    commandPort.listen((message) {
      int id = message['id'];
      dynamic result = handleMethodCall(message['type'], message['data']);
      _sendPort.send({'id': id, 'result': result});
    });
  }

  static dynamic handleMethodCall(String method, dynamic data) {
    switch (method) {
      case "hook_stop":
        return _nativeLib.hook_stop();
      case "getKeyboardAutoRepeatRate":
        return _nativeLib.hook_get_auto_repeat_rate();
      case "getKeyboardAutoRepeatDelay":
        return _nativeLib.hook_get_auto_repeat_delay();
      case "getPointerAccelerationMultiplier":
        return _nativeLib.hook_get_pointer_acceleration_multiplier();
      case "hookGetPointerAccelerationThreshold":
        return _nativeLib.hook_get_pointer_acceleration_threshold();
      case "getPointerSensitivity":
        return _nativeLib.hook_get_pointer_sensitivity();
      case "getMultiClickTime":
        return _nativeLib.hook_get_multi_click_time();
      case "sendMouseData":
        MouseEventData mouseEventData = data["event"];
        EventType eventType = data["eventType"];
        final event = mouseEventData.toNative(eventType);
        _nativeLib.hook_post_event(event);
        malloc.free(event);
        return null;
      case "sendKeyboardData":
        KeyboardEventData keyboardData = data["event"];
        EventType eventType = data["eventType"];
        final event = keyboardData.toNative(eventType);
        _nativeLib.hook_post_event(event);
        malloc.free(event);
        return null;
      case "sendMouseWheelData":
        MouseWheelData wheelData = data["event"];
        EventType eventType = data["eventType"];
        final event = wheelData.toNative(eventType);
        _nativeLib.hook_post_event(event);
        malloc.free(event);
        return null;
      case "getScreenData":
        Pointer<UnsignedChar> count = calloc<UnsignedChar>(1);
        Pointer<screen_data> monitors =
            _nativeLib.hook_create_screen_info(count);
        List<ScreenData> monitorsList = [];
        for (int i = 0; i < count.value; i++) {
          monitorsList.add(ScreenData.fromNativeScreenData(monitors[i]));
        }
        calloc.free(count);
        calloc.free(monitors);
        return monitorsList;
    }
  }
}
