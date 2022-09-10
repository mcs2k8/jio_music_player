import 'package:azlistview/azlistview.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AzSongItem extends ISuspensionBean{
  AudioModel songModel;
  String tag;

  AzSongItem({required this.songModel, required this.tag});

  @override
  String getSuspensionTag() {
    return tag;
  }

}

class AzArtistItem extends ISuspensionBean{
  ArtistModel artistModel;
  String tag;

  AzArtistItem({required this.artistModel, required this.tag});

  @override
  String getSuspensionTag() {
    return tag;
  }

}

class AzAlbumItem extends ISuspensionBean{
  AlbumModel albumModel;
  String tag;

  AzAlbumItem({required this.albumModel, required this.tag});

  @override
  String getSuspensionTag() {
    return tag;
  }

}