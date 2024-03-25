import 'package:flutter/cupertino.dart';

class ThemeColor {
  static const Color pinkColor = Color(0xFFF92457);
  static const Color whiteColor = Color(0xFFFFFFFF);
}

class ColorPaletteProvider extends InheritedWidget {
  final ThemeColor themeColor;

  const ColorPaletteProvider({
    Key? key,
    required Widget child,
    required this.themeColor,
  }) : super(key: key, child: child);

  static ColorPaletteProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColorPaletteProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}