## Uiohook Dart

Cross-platform keyboard and mouse hooking library using [libuiohook](https://github.com/kwhat/libuiohook)

## Usage

### To use in pure dart projects

import uiohook_dart

### To use in flutter projects

import uiohook_dart with uiohook_flutter

uiohook_flutter just contains the prebuilt binaries of libuiohook, and gives libuioHookBinary which can be passed in

```dart
UiohookDart.init(libuioHookBinary);
```

### Apis

Make sure to init first, and dispose when done

### To Start listener

### To Stop listener

### To get ScreenInfo

### Some other apis
