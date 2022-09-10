import 'package:flutter/material.dart';

class ThemeManager {
  late final ThemeNotifier themeNotifier;
  static final instance = ThemeManager._();
  ColorState currentTheme = colorThemes['Sunset']!;
  String currentThemeName = 'Sunset';

  ThemeManager._() {
    themeNotifier = ThemeNotifier();
  }

  static var colorThemes = {
    'Sunset': ColorState(
        dominantColor: const Color.fromARGB(255, 206, 114, 103),
        mutedColor: const Color.fromARGB(255, 217, 147, 141),
        vibrantColor: const Color.fromARGB(255, 184, 129, 90),
        lightMutedColor: const Color.fromARGB(255, 240, 212, 209),
        lightVibrantColor: const Color.fromARGB(255, 254, 231, 215),
        darkMutedColor: const Color.fromARGB(255, 131, 75, 61),
        darkVibrantColor: const Color.fromARGB(255, 154, 96, 116)),
    'Azure Coral': ColorState(
        dominantColor: const Color.fromARGB(255, 245, 203, 92),
        mutedColor: const Color.fromARGB(255, 87, 115, 153),
        vibrantColor: const Color.fromARGB(255, 183, 79, 111),
        lightMutedColor: const Color.fromARGB(255, 220, 227, 238),
        lightVibrantColor: const Color.fromARGB(255, 227, 135, 163),
        darkMutedColor: const Color.fromARGB(255, 35, 50, 64),
        darkVibrantColor: const Color.fromARGB(255, 69, 15, 35)),
    'Deep Sea': ColorState(
        dominantColor: const Color(4289583329),
        mutedColor: const Color(4286011781),
        vibrantColor: const Color(4286826455),
        lightMutedColor: const Color(4289385648),
        lightVibrantColor: const Color(4289583329),
        darkMutedColor: const Color(4280621098),
        darkVibrantColor: const Color(4281423999)),
  };

}

class ThemeNotifier extends ValueNotifier<ColorState> {
  ThemeNotifier() : super(_initialValue);
  static final ColorState _initialValue = ThemeManager.colorThemes['Sunset']!;
}

class ColorState {
  Color dominantColor;
  Color mutedColor;
  Color vibrantColor;
  Color lightMutedColor;
  Color lightVibrantColor;
  Color darkMutedColor;
  Color darkVibrantColor;

  ColorState(
      {this.dominantColor = const Color.fromARGB(255, 171, 94, 84),
      this.mutedColor = const Color.fromARGB(255, 217, 147, 141),
      this.vibrantColor = const Color.fromARGB(255, 253, 189, 144),
      this.lightMutedColor = const Color.fromARGB(255, 240, 212, 209),
      this.lightVibrantColor = const Color.fromARGB(255, 254, 231, 215),
      this.darkMutedColor = const Color.fromARGB(255, 131, 75, 61),
      this.darkVibrantColor = const Color.fromARGB(255, 154, 96, 116)});
}



//Sunset Palette at https://coolors.co/fee7d7-f0d4d1-834b3d-b9737a-9a6074
//Azure Coral Palette at https://coolors.co/495867-577399-bdd5ea-dc493a-f5cb5c
