import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/settings_screen/scan_songs_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'dart:io';
import '../managers/player_manager.dart';
import '../models/player_settings.dart';

final GlobalKey genKey = GlobalKey();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    ColorState currentTheme = ThemeManager.instance.themeNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SettingsList(
          lightTheme: SettingsThemeData(
              settingsListBackground: currentTheme.darkMutedColor,
              settingsSectionBackground:
                  darken(currentTheme.darkMutedColor, 20),
              settingsTileTextColor: currentTheme.lightMutedColor,
              titleTextColor: currentTheme.lightMutedColor,
              tileHighlightColor: currentTheme.lightVibrantColor,
              dividerColor: currentTheme.mutedColor,
              tileDescriptionTextColor: currentTheme.dominantColor),
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
                title: Text(
                  'Visual',
                  style: TextStyle(fontSize: 18),
                ),
                tiles: [
                  SettingsTile.navigation(
                    title: Text("Current Theme"),
                    leading: PlayerModel(),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: (context) {
                      List<Widget> options = [];
                      for (MapEntry<String, ColorState> theme
                          in ThemeManager.colorThemes.entries) {
                        ColorState color = theme.value;
                        Widget item = Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () async {
                              ThemeManager.instance.currentTheme = theme.value;
                              ThemeManager.instance.currentThemeName =
                                  theme.key;
                              ThemeManager.instance.themeNotifier.value =
                                  theme.value;
                              await PlayerManager.instance.updateColors(null);
                              //set image
                              await drawThemePicture();

                              setState(() {});
                              PlayerManager.instance.savePlayerSettings();
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              color: color.darkMutedColor,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.lightMutedColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.lightVibrantColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.mutedColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.vibrantColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.dominantColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.darkMutedColor,
                                      ),
                                      Container(
                                        width: 15,
                                        height: 20,
                                        color: color.darkVibrantColor,
                                      ),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Expanded(
                                          child: Text(
                                        theme.key,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: color.lightMutedColor),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        options.add(item);
                      }
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              backgroundColor: ThemeManager
                                  .instance.themeNotifier.value.darkMutedColor,
                              children: options,
                              title: Text("Choose a Theme"),
                            );
                          });
                    },
                  ),
                  SettingsTile.switchTile(
                    activeSwitchColor: ThemeManager
                        .instance.themeNotifier.value.lightVibrantColor,
                    initialValue: PlayerManager
                        .instance.updatePlayerColorAutomaticallyNotifier.value,
                    onToggle: (bool value) {
                      PlayerManager.instance
                          .updatePlayerColorAutomaticallyNotifier.value = value;
                      PlayerManager.instance.savePlayerSettings();
                      setState(() {
                        //print("setstate called");
                      });
                    },
                    title: Text("Update Player colors automatically"),
                    description: Text(
                        "When playing songs, colors will update based on the artwork of the current song"),
                  ),
                  SettingsTile.navigation(
                    title: Text("Generate Random Theme!"),
                    leading: Icon(
                      CupertinoIcons.smiley_fill,
                      color: Colors.yellow,
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                    description: Text("Click me, don't be shy!"),
                    onPressed: (context) {
                      generateRandomPalette();
                    },
                  ),
                  SettingsTile(
                    title: Text("Player Visualisation"),
                    leading: Image.asset(
                      PlayerManager.instance.visualisationTypeNotifier.value ==
                              VisualisationType.casette
                          ? "assets/casette-preview.png"
                          : "assets/vinyl-preview.png",
                      height: 100,
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                    description: PlayerManager
                                .instance.visualisationTypeNotifier.value ==
                            VisualisationType.casette
                        ? Text("Vintage Casette")
                        : Text("Vinyl Record"),
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              backgroundColor: ThemeManager
                                  .instance.themeNotifier.value.darkMutedColor,
                              title: Text("Choose a Visualisation"),
                              children: [
                                Card(
                                  elevation: 10,
                                  child: InkWell(
                                    onTap: () {
                                      PlayerManager
                                          .instance
                                          .visualisationTypeNotifier
                                          .value = VisualisationType.vinyl;
                                      setState(() {});
                                      PlayerManager.instance
                                          .savePlayerSettings();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: ThemeManager.instance.themeNotifier
                                          .value.darkMutedColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/vinyl-preview.png",
                                                height: 100,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(4)),
                                              Expanded(
                                                  child: Text(
                                                "Vinyl Record",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ThemeManager
                                                        .instance
                                                        .themeNotifier
                                                        .value
                                                        .lightMutedColor),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: InkWell(
                                    onTap: () {
                                      PlayerManager
                                          .instance
                                          .visualisationTypeNotifier
                                          .value = VisualisationType.casette;
                                      setState(() {});
                                      PlayerManager.instance
                                          .savePlayerSettings();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: ThemeManager.instance.themeNotifier
                                          .value.darkMutedColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/casette-preview.png",
                                                height: 100,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(4)),
                                              Expanded(
                                                  child: Text(
                                                "Vintage Casette",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ThemeManager
                                                        .instance
                                                        .themeNotifier
                                                        .value
                                                        .lightMutedColor),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text("Draw theme picture"),
                    onPressed: (context) {
                      drawThemePicture();
                    },
                  )
                ]),
            SettingsSection(
                title: Text(
                  "Music",
                  style: TextStyle(fontSize: 18),
                ),
                tiles: [
                  SettingsTile(
                    title: Text("Scan Media"),
                    description:
                        Text("Scan and choose which songs should show up"),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: (context) {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ScanSongsScreen();
                      }));
                    },
                  )
                ])
          ]),
      // body: Padding(
      //   padding: EdgeInsets.all(8.0),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           "Themes",
      //           style: TextStyle(fontSize: 22),
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Center(
      //               child: ,
      //             )
      //           ],
      //         ),
      //         Padding(
      //           padding: EdgeInsets.all(4),
      //         ),
      //         SizedBox(
      //           height: 120,
      //           child: ListView.builder(
      //               itemCount: ThemeManager.colorThemes.length,
      //               scrollDirection: Axis.horizontal,
      //               itemBuilder: (context, index) {
      //                 ColorState color =
      //                 ThemeManager.colorThemes.values.elementAt(index);
      //
      //               }),
      //         ),
      //         const Padding(padding: EdgeInsets.all(4)),
      //         Center(
      //           child: ElevatedButton(
      //             onPressed: () {
      //               generateRandomPalette();
      //             },
      //             child: Text("Make a random theme =)", style: TextStyle(color: ThemeManager.instance.themeNotifier.value.darkVibrantColor),),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  void generateRandomPalette() async {
    String url =
        'https://picsum.photos/200/300?random=${Random().nextInt(100000)}';
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(url, headers: {
      'User-Agent':
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
    }));
    Color dominant = _paletteGenerator.dominantColor?.color ??
        ThemeManager.instance.themeNotifier.value.dominantColor;
    Color muted = _paletteGenerator.mutedColor?.color ??
        HSLColor.fromColor(dominant).withSaturation(0.1).toColor();
    Color vibrant = _paletteGenerator.vibrantColor?.color ??
        HSLColor.fromColor(dominant).withSaturation(0.5).toColor();
    Color darkMuted = _paletteGenerator.darkMutedColor?.color ?? darken(muted);
    Color darkVibrant =
        _paletteGenerator.darkVibrantColor?.color ?? darken(vibrant);
    Color lightMuted =
        _paletteGenerator.lightMutedColor?.color ?? lighten(muted, 50);
    Color lightVibrant =
        _paletteGenerator.lightVibrantColor?.color ?? lighten(muted, 50);
    // await PlayerManager.instance.setThemeImage();
    ThemeManager.instance.themeNotifier.value = ColorState(
      darkMutedColor: darkMuted,
      lightMutedColor: lightMuted,
      darkVibrantColor: darkVibrant,
      lightVibrantColor: lightVibrant,
      mutedColor: muted,
      vibrantColor: vibrant,
      dominantColor: dominant,
    );
    drawThemePicture();
    //print(
    //     "'palette_name': ColorState(\ndominantColor: const Color(${dominant.value}),\nmutedColor: const Color(${muted.value}),\nvibrantColor: const Color(${vibrant.value}),\nlightMutedColor: const Color(${lightMuted.value}),\nlightVibrantColor: const Color(${lightVibrant.value}),\ndarkMutedColor: const Color(${darkMuted.value}),\ndarkVibrantColor: const Color(${darkVibrant.value})\n),");

    setState(() {});
  }


}

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

