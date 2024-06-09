// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:uiohook_dart/uiohook_dart.dart';
import 'package:uiohook_flutter/uiohook_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // To suppress Events, return True
  HookInterceptor interceptor = (HookEvent event) {
    if (event.type == EventType.keyPressed) {
      return true;
    }
    return false;
  };

  HookListener handleEvents = (HookEvent event) {
    print(event.toString());
    // Stop Listener on Escape Press
    if (event.keyboardEventData?.keycode == HookConstants.VC_ESCAPE) {
      UioHookDart.stopListener();
    }
    // Send Mouse to this position on Click
    if (event.type == EventType.mouseClicked) {
      //  _uiohookDartPlugin.sendMouseData(MouseEventData(x: 500, y: 500), EventType.mouseMoved);
    }
  };

  @override
  void initState() {
    UioHookDart.init(libuioHookBinary);
    super.initState();
  }

  @override
  void dispose() {
    UioHookDart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uiohook'),
          elevation: 4,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await UioHookDart.startListener(
                        interceptor: interceptor,
                        onEvents: handleEvents,
                        onComplete: (int status) {
                          print("StartListener: $status");
                        },
                      );
                    },
                    child: const Text("Start"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await UioHookDart.stopListener();
                      print("StopListener $result");
                    },
                    child: const Text("Stop"),
                  ),
                ],
              ),
              const Divider(),
              const Text("Properties"),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print(await UioHookDart.getScreenData());
                    },
                    child: const Text("Screen Data"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        await UioHookDart.getKeyboardAutoRepeatRate(),
                      );
                    },
                    child: const Text("Keyboard Repeat Rate"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        await UioHookDart.getKeyboardAutoRepeatDelay(),
                      );
                    },
                    child: const Text("Keyboard Repeat delay"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        await UioHookDart.getPointerAccelerationMultiplier(),
                      );
                    },
                    child: const Text("Mouse threshold"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        await UioHookDart.getPointerSensitivity(),
                      );
                    },
                    child: const Text("Mouse sensitivity"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        await UioHookDart.getMultiClickTime(),
                      );
                    },
                    child: const Text("Click interval"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
