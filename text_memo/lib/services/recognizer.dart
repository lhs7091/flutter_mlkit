import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

final imageSize = 300.0;

final _canvasCullRect =
    Rect.fromPoints(Offset(0, 0), Offset(imageSize, imageSize));

final _whitePaint = Paint()
  ..strokeCap = StrokeCap.round
  ..color = Colors.white
  ..strokeWidth = 8.0;

final _bgPaint = Paint()..color = Colors.black;

class Recognizer {
  Future recognize(List<Offset> points) async {
    print('recognize start');
    final picture = _pointsToPicture(points);
    var pngBytes = await _pictureToBytes(picture);
    final tempDir = await getExternalStorageDirectory();

    var file = await new File("${tempDir.path}/img.jpg").create();
    file.writeAsBytes(pngBytes);
    print(await file.exists());

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "${tempDir.path}/img.jpg");

    File pickedImage = File("${tempDir.path}/img.jpg");

    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);
    String word = '';
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        print(line.text);
        word = word + line.text + '\n';
      }
    }
    recognizeText.close();
    return word;
  }

  Future _pictureToBytes(Picture picture) async {
    final image = await picture.toImage(300, 300);
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);
    return pngBytes.buffer.asInt8List();
  }

  Picture _pointsToPicture(List<Offset> points) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, _canvasCullRect)..scale(1.0);

    canvas.drawRect(Rect.fromLTWH(0, 0, 300, 300), _bgPaint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _whitePaint);
      }
    }
    return recorder.endRecording();
  }
}