Future<void> drawThemePicture() async {
  ColorState color = ThemeManager.instance.themeNotifier.value;
  PictureRecorder recorder = PictureRecorder();
  Canvas c = Canvas(recorder);
  Paint paint = Paint();
  paint.shader = ui.Gradient.linear(Offset(0, 0), Offset(280, 280), [
    color.darkVibrantColor,
    color.mutedColor,
    color.vibrantColor,
    color.lightVibrantColor
  ], [
    0.0,
    0.3,
    0.6,
    1.0
  ]);
  //draw background
  c.drawColor(color.darkMutedColor, BlendMode.dstOver);
  //draw circle
  c.drawCircle(Offset(150, 150), 150, paint);
  //draw lotus
  final ByteData data = await rootBundle.load("assets/icon.png");
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: 300,
    targetWidth: 300,
  );
  var frame = await codec.getNextFrame();
  paint.blendMode = BlendMode.overlay;
  c.drawImage(frame.image, Offset(0, 0), paint);

  //save photo
  Picture p = recorder.endRecording();
  ByteData? pngBytes =
      await (await p.toImage(300, 300)).toByteData(format: ImageByteFormat.png);
  if (pngBytes == null) return;
  final directory = (await getExternalStorageDirectory())?.path;
  //print(directory);
  File imgFile = File('$directory/notification_image${ThemeManager.instance.currentThemeName.replaceAll(" ", "")}.png');
  await imgFile.writeAsBytes(pngBytes.buffer.asUint8List());
}

