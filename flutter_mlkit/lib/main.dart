//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_mlkit/detail_screen.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> itemsList = [
    'Text Scanner',
    'Barcode Scanner',
    'Label Scanner',
    'Face Detection'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ML Kit Demo'),
        ),
        body: ListView.builder(
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                  title: Text(itemsList[index]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(),
                            settings:
                                RouteSettings(arguments: itemsList[index])));
                  }),
            );
          },
        ));
  }
}
