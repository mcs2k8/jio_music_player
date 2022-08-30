

import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ColorState>{
   ThemeNotifier() : super(_initialValue);
   static ColorState _initialValue = ColorState();
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
  {this.dominantColor = const Color.fromARGB(255, 171,94,84),
      this.mutedColor = const Color.fromARGB(255, 217, 147, 141),
      this.vibrantColor = const Color.fromARGB(255, 253, 189, 144),
      this.lightMutedColor = const Color.fromARGB(255, 240, 212, 209),
      this.lightVibrantColor = const Color.fromARGB(255, 254, 231, 215),
      this.darkMutedColor = const Color.fromARGB(255, 131, 75, 61),
      this.darkVibrantColor = const Color.fromARGB(255, 154, 96, 116)});
}

//Palette at https://coolors.co/fee7d7-f0d4d1-834b3d-b9737a-9a6074