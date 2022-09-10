import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/browse_screen/playlist_details_screen.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:music_player/notifiers/repeat_button_notifier.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/playlist.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/extensions/song_map_formatter_extension.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage(
      {Key? key, required this.playerManager, required this.themeNotifier})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final PlayerManager playerManager;
  final ThemeNotifier themeNotifier;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late final PlayerManager _pageManager;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageManager = widget.playerManager;
    _animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ValueListenableBuilder<ColorsState>(
        valueListenable: _pageManager.colorNotifier,
        builder: (_, colorValues, __) {
          return Scaffold(
            backgroundColor: colorValues.darkMutedColor, //darkMutedColor
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                // title: Text(widget.title),
                ),
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ValueListenableBuilder<CurrentSongState>(
                      valueListenable: _pageManager.currentSongNotifier,
                      builder: (_, currentSongState, __) {
                        AudioModel? value = currentSongState.song;
                        return Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable:
                                        PlayerManager.instance.buttonNotifier,
                                    builder: (_, state, __) {
                                      return WaveWidget(
                                            config: CustomConfig(
                                              colors: [
                                                colorValues
                                                    .darkVibrantColor
                                                    .withOpacity(0.3),
                                                colorValues
                                                    .vibrantColor
                                                    .withOpacity(0.3),
                                                colorValues
                                                    .mutedColor
                                                    .withOpacity(0.3),
                                                colorValues
                                                    .dominantColor
                                                    .withOpacity(0.3),
                                                colorValues
                                                    .lightMutedColor
                                                    .withOpacity(0.3),
                                                colorValues
                                                    .lightVibrantColor
                                                    .withOpacity(0.6),
                                              ],
                                              durations: [
                                                3829,
                                                4829,
                                                5500,
                                                6000,
                                                5209,
                                                2809
                                              ],
                                              heightPercentages: [
                                                0.7,
                                                1.3,
                                                0.8,
                                                1.2,
                                                0.9,
                                                1.0
                                              ],
                                            ),
                                            size: Size(
                                                double.infinity,
                                                state == ButtonState.playing
                                                    ? 200
                                                    : 2),
                                            waveAmplitude: state == ButtonState.playing
                                                ? 10 : 1,
                                          );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 46.0),
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 1.0),
                                            spreadRadius: 0.5)
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 46.0),
                                    child: RotationTransition(
                                      turns: Tween(begin: 0.0, end: 1.0)
                                          .animate(_animationController),
                                      child: ClipOval(
                                        clipBehavior: Clip.hardEdge,
                                        child: SizedBox.fromSize(
                                            size: const Size.fromRadius(100),
                                            // Image radius
                                            child: QueryArtworkWidget(
                                              size: 400,
                                              id: value?.id ?? 0,
                                              type: ArtworkType.AUDIO,
                                              nullArtworkWidget:
                                                  QueryArtworkWidget(
                                                size: 400,
                                                id: value?.albumId ?? 0,
                                                type: ArtworkType.ALBUM,
                                                nullArtworkWidget: value !=
                                                            null &&
                                                        value.artistId != null
                                                    ? QueryArtworkWidget(
                                                        size: 400,
                                                        id: value.artistId ?? 0,
                                                        type:
                                                            ArtworkType.ARTIST,
                                                        nullArtworkWidget:
                                                            Image.asset(
                                                                'assets/vinyl.png'),
                                                      )
                                                    : Image.asset(
                                                        'assets/vinyl.png'),
                                              ),
                                            )),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 170.0, bottom: 100.0),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(70),
                                    child: Image.asset('assets/needle.png'),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SizedBox(
                                height: 40,
                                child: (value?.title.length ?? 0) > 24 ? Marquee(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  velocity: 30,
                                  startAfter:  const Duration(seconds: 1),
                                  pauseAfterRound: const Duration(seconds: 1),
                                  blankSpace: 300.0,
                                  scrollAxis: Axis.horizontal,
                                  text: value?.title ?? 'Unknown Name',
                                  style: TextStyle(
                                      color: colorValues.lightMutedColor,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w400),
                                ) : Text(
                                  value?.title ?? 'Unknown Name',
                                  style: TextStyle(
                                      color: colorValues.lightMutedColor,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4.0)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SizedBox(
                                height: 20,
                                child: (value?.artist!.length ?? 0) > 40 ? Marquee(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  velocity: 30,
                                  startAfter:  const Duration(seconds: 1),
                                  pauseAfterRound: const Duration(seconds: 1),
                                  blankSpace: 300.0,
                                  scrollAxis: Axis.horizontal,
                                  text: value?.artist ?? "Unknown Artist",
                                  style: TextStyle(
                                    color: colorValues.lightMutedColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ) : Text(
                                  value?.artist ?? "Unknown Artist",
                                  style: TextStyle(
                                    color: colorValues.lightMutedColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4.0)),
                            SizedBox(
                            height: 20,
                        child: (value?.album!.length ?? 0) > 40 ? Marquee(
                          crossAxisAlignment: CrossAxisAlignment.center,
                              velocity: 30,
                              startAfter: const Duration(seconds: 1),
                              pauseAfterRound: const Duration(seconds: 1),
                              blankSpace: 300.0,
                              text: value?.album ?? 'Unknown Album',
                              style: TextStyle(
                                  color: colorValues.lightMutedColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            ) : Text(
                            value?.album ?? 'Unknown Album',
                            style: TextStyle(
                                color: colorValues.lightMutedColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400)
                        ))
                          ],
                        );
                      }),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<CurrentSongState>(valueListenable: PlayerManager.instance.currentSongNotifier, builder: (_, currentSongState, __){
                        return IconButton(
                            onPressed: () {
                              AudioModel? currentSong = currentSongState.song;
                              if (currentSong != null) {
                                if (currentSongState.isInFavourites){
                                  PlayerManager.instance.removeFromFavourites(null);
                                }else{
                                  PlayerManager.instance.addToFavourites(null);
                                }
                              }
                              setState(() {

                              });
                            },
                            icon: Icon(
                              currentSongState.isInFavourites ? Icons.favorite_rounded : Icons.favorite_border,
                              color: currentSongState.isInFavourites ? Colors.redAccent : colorValues.lightVibrantColor,
                            ));
                      }),
                      const Padding(padding: EdgeInsets.all(4.0)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.download_for_offline_outlined,
                            color: colorValues.lightVibrantColor,
                          )),
                      const Padding(padding: EdgeInsets.all(4.0)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.comment_outlined,
                            color: colorValues.lightVibrantColor,
                          )),
                      const Padding(padding: EdgeInsets.all(4.0)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.equalizer,
                            color: colorValues.lightVibrantColor,
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        PlaylistDetailsScreen(playlistName: "Now Playing", songs: PlayerManager.instance.internalPlaylist.songs),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween =
                                          Tween(begin: begin, end: end);
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: curve,
                                      );

                                      return SlideTransition(
                                        position:
                                            tween.animate(curvedAnimation),
                                        child: child,
                                      );
                                    }));
                          },
                          icon: Icon(
                            Icons.playlist_play,
                            color: colorValues.lightVibrantColor,
                          ))
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: ValueListenableBuilder<ProgressBarState>(
                        valueListenable: _pageManager.progressNotifier,
                        builder: (_, value2, __) {
                          return ProgressBar(
                            progress: value2.current,
                            total: value2.total,
                            buffered: value2.buffered,
                            onSeek: _pageManager.seek,
                            baseBarColor: colorValues.darkVibrantColor,
                            progressBarColor: colorValues.lightVibrantColor,
                            bufferedBarColor: colorValues.vibrantColor,
                            thumbColor: colorValues.dominantColor,
                            thumbGlowColor: colorValues.dominantColor,
                            timeLabelTextStyle:
                                TextStyle(color: colorValues.lightVibrantColor),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable:
                            _pageManager.isShuffleModeEnabledNotifier,
                        builder: (_, isEnabled, __) {
                          return IconButton(
                              onPressed: _pageManager.onShuffleButtonPressed,
                              icon: Icon(
                                Icons.shuffle,
                                color: isEnabled
                                    ? colorValues.lightVibrantColor
                                    : colorValues.mutedColor,
                              ));
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _pageManager.hasPreviousSongNotifier,
                        builder: (_, hasPrevious, __) {
                          return IconButton(
                              iconSize: 48.0,
                              onPressed: hasPrevious
                                  ? _pageManager.onPreviousSongButtonPressed
                                  : null,
                              icon: Icon(
                                Icons.skip_previous_rounded,
                                color: hasPrevious
                                    ? colorValues.lightVibrantColor
                                    : colorValues.mutedColor,
                              ));
                        },
                      ),
                      ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager.buttonNotifier,
                          builder: (_, value2, __) {
                            switch (value2) {
                              case ButtonState.loading:
                                _animationController.stop();
                                return Container(
                                  margin: const EdgeInsets.all(18.0),
                                  width: 60.0,
                                  height: 60.0,
                                  child: CircularProgressIndicator(
                                    color: colorValues.lightVibrantColor,
                                  ),
                                );
                              case ButtonState.paused:
                                _animationController.stop();
                                return IconButton(
                                    iconSize: 80.0,
                                    onPressed: _pageManager.play,
                                    icon: Icon(
                                      Icons.play_circle,
                                      color: colorValues.lightVibrantColor,
                                    ));
                              case ButtonState.playing:
                                _animationController.repeat();
                                return IconButton(
                                    iconSize: 80.0,
                                    onPressed: _pageManager.pause,
                                    icon: Icon(
                                      Icons.pause_circle,
                                      color: colorValues.lightVibrantColor,
                                    ));
                            }
                          }),
                      ValueListenableBuilder<bool>(
                        valueListenable: _pageManager.hasNextSongNotifier,
                        builder: (_, hasNext, __) {
                          return IconButton(
                              onPressed: hasNext
                                  ? _pageManager.onNextSongButtonPressed
                                  : null,
                              iconSize: 48.0,
                              icon: Icon(
                                Icons.skip_next_rounded,
                                color: hasNext
                                    ? colorValues.lightVibrantColor
                                    : colorValues.mutedColor,
                              ));
                        },
                      ),
                      ValueListenableBuilder<RepeatState>(
                        valueListenable: _pageManager.repeatButtonNotifier,
                        builder: (_, state, __) {
                          switch (state) {
                            case RepeatState.off:
                              return IconButton(
                                  onPressed: _pageManager.onRepeatButtonPressed,
                                  icon: Icon(
                                    Icons.repeat,
                                    color: colorValues.mutedColor,
                                  ));
                              break;
                            case RepeatState.repeatSong:
                              return IconButton(
                                  onPressed: _pageManager.onRepeatButtonPressed,
                                  icon: Icon(
                                    Icons.repeat_one,
                                    color: colorValues.lightVibrantColor,
                                  ));
                              break;
                            case RepeatState.repeatPlaylist:
                              return IconButton(
                                  onPressed: _pageManager.onRepeatButtonPressed,
                                  icon: Icon(
                                    Icons.repeat,
                                    color: colorValues.lightVibrantColor,
                                  ));
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(32.0))
                ],
              ),
            ),
          );
        });
  }
}
