import 'package:isar/isar.dart';
part 'album_image.g.dart';

@Collection()
class AlbumImage {
  Id? albumId;
  String imageUrl;

  AlbumImage({required this.albumId, required this.imageUrl});
}
