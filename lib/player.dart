import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/notifiers/repeat_button_notifier.dart';
import 'package:music_player/player_manager.dart';
import 'package:music_player/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/extensions/song_map_formatter_extension.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, required this.playerManager}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final PlayerManager playerManager;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final PlayerManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = widget.playerManager;
  }

  @override
  void dispose() {
    // _pageManager.dispose();
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
                  ValueListenableBuilder<AudioModel?>(
                      valueListenable: _pageManager.currentSongNotifier,
                      builder: (_, value, __) {
                        return Column(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                  size: const Size.fromRadius(100),
                                  // Image radius
                                  child: QueryArtworkWidget(
                                    id: value?.id ?? 0,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: QueryArtworkWidget(
                                      id: value?.albumId ?? 0,
                                      type: ArtworkType.ALBUM,
                                      nullArtworkWidget: QueryArtworkWidget(
                                        id: value?.artistId ?? 0,
                                        type: ArtworkType.ARTIST,
                                        nullArtworkWidget:
                                            Image.asset('assets/vinyl.png'),
                                      ),
                                    ),
                                  )),
                            ),
                            const Padding(padding: EdgeInsets.all(16.0)),
                            Text(
                              value?.title ?? 'Unknown Name',
                              maxLines: 1,
                              style: TextStyle(
                                  color: colorValues.lightMutedColor,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const Padding(padding: EdgeInsets.all(4.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  value?.artist ?? "Unknown Artist",
                                  style: TextStyle(
                                      color: colorValues.lightMutedColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                )),
                                const Padding(padding: EdgeInsets.all(8.0)),
                                Expanded(
                                    child: Text(
                                  value?.album ?? 'Unknown Album',
                                  style: TextStyle(
                                      color: colorValues.lightMutedColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                ))
                              ],
                            ),
                          ],
                        );
                      }),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            var currentSong = PlayerManager
                                .instance.currentSongNotifier.value;
                            if (currentSong != null) {
                              OnAudioRoom().addTo(
                                  RoomType.FAVORITES,
                                  PlayerManager.instance.currentSongNotifier
                                      .value!.getMap.toFavoritesEntity);
                            }
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: colorValues.lightVibrantColor,
                          )),
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
                                        Playlist(_pageManager),
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
                            baseBarColor: colorValues.mutedColor,
                            progressBarColor: colorValues.lightVibrantColor,
                            bufferedBarColor: colorValues.lightMutedColor,
                            thumbColor: colorValues.vibrantColor,
                            thumbGlowColor: colorValues.vibrantColor,
                            thumbGlowRadius: 8.0,
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
                        valueListenable: _pageManager.isFirstSongNotifier,
                        builder: (_, isFirst, __) {
                          return IconButton(
                              iconSize: 48.0,
                              onPressed: isFirst
                                  ? null
                                  : _pageManager.onPreviousSongButtonPressed,
                              icon: Icon(
                                Icons.skip_previous_rounded,
                                color: isFirst
                                    ? colorValues.mutedColor
                                    : colorValues.lightVibrantColor,
                              ));
                        },
                      ),
                      ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager.buttonNotifier,
                          builder: (_, value2, __) {
                            switch (value2) {
                              case ButtonState.loading:
                                return Container(
                                  margin: const EdgeInsets.all(18.0),
                                  width: 60.0,
                                  height: 60.0,
                                  child: CircularProgressIndicator(
                                    color: colorValues.lightVibrantColor,
                                  ),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                    iconSize: 80.0,
                                    onPressed: _pageManager.play,
                                    icon: Icon(
                                      Icons.play_circle,
                                      color: colorValues.lightVibrantColor,
                                    ));
                              case ButtonState.playing:
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
                        valueListenable: _pageManager.isLastSongNotifier,
                        builder: (_, isLast, __) {
                          return IconButton(
                              onPressed: isLast
                                  ? null
                                  : _pageManager.onNextSongButtonPressed,
                              iconSize: 48.0,
                              icon: Icon(
                                Icons.skip_next_rounded,
                                color: isLast
                                    ? colorValues.mutedColor
                                    : colorValues.lightVibrantColor,
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
