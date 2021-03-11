import 'package:flutter/material.dart';
import 'package:journalize/pages/add_page.dart';
import 'package:journalize/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFFF6C791),
        canvasColor: Colors.white,
      ),
      title: "Journalize",
      home: HomePage(),
    );
  }
}
