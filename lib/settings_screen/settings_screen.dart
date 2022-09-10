import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Themes",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                  itemCount: ThemeManager.colorThemes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    ColorState color =
                        ThemeManager.colorThemes.values.elementAt(index);
                    return Card(
                      elevation: 10,
                      child: InkWell(
                        onTap: () {
                          ThemeManager.instance.currentTheme = ThemeManager.colorThemes.values.elementAt(index);
                          ThemeManager.instance.currentThemeName = ThemeManager.colorThemes.keys.elementAt(index);
                          ThemeManager.instance.themeNotifier.value = ThemeManager.colorThemes.values.elementAt(index);
                          PlayerManager.instance.updateColors(null);
                          setState(() {

                          });
                          PlayerManager.instance.savePlayerSettings();
                        },
                        child: Container(
                          width: 150,
                          height: 190,
                          color: color.darkMutedColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    ClipOval(child: Container(width: 70, height: 70, color: color.vibrantColor,),),
                                    Expanded(child: Container())
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(8)),
                                Container(
                                  height: 10,
                                  width: 100,
                                  color: color.lightMutedColor,
                                ),
                                const Padding(padding: EdgeInsets.all(4)),
                                Container(
                                  height: 10,
                                  width: 70,
                                  color: color.mutedColor,
                                ),

                                const Padding(padding: EdgeInsets.all(8)),
                                Row(
                                  children: [
                                    Container(width: 30, height: 2, color: color.lightMutedColor,),
                                    ClipOval(child: Container(width: 10, height: 10, color: color.lightVibrantColor,),),
                                    Expanded(child: Container( height: 2, color: color.darkVibrantColor,))
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(8)),
                                Row(
                                  children: [
                                    ClipOval(child: Container(width: 10, height: 10, color: color.lightVibrantColor,),),
                                    const Expanded(child: const Padding(padding: EdgeInsets.all(4)),),
                                    ClipOval(child: Container(width: 15, height: 15, color: color.lightVibrantColor,),),
                                    const Expanded(child: const Padding(padding: EdgeInsets.all(4)),),
                                    ClipOval(child: Container(width: 20, height: 20, color: color.dominantColor,),),
                                    const Expanded(child: const Padding(padding: EdgeInsets.all(4)),),
                                    ClipOval(child: Container(width: 15, height: 15, color: color.lightVibrantColor,),),
                                    const Expanded(child: const Padding(padding: EdgeInsets.all(4)),),
                                    ClipOval(child: Container(width: 10, height: 10, color: color.lightVibrantColor,),),
                                    const Expanded(child: const Padding(padding: EdgeInsets.all(4)),),
                                  ],
                                ),
                                const Expanded(child: const Padding(padding: EdgeInsets.all(8)),),
                                Row(
                                  children: [
                                    Expanded(child: Text(ThemeManager.colorThemes.keys.elementAt(index), style: TextStyle(color: color.lightMutedColor),)),
                                    Icon(ThemeManager.instance.currentTheme == ThemeManager.colorThemes.values.elementAt(index) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
