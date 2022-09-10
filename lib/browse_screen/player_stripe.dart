import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/browse_screen/playlist_details_screen.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:music_player/player_screen/player.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../playlist.dart';

class PlayerStripe extends StatefulWidget {
  const PlayerStripe({Key? key, required this.themeNotifier}) : super(key: key);
  final ThemeNotifier themeNotifier;

  @override
  State<PlayerStripe> createState() => _PlayerStripeState();
}

class _PlayerStripeState extends State<PlayerStripe> {
  late PlayerManager _playerManager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PlayerPage(playerManager: _playerManager, themeNotifier: widget.themeNotifier,),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end);
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  );

                  return SlideTransition(
                    position: tween.animate(curvedAnimation),
                    child: child,
                  );
                }));
      },
      child: ValueListenableBuilder<CurrentSongState>(
        valueListenable: _playerManager.currentSongNotifier,
        builder: (_, currentSongState, ___) {
          AudioModel? currentSong = currentSongState.song;
          return Container(
              height: 70,
              color: widget.themeNotifier.value.darkVibrantColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(4.0)),
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(25), // Image radius
                      child: QueryArtworkWidget(
                        id: currentSong?.id ?? 0,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: QueryArtworkWidget(
                          id: currentSong?.albumId ?? 0,
                          type: ArtworkType.ALBUM,
                          nullArtworkWidget: currentSong != null && currentSong.artistId != null  ? QueryArtworkWidget(
                            id: currentSong.artistId!,
                            type: ArtworkType.ARTIST,
                            nullArtworkWidget: Image.asset('assets/vinyl.png'),
                          ) : Image.asset('assets/vinyl.png'),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong?.title ?? "None",
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.all(2.0)),
                      Text(
                        currentSong?.artist ?? "None",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
                  ValueListenableBuilder<ButtonState>(
                    valueListenable: PlayerManager.instance.buttonNotifier,
                    builder: (_, state, __) {
                      switch (state){

                        case ButtonState.paused:
                          return IconButton(
                              onPressed: () {
                                _playerManager.play();
                              },
                              icon: Icon(Icons.play_circle_fill_rounded));
                        case ButtonState.playing:
                          return IconButton(
                              onPressed: () {
                                _playerManager.pause();
                              },
                              icon: Icon(Icons.pause_circle_filled_rounded));
                        case ButtonState.loading:
                          return Container(
                            margin: const EdgeInsets.all(18.0),
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              color: ThemeNotifier().value.lightVibrantColor,
                            ),
                          );
                      }
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        if (_playerManager.hasNextSongNotifier.value){
                          _playerManager.onNextSongButtonPressed();
                        }
                      }, icon: const Icon(Icons.skip_next_rounded)),
                  IconButton(onPressed: () {
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
                  }, icon: Icon(Icons.playlist_play))
                ],
              ));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _playerManager = PlayerManager.instance;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
