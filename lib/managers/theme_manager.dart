import 'package:flutter/material.dart';

class ThemeManager {
  late final ThemeNotifier themeNotifier;
  static final instance = ThemeManager._();
  ColorState currentTheme = colorThemes['Eiffel 65']!;
  String currentThemeName = 'Eiffel 65';

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
        darkVibrantColor: const Color.fromARGB(255, 154, 96, 116),
    ),
    'Azure Coral': ColorState(
        dominantColor: const Color.fromARGB(255, 245, 203, 92),
        mutedColor: const Color.fromARGB(255, 87, 115, 153),
        vibrantColor: const Color.fromARGB(255, 183, 79, 111),
        lightMutedColor: const Color.fromARGB(255, 220, 227, 238),
        lightVibrantColor: const Color.fromARGB(255, 227, 135, 163),
        darkMutedColor: const Color.fromARGB(255, 35, 50, 64),
        darkVibrantColor: const Color.fromARGB(255, 69, 15, 35),
    ),
    'Deep Sea': ColorState(
        dominantColor: const Color(0xffadd8e1),
        mutedColor: const Color(0xff775985),
        vibrantColor: const Color(0xff83c7d7),
        lightMutedColor: const Color(0xffaad4b0),
        lightVibrantColor: const Color(0xffadd8e1),
        darkMutedColor: const Color(0xff25182a),
        darkVibrantColor: const Color(0xff31587f),
    ),
    'Wine Tones': ColorState(
        dominantColor: const Color(0xffe0f8f8),
        mutedColor: const Color(0xff846063),
        vibrantColor: const Color(0xffe3f6f6),
        lightMutedColor: const Color(0xffc0a1a2),
        lightVibrantColor: const Color(0xffe0f8f8),
        darkMutedColor: const Color(0xff502937),
        darkVibrantColor: const Color(0xffccdddd),
    ),
    'The Blues': ColorState(
        dominantColor: const Color(0xffbacdcc),
        mutedColor: const Color(0xff8fafa8),
        vibrantColor: const Color(0xffa6e1de),
        lightMutedColor: const Color(0xffbacdcc),
        lightVibrantColor: const Color(0xffc7d7d4),
        darkMutedColor: const Color(0xff3d565e),
        darkVibrantColor: const Color(0xff102733),
    ),
    'Rainy Sky': ColorState(
        dominantColor: const Color(0xfff1efe6),
        mutedColor: const Color(0xff5d7d89),
        vibrantColor: const Color(0xff325b70),
        lightMutedColor: const Color(0xfff1efe6),
        lightVibrantColor: const Color(0xffaebec4),
        darkMutedColor: const Color(0xff456777),
        darkVibrantColor: const Color(0xff294a5a),
    ),
    'Eiffel 65': ColorState(
        dominantColor: const Color(0xff697ca3),
        mutedColor: const Color(0xff878f9c),
        vibrantColor: const Color(0xff5b84c8),
        lightMutedColor: const Color(0xffcbd0ce),
        lightVibrantColor: const Color(0xffe6dcc7),
        darkMutedColor: const Color(0xff44566e),
        darkVibrantColor: const Color(0xff081931),
    ),
    'China Red': ColorState(
        dominantColor: const Color(0xffe9eae6),
        mutedColor: const Color(0xffaa4d4b),
        vibrantColor: const Color(0xffee3f33),
        lightMutedColor: const Color(0xffe9eae6),
        lightVibrantColor: const Color(0xfff49b81),
        darkMutedColor: const Color(0xff994544),
        darkVibrantColor: const Color(0xff921a10),
    ),
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
      this.darkVibrantColor = const Color.fromARGB(255, 154, 96, 116),
      });
}



//Sunset Palette at https://coolors.co/fee7d7-f0d4d1-834b3d-b9737a-9a6074
//Azure Coral Palette at https://coolors.co/495867-577399-bdd5ea-dc493a-f5cb5c
