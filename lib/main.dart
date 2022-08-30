import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/player_manager.dart';
import 'package:music_player/list_screen/browse_screen.dart';
import 'package:music_player/song_list_manager.dart';
import 'package:music_player/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'co.whitedragon.music.channel.audio',
    androidNotificationChannelName: 'Jio Music',
    androidNotificationOngoing: true,
  );
  await OnAudioRoom().initRoom();
  await OnAudioQuery().permissionsRequest();
  await OnAudioQuery().scanMedia("/");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    LocalSongManager.instance;
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  // final PlayerManager _playerManager = PlayerManager();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppLocalizations.of(context)?.appTitle ?? 'Jio Music',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('zh', ''), // Spanish, no country code
        ],
        theme: ThemeData(
          backgroundColor: _themeNotifier.value.darkMutedColor,
          primaryColor: _themeNotifier.value.dominantColor,
          scaffoldBackgroundColor: _themeNotifier.value.darkMutedColor,
          tabBarTheme: TabBarTheme(
              labelColor: _themeNotifier.value.lightMutedColor,
              indicator: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: _themeNotifier.value.mutedColor,
                          width: 2.0)))),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: _themeNotifier.value.lightMutedColor,
              displayColor: _themeNotifier.value.lightMutedColor),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: _themeNotifier.value.lightMutedColor),
          iconTheme: IconThemeData(color: _themeNotifier.value.lightMutedColor),
        ),
        home: BrowseScreen(
          themeNotifier: _themeNotifier,
        ));
  }
}
