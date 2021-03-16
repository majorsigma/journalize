import 'package:flutter/material.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/pages/home_page.dart';
import 'package:journalize/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupGetIt();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  JournalsModelView _journalsModelView = getIt.get<JournalsModelView>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      // create: (_) => JournalsModelView(dbService: _databaseService),
      value: _journalsModelView,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Color(0xFFF6C791),
          canvasColor: Colors.white,
          textSelectionColor: Color(0xFFF6C791),
          cursorColor: Color(0xFFF6C791),
          indicatorColor: Color(0xFFF6C791),
          textSelectionHandleColor: Color(0xFFF6C791),
        ),
        title: "Journalize",
        home: HomePage(),
      ),
    );
  }
}
