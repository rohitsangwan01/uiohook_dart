## Uiohook

[![uiohook_dart version](https://img.shields.io/pub/v/uiohook_dart?label=uiohook_dart)](https://pub.dev/packages/uiohook_dart)
[![uiohook_flutter version](https://img.shields.io/pub/v/uiohook_flutter?label=uiohook_flutter)](https://pub.dev/packages/uiohook_flutter)

Cross-platform Desktop keyboard and mouse hooking library, [libuiohook](https://github.com/kwhat/libuiohook) based ffi implementation

## Getting Started

use [uiohook_dart](https://pub.dev/packages/uiohook_dart) for pure Dart projects, To use in Flutter projects add [uiohook_flutter](https://pub.dev/packages/uiohook_flutter) as well

uiohook_flutter just contains the prebuilt binaries of [libuiohook](https://github.com/kwhat/libuiohook), and provides `libuioHookBinary` variable which can be used to initialize UiohookDart

## Usage

### Setup

Initialize first with libuiohook binary, or use `uiohook_flutter` to auto include prebuilt binaries

```dart
// Get binary path either with `uiohook_flutter` or include your own binary
UioHookDart.init(libuioHookBinary);
```

Dispose when done

```dart
UioHookDart.dispose();
```

### Start listener

Start listening for mouse and keyboard events, and get result in `onComplete` callback, To get events, there are two callbacks

`interceptor` will get events from isolate directly, so this will not share memory with rest of the application, you have to return true to suppress the event otherwise return false

`onEvents` will also provide hookEvents, but this will provide on main thread, and can be used to perform your tasks based on the events

```dart
UioHookDart.startListener(
    interceptor: (HookEvent event) {
      // To suppress keyboard press events
      if (event.type == EventType.keyPressed) {
        return true;
      }
      // Pass rest of the events
      return false;
    },
    onEvents: (HookEvent event) {
      // Use Mouse,Keyboard events
    },
    onComplete: (int status) {
        print("StartListener: $status");
    },
);
```

### Stop listener

If listener is already started, then calling `stopListener` will
also trigger `onComplete` callback of `startListener` with result

```dart
UioHookDart.stopListener();
```

### Get ScreenInfo

Get details about screen as well as external connected monitors

```dart
UioHookDart.getScreenData();
```

### Simulate Mouse/Keyboard events

Construct `MouseEventData` with required fields, and `EventType`, and pass to `sendMouseData`

```dart
UioHookDart.sendMouseData(
    MouseEventData(x: 500, y: 500),
    EventType.mouseMoved,
);
```

Similarly we can send keyboard Data with `sendKeyboardData` and scroll with `sendMouseWheelData`

## Other Apis

Retrieves the keyboard auto repeat rate with `getKeyboardAutoRepeatRate`

Retrieves the keyboard auto repeat delay with `getKeyboardAutoRepeatDelay`

Retrieves the mouse acceleration multiplier with `getPointerAccelerationMultiplier`

Retrieves the mouse sensitivity with `getPointerSensitivity`

Retrieves the double/triple click interval with
`getMultiClickTime`

Retrieves the mouse acceleration threshold with `hookGetPointerAccelerationThreshold`

## Note

Thanks to kwhat for the [libuiohook](https://github.com/kwhat/libuiohook) project

See the examples for runnable examples of various usages
