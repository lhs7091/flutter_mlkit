import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File pickedImage;
  bool isImageLoaded = false;

  List _result;
  String _confidence = '';
  String _name = '';

  String numbers = '';

  getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
    });

    applyModelOnImage(pickedImage);
  }

  loadMyModel() async {
    var resultant = await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');

    print('Result after loading model: $resultant');
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _result = res;

      String str = _result[0]['label'];

      _name = str.substring(2);
      _confidence = _result != null
          ? (_result[0]['confidence'] * 100.0).toString().substring(0, 2) + '%'
          : '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFLite Demo'),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            isImageLoaded
                ? Center(
                    child: Container(
                      height: 350.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: FileImage(File(pickedImage.path)),
                        fit: BoxFit.contain,
                      )),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 30.0,
            ),
            Text("Name : $_name \nConfidence: $_confidence")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromGallery();
        },
        child: Icon(Icons.photo_album),
      ),
    );
  }
}
