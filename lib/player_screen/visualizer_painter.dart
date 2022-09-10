import 'package:flutter/material.dart';
import 'package:music_player/managers/theme_manager.dart';

class VisualizerPainter extends CustomPainter {
  final List<int> fft;
  final double height;
  final Color color;
  late final Paint wavePaint;
  late final Paint lowWavePaint;
  late final Paint medWavePaint;
  late final Paint highWavePaint;
  final ThemeNotifier themeNotifier;

  VisualizerPainter({
    required this.fft,
    required this.height,
    required this.color,
    required this.themeNotifier
  }) {
    wavePaint = Paint()
      ..color = color.withOpacity(0.75)
      ..style = PaintingStyle.fill;

    lowWavePaint = Paint()
      ..color = themeNotifier.value.darkVibrantColor.withOpacity(0.5)
    ..style = PaintingStyle.fill;

    medWavePaint = Paint()
    ..color = themeNotifier.value.vibrantColor.withOpacity(0.7)
    ..style = PaintingStyle.fill;

    highWavePaint = Paint()
      ..color = themeNotifier.value.lightVibrantColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
  }






  @override
  void paint(Canvas canvas, Size size) {
    _renderWaves(canvas, size);
  }

  void _renderWaves(Canvas canvas, Size size) {
    final histogramLow = _createHistogram(fft, 15, "low", 2, ((fft.length) / 4).floor());
    final histogramMed =
    _createHistogram(fft, 15, "med", (fft.length / 4).ceil(), (fft.length / 2).floor());
    final histogramHigh =
    _createHistogram(fft, 15, "high", (fft.length / 2).ceil(), (fft.length * .75).floor());

    _renderHistogram(canvas, size, histogramLow, lowWavePaint);
    _renderHistogram(canvas, size, histogramHigh, highWavePaint);
    _renderHistogram(canvas, size, histogramMed, medWavePaint);
  }

  List<int> _createHistogram(List<int> samples, int bucketCount, String type,[ int? start, int? end]) {
    if (start == end) {
      return const [];
    }

    start = start ?? 0;
    end = end ?? samples.length - 1;
    final sampleCount = end - start + 1;

    final samplesPerBucket = (sampleCount / bucketCount).floor();
    if (samplesPerBucket == 0) {
      return const [];
    }

    final actualSampleCount = samplesPerBucket * bucketCount;
    //final actualSampleCount = sampleCount - (sampleCount % samplesPerBucket);
    List<int> histogram = new List<int>.filled(bucketCount, 0);

    // Add up the frequency amounts for each bucket.
    for (int i = start; i <= start + actualSampleCount; i++) {
      // Ignore the imaginary half of each FFT sample
      if ((i - start) % 2 == 1) { // ignore odd indexes
        continue;
      }
      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      if(bucketIndex >= bucketCount) {
        print("WTF?? $bucketIndex");
        bucketIndex--;
      }

      histogram[bucketIndex] += samples[i];
    }

    // smooth the data for visualization
    for (var i = 0; i < histogram.length; ++i) {
      histogram[i] = (histogram[i] / (samplesPerBucket * 1.2)).round();
    }

    //print("histogram $type Size = ${histogram.length} $histogram");
    print("Samples $samples");
    return histogram;
  }

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram, Paint wavePaint) {
    if (histogram.length == 0) {
      return;
    }

    final pointsToGraph = histogram.length;
    final widthPerSample = (size.width / (pointsToGraph - 2)).floor();

    final points = new List<double>.filled(pointsToGraph * 4, 0.0);

    for (int i = 0; i < histogram.length - 1; ++i) {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - histogram[i].toDouble();

      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - (histogram[i + 1].toDouble());
    }

    Path path = new Path();
    path.moveTo(0.0, size.height);
    path.lineTo(points[0], points[1]);
    for (int i = 2; i < points.length - 4; i += 2) {
      path.cubicTo(points[i - 2] + 10.0, points[i - 1], points[i] - 10.0, points[i + 1], points[i],
          points[i + 1]);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}