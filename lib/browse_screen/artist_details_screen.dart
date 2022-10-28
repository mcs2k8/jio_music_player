import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/player_stripe.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/web_workers/music_information_worker.dart';
import 'mini_album_list_widget.dart';
import 'mini_song_list_widget.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final ArtistModel artist;
  final ThemeNotifier themeNotifier;

  const ArtistDetailsScreen(
      {Key? key, required this.artist, required this.themeNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicInformationWorker.instance.fetchArtistPhoto(artist.artist);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ValueListenableBuilder<String?>(
                          valueListenable: MusicInformationWorker
                              .instance.artistPhotoNotifier,
                          builder: (_, imageUrl, __) {
                            if (imageUrl != null) {
                              return Image.network(cacheWidth: 1000, imageUrl, fit: BoxFit.cover);
                            } else {
                              return Image.asset(
                                "assets/vinyl.png",
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                AppBar(
                  title: Text(artist.artist),
                  backgroundColor:
                      themeNotifier.value.darkMutedColor.withAlpha(80),
                ),
              ],
            ),
                const TabBar(tabs: [
              Tab(
                text: "Songs",
              ),
              Tab(
                text: "Albums",
              )
            ]),
            Expanded(
              flex: 4,
              child: TabBarView(children: [
                MiniSongListWidget(
                  artist: artist.id.toString(),
                ),
                MiniAlbumListWidget(
                  artistId: artist.artist,
                ),
              ]),
            ),
            PlayerStripe(
              themeNotifier: themeNotifier,
            )
          ],
        ),
      ),
    );
  }
}
