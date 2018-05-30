import 'package:flutter/material.dart';
import 'imagePage.dart';
import 'breedList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Happy',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: BreedList(title: 'Be Happy'),
    );
  }
}