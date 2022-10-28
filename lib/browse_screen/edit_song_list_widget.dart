import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class EditSongListWidget extends StatefulWidget {
  final List<AudioModel> songs;
  const EditSongListWidget({Key? key, required this.songs}) : super(key: key);

  @override
  State<EditSongListWidget> createState() => _EditSongListWidgetState();
}

class _EditSongListWidgetState extends State<EditSongListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
