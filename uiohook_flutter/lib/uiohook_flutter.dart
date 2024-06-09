import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';

String get libuioHookBinary {
  String basePath = '';
  if (defaultTargetPlatform == TargetPlatform.linux) {
    basePath = '${File(Platform.resolvedExecutable).parent.path}/lib';
  }
  switch (Abi.current()) {
    case Abi.linuxX64:
      return "$basePath/libuiohook_x86_64.so";
    case Abi.linuxArm:
      return "$basePath/libuiohook_x86.so";
    case Abi.linuxArm64:
      return "$basePath/libuiohook_arm64.so";
    case Abi.macosArm64:
      return "libuiohook.1.dylib";
    default:
      throw "Binary not available for this platform";
  }
}
