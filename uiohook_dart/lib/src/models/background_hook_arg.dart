import 'dart:isolate';

import 'package:uiohook_dart/uiohook_dart.dart';

class IsolateArgs {
  SendPort sendPort;
  HookInterceptor? interceptor;
  String dynamicLibPath;
  IsolateArgs(this.sendPort, this.interceptor, this.dynamicLibPath);
}
