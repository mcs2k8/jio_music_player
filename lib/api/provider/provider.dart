
abstract class Provider {
  Future<Map> showPlaylist(int offset);
  Future<Map> getPlaylist(String playlistId);
  Future<String> bootstrapTrack(String trackId);
  Future<Map> search(var keyword, var page);
  Map parseUrl(String url);
}
