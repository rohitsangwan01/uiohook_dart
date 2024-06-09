import 'package:uiohook_dart/uiohook_dart.dart';

void main(List<String> arguments) async {
  await UioHookDart.init('binaries/mac_libuiohook_arm64.dylib');

  print(await UioHookDart.getScreenData());

  void handleEvents(HookEvent event) {
    print(event);
    if (event.type == EventType.mouseClicked) {
      // Move mouse
      UioHookDart.sendMouseData(
        MouseEventData(x: 500, y: 500),
        EventType.mouseMoved,
      );
    }
  }

  bool hookInterceptor(HookEvent event) {
    if (event.type == EventType.keyPressed) {
      return true;
    }
    return false;
  }

  await UioHookDart.startListener(
    onEvents: handleEvents,
    interceptor: hookInterceptor,
    onComplete: (int status) {
      print("StartListener: $status");
    },
  );

  await Future.delayed(const Duration(seconds: 10));

  int status = await UioHookDart.stopListener();
  print("StopStatus: $status");

  UioHookDart.dispose();
}
