import 'package:uiohook_dart/src/generated/generated_bindings.dart';

class ScreenData {
  int number;
  int x;
  int y;
  int width;
  int height;

  ScreenData(this.number, this.x, this.y, this.width, this.height);

  factory ScreenData.fromNativeScreenData(screen_data data) =>
      ScreenData(data.number, data.x, data.y, data.width, data.height);

  @override
  String toString() {
    return 'ScreenData{number: $number, x: $x, y: $y, width: $width, height: $height}';
  }
}
