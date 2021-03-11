import 'package:flutter/material.dart';
import 'package:journalize/pages/add_edit_page.dart';
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
      title: "Journalize",
      home: HomePage(),
      routes:<String, WidgetBuilder>{
        '/add_edit_page': (context) => AddEditPage()
      },
    );
  }
}
