import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:google_fonts/google_fonts.dart';
import '../managers/player_manager.dart';
import '../widgets/artwork_widget.dart';
import 'dart:ui' as ui;

class WaveAnimation extends StatelessWidget {
  const WaveAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColorsState>(
        valueListenable: PlayerManager.instance.colorNotifier,
        builder: (_, colorValues, __) {
          return ValueListenableBuilder(
              valueListenable: PlayerManager.instance.buttonNotifier,
              builder: (_, state, __) {
                return WaveWidget(
                  config: CustomConfig(
                    colors: [
                      colorValues.darkVibrantColor.withOpacity(0.4),
                      colorValues.darkVibrantColor.withOpacity(0.4),
                      colorValues.vibrantColor.withOpacity(0.3),
                      colorValues.vibrantColor.withOpacity(0.3),
                      colorValues.dominantColor.withOpacity(0.3),
                      colorValues.dominantColor.withOpacity(0.3),
                    ],
                    durations: [3829, 3829, 5500, 6000, 5209, 2809],
                    heightPercentages: [0.7, 1.3, 0.8, 1.2, 0.9, 1.0],
                  ),
                  size: Size(
                      double.infinity, state == ButtonState.playing ? 200 : 2),
                  waveAmplitude: state == ButtonState.playing ? 10 : 1,
                );
              });
        });
  }
}

class VinylRecordAnimation extends StatelessWidget {
  final AnimationController _animationController;
  final AudioModel? value;

  const VinylRecordAnimation(this._animationController, this.value, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Container(
            width: 230,
            height: 230,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 0.5)
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox.fromSize(
                        size: const Size.fromRadius(120),
                        // Image radius
                        child: Image.asset('assets/vinyl.png'))))),
        Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(50),
                    // Image radius
                    child: ArtworkWidget(value, 200.0)),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 190.0, bottom: 70.0),
          child: SizedBox.fromSize(
            size: const Size.fromRadius(80),
            child: Image.asset('assets/needle.png'),
          ),
        )
      ],
    );
  }
}

class WalkmanAnimation extends StatelessWidget {
  const WalkmanAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CasetteAnimation extends StatelessWidget {
  final AnimationController _animationController;
  final AudioModel? value;

  const CasetteAnimation(this._animationController, this.value, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<ProgressBarState>(
    //     valueListenable: PlayerManager.instance.progressNotifier,
    //     builder: (_, progress, __) {

    return Stack(alignment: Alignment.center, children: [

      ValueListenableBuilder<ProgressBarState>(
          valueListenable: PlayerManager.instance.progressNotifier,
          builder: (_, progress, __) {
            double percentNotPlayed = (progress.total.inMilliseconds -
                    progress.current.inMilliseconds) /
                progress.total.inMilliseconds;
            if (percentNotPlayed.isNaN) percentNotPlayed = 0;
            return Padding(
                padding: EdgeInsets.only(
                    bottom: 32.0,
                    right:140),
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox.fromSize(
                        size: Size.fromRadius(min(35 + percentNotPlayed * 40, 75)),
                        // Image radius
                        child: Image.asset('assets/casette-progress.png')),
                  ),
                ));
          }),
      ValueListenableBuilder<ProgressBarState>(
          valueListenable: PlayerManager.instance.progressNotifier,
          builder: (_, progress, __) {
            double percentPlayed = (progress.current.inMilliseconds) /
                progress.total.inMilliseconds;
            if (percentPlayed.isNaN) percentPlayed = 0;
            return Padding(
                padding: EdgeInsets.only(
                    bottom: 32.0,
                    left: 140),
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox.fromSize(
                        size: Size.fromRadius(min(35 + percentPlayed*40, 75)),
                        // Image radius
                        child: Image.asset('assets/casette-progress.png')),
                  ),
                ));
          }),
      Padding(
          padding: EdgeInsets.only(bottom: 32.0, right: 140),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  // Image radius
                  child: Image.asset('assets/casette-wheel.png')),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(bottom: 32.0, left: 135),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  // Image radius
                  child: Image.asset('assets/casette-wheel.png')),
            ),
          )),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SizedBox.fromSize(
          size: const Size.fromHeight(220),
          child: Image.asset(
            'assets/casette.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 150, left: 60),
        child: SizedBox(
          width: 170,
          child: Text(
            value?.title ?? 'Unknown cool song',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.zhiMangXing(
                textStyle:
                    const TextStyle(color: Colors.black87, fontSize: 21)),
          ),
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.only(right: 230, bottom: 120),
      //   child: FutureBuilder(
      //     future: PlayerManager.instance.getImageUrl(value),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return ClipOval(
      //             child: SizedBox.fromSize(
      //                 size: Size.fromRadius(40), // Image radius
      //                 child: Container()));
      //       } else if (snapshot.hasError) {
      //         return ClipOval(
      //             child: SizedBox.fromSize(
      //                 size: Size.fromRadius(40), // Image radius
      //                 child: Container()));
      //       } else {
      //         return Container(
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: Colors.black54,
      //                     blurRadius: 2.0,)
      //               ]
      //           ),
      //           child: ClipOval(
      //               child: SizedBox.fromSize(
      //                   size: Size.fromRadius(32), // Image radius
      //                   child: Image.network(snapshot.data as String))),
      //         );
      //       }
      //     },
      //   ),
      // )
    ]);
    // });
  }
}

class GameboyAnimation extends StatelessWidget {
  const GameboyAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NokiaAnimation extends StatelessWidget {
  const NokiaAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
