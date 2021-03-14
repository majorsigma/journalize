import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/models/journal_list.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _titleEditingController;
  TextEditingController _contentEditingController;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _contentEditingController = TextEditingController();
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
                controller: _titleEditingController,
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
                "Content",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Expanded(
                child: TextField(
                  controller: _contentEditingController,
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
                  Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        var title = _titleEditingController.text;
                        var content = _contentEditingController.text;

                        if (title.isEmpty || content.isEmpty) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Make sure you add text in both input fields"),
                              action: SnackBarAction(
                                label: "Okay",
                                onPressed: () => Scaffold.of(context)
                                    .removeCurrentSnackBar(),
                              ),
                            ),
                          );
                        } else {
                          Journal journal = Journal(
                              title: title,
                              content: content,
                              editDate: DateTime.now());

                          // Remove all entries in the database file
                          // Provider.of<JournalsModelView>(context, listen: false)
                          //     .removeAllJournals();
                          
                          Provider.of<JournalsModelView>(context, listen: false)
                              .addJournal(journal);
                          // Clear the contents of the fields and show that the record as been persisted successfully.
                          _titleEditingController.clear();
                          _contentEditingController.clear();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                              label: "Okay",
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            duration: Duration(seconds: 2),
                            content: Text(
                                "Your content has been saved successfully"),
                          ));
                          Navigator.of(context).pop();

                          Future<JournalList> data =
                              Provider.of<JournalsModelView>(context,
                                      listen: false)
                                  .readJournalListFromFile();
                          data.then((value) {
                            print(value.toJson());
                          });
                        }

                        // Remove journals here
                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
