import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:uiohook_dart/src/models/background_hook_arg.dart';
import 'package:uiohook_dart/uiohook_dart.dart';

class UiohookListenerIsolate {
  /// Start listener in new isolate, because hook_run method blocks whole thread
  /// and communicate with isolate ports only, because rest of the methods will not share memory with this method
  static Future<void> startListener({
    HookInterceptor? interceptor,
    HookListener? hookListener,
    Function(int)? onComplete,
    required String binaryPath,
  }) async {
    ReceivePort port = ReceivePort();
    StreamSubscription? subscription;
    Isolate? isolate;

    // Handle final result
    void onResult(int result) {
      onComplete?.call(result);
      port.close();
      subscription?.cancel();
      isolate?.kill();
    }

    // Handle responses from isolate
    subscription = port.listen((message) {
      if (message is HookEvent) {
        hookListener?.call(message);
      } else if (message is int) {
        onResult(message);
      } else if (message is SendPort) {
        message.send('start');
      }
    });

    // Spawn a new isolate
    isolate = await Isolate.spawn(
      UiohookListenerIsolate._init,
      IsolateArgs(port.sendPort, interceptor, binaryPath),
    );
  }

  /// These variables are initialized from init method which runs in Isolate
  static late SendPort _sendPort;
  static HookInterceptor? _interceptor;
  static late NativeLibrary _nativeLibrary;
  static late DynamicLibrary _dynamicLibrary;

  static _init(IsolateArgs arg) {
    _sendPort = arg.sendPort;
    _interceptor = arg.interceptor;
    _dynamicLibrary = DynamicLibrary.open(arg.dynamicLibPath);
    _nativeLibrary = NativeLibrary(_dynamicLibrary);

    final commandPort = ReceivePort();
    _sendPort.send(commandPort.sendPort);

    // Listen from Messages
    commandPort.listen((message) {
      if (message is String) {
        switch (message) {
          case 'start':
            _start();
        }
      }
    });
  }

  static void _start() {
    _nativeLibrary.hook_set_dispatch_proc(
      Pointer.fromFunction<dispatcher_tFunction>(_dispatchProc),
      nullptr,
    );
    int status = _nativeLibrary.hook_run();
    _sendPort.send(status);
    _nativeLibrary.hook_set_dispatch_proc(nullptr, nullptr);
    _dynamicLibrary.close();
    Isolate.exit();
  }

  static void _dispatchProc(
    Pointer<uiohook_event> event,
    Pointer<Void> _,
  ) async {
    HookEvent hookEvent = HookEvent.fromUioHookEvent(event);
    _sendPort.send(hookEvent);
    if (_interceptor?.call(hookEvent) ?? false) {
      event.ref.mask = MASK_CONSUMED;
    }
  }
}