class PlayerModel extends StatelessWidget {
  const PlayerModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorState color = ThemeManager.instance.themeNotifier.value;
    // return Padding(
    //     padding: EdgeInsets.all(8),
    //     child: ClipOval(
    //         child: Container(
    //       width: 80,
    //       height: 80,
    //       child: FutureBuilder(
    //           future: getExternalStorageDirectory(),
    //           initialData: null,
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               return Image.file(File('${(snapshot.data as Directory).path}/notification_image.png'));
    //             }
    //             return Container();
    //           }),
    //     )));
    return RepaintBoundary(
      key: genKey,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ClipOval(
          child: Container(
            width: 80,
            height: 80,
            // color: color.darkMutedColor,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              color.darkVibrantColor,
              color.mutedColor,
              color.vibrantColor,
              color.dominantColor
            ])),
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                CupertinoIcons.music_note_2,
                size: 40,
                color: color.lightMutedColor,
                shadows: [
                  Shadow(
                      color: color.darkVibrantColor.withOpacity(0.4),
                      offset: Offset(8, 8)),
                  Shadow(
                      color: color.mutedColor.withOpacity(0.4),
                      offset: Offset(6, 6)),
                  Shadow(
                      color: color.vibrantColor.withOpacity(0.4),
                      offset: Offset(4, 4)),
                  Shadow(
                      color: color.dominantColor.withOpacity(0.4),
                      offset: Offset(2, 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          color: ThemeManager.instance.themeNotifier.value.darkMutedColor,
        ),
        width: 60,
        height: 110,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  ClipOval(
                    child: Container(
                      width: 20,
                      height: 20,
                      color: ThemeManager
                          .instance.themeNotifier.value.vibrantColor,
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Container(
                height: 4,
                width: 50,
                color:
                    ThemeManager.instance.themeNotifier.value.lightMutedColor,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Container(
                height: 4,
                width: 30,
                color: ThemeManager.instance.themeNotifier.value.mutedColor,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 2,
                    color: ThemeManager
                        .instance.themeNotifier.value.lightMutedColor,
                  ),
                  ClipOval(
                    child: Container(
                      width: 5,
                      height: 5,
                      color: ThemeManager
                          .instance.themeNotifier.value.lightVibrantColor,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 2,
                    color: ThemeManager
                        .instance.themeNotifier.value.darkVibrantColor,
                  ))
                ],
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 4,
                      height: 4,
                      color: ThemeManager
                          .instance.themeNotifier.value.lightVibrantColor,
                    ),
                  ),
                  const Expanded(
                    child: const Padding(padding: EdgeInsets.all(4)),
                  ),
                  ClipOval(
                    child: Container(
                      width: 6,
                      height: 6,
                      color: ThemeManager
                          .instance.themeNotifier.value.lightVibrantColor,
                    ),
                  ),
                  const Expanded(
                    child: const Padding(padding: EdgeInsets.all(4)),
                  ),
                  ClipOval(
                    child: Container(
                      width: 10,
                      height: 10,
                      color: ThemeManager
                          .instance.themeNotifier.value.dominantColor,
                    ),
                  ),
                  const Expanded(
                    child: const Padding(padding: EdgeInsets.all(4)),
                  ),
                  ClipOval(
                    child: Container(
                      width: 6,
                      height: 6,
                      color: ThemeManager
                          .instance.themeNotifier.value.lightVibrantColor,
                    ),
                  ),
                  const Expanded(
                    child: const Padding(padding: EdgeInsets.all(4)),
                  ),
                  ClipOval(
                    child: Container(
                      width: 4,
                      height: 4,
                      color: ThemeManager
                          .instance.themeNotifier.value.lightVibrantColor,
                    ),
                  ),
                  const Expanded(
                    child: const Padding(padding: EdgeInsets.all(4)),
                  ),
                ],
              ),
              const Expanded(
                child: const Padding(padding: EdgeInsets.all(8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
