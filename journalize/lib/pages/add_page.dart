import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  DateTime todaysDate;

  @override
  void initState() {
    todaysDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Write",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color.withOpacity(.30),
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel_sharp,
              size: 30,
              color:
                  Theme.of(context).textTheme.headline6.color.withOpacity(.30),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.url,
                maxLines: 1,
                style: TextStyle(fontSize: 18),
                autocorrect: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a title to this entry"),
              ),
              // SizedBox(height: ),
              Text(
                "Story",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 18),
                  autocorrect: true,
                  textInputAction: TextInputAction.newline,
                  maxLines: 1000,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write something",
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).accentColor,
                    // highlightColor: Theme.of(context).accentColor,
                    highlightedBorderColor: Theme.of(context).accentColor,
                    textColor: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      print("Raised Button Pressed");
                    },
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
