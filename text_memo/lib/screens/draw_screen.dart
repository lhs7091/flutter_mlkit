import 'package:flutter/material.dart';
import 'package:text_memo/export.dart';
import 'dart:ui' as ui;

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final _recognizer = Recognizer();
  String _pred = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Memo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'memo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _drawCanvasWidget(),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              _pred,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _recognize();
            _points.clear();
          });
        },
      ),
    );
  }

  Widget _drawCanvasWidget() {
    double canvasWidth = 300;
    double canvasHeight = 300;
    return Center(
      child: Container(
        width: canvasWidth,
        height: canvasHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            Offset _localPosition = details.localPosition;
            if (_localPosition.dx >= 0 &&
                _localPosition.dx <= canvasWidth &&
                _localPosition.dy >= 0 &&
                _localPosition.dy <= canvasHeight) {
              setState(() {
                _points.add(_localPosition);
              });
            }
          },
          onPanEnd: (DragEndDetails details) {
            _points.add(null);
          },
          child: CustomPaint(
            painter: DrawingPainter(_points),
          ),
        ),
      ),
    );
  }

  void _recognize() async {
    String pred = await _recognizer.recognize(_points);
    setState(() {
      _pred = pred;
    });
  }
}
