import 'package:earningproject/data/constants.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_db;

void main() async {
  connectDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earnings Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
