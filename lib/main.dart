import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main_screen/main_screen.dart';

Future<void> main() async {
  //All the initializations will be performed here, later this part can be done
  //during the splash ad popup
  //initialize PlayerManager, it will start the audio service
  PlayerManager.instance = await AudioService.init(
    builder: () => PlayerManager.instance,
    config: AudioServiceConfig(
        androidNotificationChannelId: 'co.whitedragon.jiomusic.audio',
        androidNotificationChannelName: 'Jio Music',
        notificationColor: ThemeManager.instance.themeNotifier.value.mutedColor,
      androidNotificationIcon: 'drawable/ic_stat_notification',
      androidNotificationChannelDescription: 'Player music controls',
    ),
  );
  await OnAudioRoom().initRoom();
  await OnAudioQuery().permissionsRequest();
  // await OnAudioQuery().scanMedia("/");
  await Supabase.initialize(url: 'https://dpahurxrvsvwjediywov.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwYWh1cnhydnN2d2plZGl5d292Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjE5Mzg2ODcsImV4cCI6MTk3NzUxNDY4N30.EcGgJ6fMZ-bAqgpwikNNfLZGT-hiA9zCzJKxPhG988I');
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    LocalSongManager.instance;
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  final ThemeNotifier _themeNotifier = ThemeManager.instance.themeNotifier;

  // final PlayerManager _playerManager = PlayerManager();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColorState>(valueListenable: _themeNotifier, builder: (_, colorState, __){
      return MaterialApp(
          debugShowCheckedModeBanner: false,
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
              colorScheme: ColorScheme(brightness: Brightness.light, primary: colorState.dominantColor, onPrimary: colorState.lightMutedColor, secondary: colorState.mutedColor, onSecondary: colorState.lightVibrantColor, error: colorState.vibrantColor, onError: colorState.darkVibrantColor, background: colorState.darkMutedColor, onBackground: colorState.lightMutedColor, surface: colorState.darkVibrantColor, onSurface: colorState.lightMutedColor),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: colorState.mutedColor,
              foregroundColor: colorState.lightMutedColor
            ),
            hintColor: colorState.lightMutedColor,
            dialogBackgroundColor: colorState.darkMutedColor,
            backgroundColor: colorState.darkMutedColor,
            primaryColor: colorState.dominantColor,
            scaffoldBackgroundColor: colorState.darkMutedColor,
            tabBarTheme: TabBarTheme(
                labelColor: colorState.lightMutedColor,
                indicator: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colorState.mutedColor,
                            width: 2.0)))),
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: colorState.lightMutedColor,
                displayColor: colorState.lightMutedColor),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: colorState.lightMutedColor),
            iconTheme: IconThemeData(color: colorState.lightMutedColor),
            checkboxTheme: CheckboxThemeData(fillColor: MaterialStateProperty.all(colorState.lightMutedColor), checkColor: MaterialStateProperty.all(colorState.darkMutedColor)),
            buttonTheme: ButtonThemeData(buttonColor: colorState.lightMutedColor, disabledColor: colorState.mutedColor,)
          ),
          home: MainScreen(
          ));
    });
  }
}
