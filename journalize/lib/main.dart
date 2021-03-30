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
  void initState() {
    super.initState();
    // setupGetIt();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JournalsModelView>.value(
          value: _journalsModelView,
        ),
      ],
      child: Consumer<JournalsModelView>(
        builder: (_, modelView, __) => MaterialApp(
          themeMode: _getJournalsModelView().getSelectedTheme(),
          debugShowCheckedModeBanner: false,
          theme: getIt.get<JournalTheme>().lightTheme,
          darkTheme: getIt.get<JournalTheme>().darkTheme,
          title: "Journalize",
          home: HomePage(),
        ),
      ),
    );
  }
}



JournalsModelView _getJournalsModelView() {
  return getIt.get<JournalsModelView>();
}
