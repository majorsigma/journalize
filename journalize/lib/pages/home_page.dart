import 'package:flutter/material.dart';
import 'package:journalize/pages/add_edit_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return getScaffoldWidget();
  }

  Scaffold getScaffoldWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journals"),
        centerTitle: true,
        elevation: 16,
      ),
      body: ListView(),
      bottomNavigationBar: buildBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: "What's on your mind?",
        child: Icon(Icons.add),
        onPressed: () {
          print("Open add/edit page");
          Navigator.of(context).pushNamed("/add_edit_page");
          print("Configuration is: ${context.findRenderObject()}");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      child: Padding(padding: const EdgeInsets.all(24.0)),
      shape: CircularNotchedRectangle(),
      color: Colors.blue,
    );
  }
}
