import 'package:flutter/material.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/pages/add_page.dart';
import 'package:journalize/pages/home_page.dart';
import 'package:journalize/services/database_service.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => JournalsModelView(dbService: DatabaseService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Color(0xFFF6C791),
          canvasColor: Colors.white,
        ),
        title: "Journalize",
        home: HomePage(),
      ),
    );
  }
}
