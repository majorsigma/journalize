import 'package:flutter/material.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/pages/home_page.dart';
import 'package:journalize/services/service_locator.dart';
import 'package:journalize/utils/themes.dart';
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
      child: Consumer<JournalsModelView>(
        builder: (_, modelView, __) => MaterialApp(
          themeMode: getSelectedTheme(),
          debugShowCheckedModeBanner: false,
          theme: getIt.get<JournalTheme>().lightTheme,
          darkTheme: getIt.get<JournalTheme>().darkTheme,
          title: "Journalize",
          home: HomePage(),
        ),
      ),
    );
  }

  ThemeMode getSelectedTheme() {
    var currentThemeMode = _getJournalsModelView().currentThemeMode;

    if (currentThemeMode == CurrentThemeMode.dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  JournalsModelView _getJournalsModelView() {
    return getIt.get<JournalsModelView>();
  }
}
