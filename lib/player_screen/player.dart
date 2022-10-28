import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/browse_screen/playlist_details_screen.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:music_player/notifiers/repeat_button_notifier.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/player_screen/equalizer.dart';
import 'package:music_player/player_screen/player_animation.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../utils/text_utils.dart';
import '../models/player_settings.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/reaction_button.dart';

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
            // appBar: ,
            body:
              // Center(child:
              Stack(
                  alignment: Alignment.topCenter,
                  children: [
              ValueListenableBuilder<VisualisationType>(
              valueListenable: PlayerManager
                  .instance.visualisationTypeNotifier,
                  builder: (_, visualisationType, __) {
                    if (visualisationType == VisualisationType.casette) {
                      return ValueListenableBuilder<CurrentSongState>(
                          valueListenable: _pageManager.currentSongNotifier,
                          builder: (_, currentSongState, __) {
                            return OverflowBox( alignment: Alignment.topCenter, child: ShaderMask(
                              shaderCallback: (rect) {
                                return RadialGradient(colors: [Colors.black, Colors.transparent], radius: 0.7).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: SquareArtworkWidget(currentSongState.song, 100),
                            ),);
                          });

                    } else {
                      return Container();
                    }
                  }),
                    Positioned(
                        top: 176,
                        left: 27,
                        child: ReactionBar([
                          ReactionButton('images/favorite.png', 'Favorite', 'favorite'),
                          ReactionButton('images/energize.png', 'Energizing', 'energizing'),
                          ReactionButton('images/relax.png', 'Relaxing', 'relaxing'),
                          ReactionButton('images/romance.png', 'Romance', 'romance'),
                          ReactionButton('images/sleep.png', 'Sleep', 'sleep'),
                        ], 'images/favorite_disabled.png')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AppBar(),
                    ValueListenableBuilder<CurrentSongState>(
                        valueListenable: _pageManager.currentSongNotifier,
                        builder: (_, currentSongState, __) {
                          AudioModel? value = currentSongState.song;
                          double titleWidth = textSize(value?.title ?? 'Unknown Name', TextStyle(
                              color:
                              colorValues.lightVibrantColor,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w400)).width;
                          double artistWidth = textSize(value?.artist ?? 'Unknown Name', TextStyle(
                              color:
                              colorValues.lightVibrantColor,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w400)).width;
                          double albumWidth = textSize(value?.album ?? 'Unknown Name', TextStyle(
                              color:
                              colorValues.lightVibrantColor,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w400)).width;
                          print("DEBUG: Text width: $titleWidth");
                          return Column(
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  const WaveAnimation(),
                                  ValueListenableBuilder<VisualisationType>(
                                      valueListenable: PlayerManager
                                          .instance.visualisationTypeNotifier,
                                      builder: (_, visualisationType, __) {
                                        switch (visualisationType) {
                                          case VisualisationType.vinyl:
                                            return VinylRecordAnimation(
                                                _animationController, value);
                                          case VisualisationType.casette:
                                            return CasetteAnimation(
                                                _animationController, value);
                                          case VisualisationType.gameboy:
                                            return VinylRecordAnimation(
                                                _animationController, value);
                                          case VisualisationType.nokia:
                                            return VinylRecordAnimation(
                                                _animationController, value);
                                        }
                                      })
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  height: 40,
                                  child: titleWidth > 350
                                      ? Marquee(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          velocity: 30,
                                          startAfter:
                                              const Duration(seconds: 1),
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          blankSpace: 300.0,
                                          scrollAxis: Axis.horizontal,
                                          text: value?.title ?? 'Unknown Name',
                                          style: TextStyle(
                                              color:
                                                  colorValues.lightVibrantColor,
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.w400,
                                              shadows: [Shadow(color: Colors.black54, blurRadius: 15)]),
                                        )
                                      : Text(
                                          value?.title ?? 'Unknown Name',
                                          style: TextStyle(
                                              color:
                                                  colorValues.lightVibrantColor,
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.w400,
                                          shadows: [Shadow(color: Colors.black54, blurRadius: 15)]),
                                        ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(4.0)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SizedBox(
                                  height: 20,
                                  child: artistWidth > 350
                                      ? Marquee(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          velocity: 30,
                                          startAfter:
                                              const Duration(seconds: 1),
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          blankSpace: 300.0,
                                          scrollAxis: Axis.horizontal,
                                          text:
                                              value?.artist ?? "Unknown Artist",
                                          style: TextStyle(
                                            color: colorValues.lightVibrantColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                              shadows: [Shadow(color: Colors.black54, blurRadius: 15)]
                                          ),
                                        )
                                      : Text(
                                          value?.artist ?? "Unknown Artist",
                                          style: TextStyle(
                                            color: colorValues.lightVibrantColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                              shadows: [Shadow(color: Colors.black54, blurRadius: 15)]
                                          ),
                                        ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(4.0)),
                              SizedBox(
                                  height: 20,
                                  child: albumWidth > 350
                                      ? Marquee(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          velocity: 30,
                                          startAfter:
                                              const Duration(seconds: 1),
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          blankSpace: 300.0,
                                          text: value?.album ?? 'Unknown Album',
                                          style: TextStyle(
                                              color:
                                                  colorValues.lightVibrantColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              shadows: [Shadow(color: Colors.black54, blurRadius: 15)]),
                                        )
                                      : Text(value?.album ?? 'Unknown Album',
                                          style: TextStyle(
                                              color:
                                                  colorValues.lightVibrantColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              shadows: [Shadow(color: Colors.black54, blurRadius: 15)]
                                          )))
                            ],
                          );
                        }),
                    const Padding(padding: EdgeInsets.all(16.0)),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<CurrentSongState>(
                                valueListenable:
                                    PlayerManager.instance.currentSongNotifier,
                                builder: (_, currentSongState, __) {
                                  return Container(
                                    width: 40,
                                  );
                                  return IconButton(
                                      onPressed: () async {
                                        AudioModel? currentSong =
                                            currentSongState.song;
                                        if (currentSong != null) {
                                          if (currentSongState.isInFavourites) {
                                            await PlayerManager.instance
                                                .removeFromFavourites(null);
                                            PlayerManager.instance
                                                .checkIfCurrentSongInFavourites();
                                          } else {
                                            await PlayerManager.instance
                                                .addToFavourites(null);
                                            PlayerManager.instance
                                                .checkIfCurrentSongInFavourites();
                                          }
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        currentSongState.isInFavourites
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border,
                                        color: currentSongState.isInFavourites
                                            ? Colors.redAccent
                                            : colorValues.lightVibrantColor,
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              EqualizerScreen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            final tween =
                                                Tween(begin: begin, end: end);
                                            final curvedAnimation =
                                                CurvedAnimation(
                                              parent: animation,
                                              curve: curve,
                                            );

                                            return SlideTransition(
                                              position: tween
                                                  .animate(curvedAnimation),
                                              child: child,
                                            );
                                          }));
                                },
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
                                              PlaylistDetailsScreen(
                                                  playlist: PlaylistEntity(0,
                                                      "Now Playing", 0, 0, []),
                                                  songs: PlayerManager.instance
                                                      .internalPlaylist.songs),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            final tween =
                                                Tween(begin: begin, end: end);
                                            final curvedAnimation =
                                                CurvedAnimation(
                                              parent: animation,
                                              curve: curve,
                                            );

                                            return SlideTransition(
                                              position: tween
                                                  .animate(curvedAnimation),
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
                              thumbColor: colorValues.lightVibrantColor,
                              thumbGlowColor: colorValues.vibrantColor,
                              timeLabelLocation: TimeLabelLocation.below,
                              timeLabelTextStyle: TextStyle(
                                  color: colorValues.lightVibrantColor),
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
                                    onPressed:
                                        _pageManager.onRepeatButtonPressed,
                                    icon: Icon(
                                      Icons.repeat,
                                      color: colorValues.mutedColor,
                                    ));
                                break;
                              case RepeatState.repeatSong:
                                return IconButton(
                                    onPressed:
                                        _pageManager.onRepeatButtonPressed,
                                    icon: Icon(
                                      Icons.repeat_one,
                                      color: colorValues.lightVibrantColor,
                                    ));
                                break;
                              case RepeatState.repeatPlaylist:
                                return IconButton(
                                    onPressed:
                                        _pageManager.onRepeatButtonPressed,
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

              ]),
            // ),
          );
        });
  }
}
