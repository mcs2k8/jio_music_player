import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';

import 'equalizer_parts.dart';


/// Unfortunately, equalizer does not work right now with
/// Just_audio_background...
/// I will have to change the implementation to use audio_service in the
/// future, hopefully that will allow to use the equalizer

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({Key? key}) : super(key: key);

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equalizer"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<bool>(
            stream: PlayerManager.instance.androidLoudnessEnhancer.enabledStream,
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return SwitchListTile(
                title: const Text('Loudness Enhancer'),
                value: enabled,
                onChanged: PlayerManager.instance.androidLoudnessEnhancer.setEnabled,
              );
            },
          ),
          LoudnessEnhancerControls(loudnessEnhancer: PlayerManager.instance.androidLoudnessEnhancer),
          StreamBuilder<bool>(
            stream: PlayerManager.instance.androidEqualizer.enabledStream,
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return SwitchListTile(
                title: const Text('Equalizer'),
                value: enabled,
                onChanged: PlayerManager.instance.androidEqualizer.setEnabled,
              );
            },
          ),
          Expanded(
            child: EqualizerControls(equalizer: PlayerManager.instance.androidEqualizer),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // PlayerManager.instance.loadEqualizer();
  }
}
