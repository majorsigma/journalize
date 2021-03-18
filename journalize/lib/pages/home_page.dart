import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/pages/add_page.dart';
import 'package:journalize/pages/edit_page.dart';
import 'package:journalize/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  DateTime _currentDate;
  int _currentPage = 1;
  List<String> _pageTitles = ["Home", "Calendar"];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _currentDate = DateTime.now();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getScaffoldWidget();
  }

  Scaffold getScaffoldWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_pageTitles[_currentPage]}",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color.withOpacity(.30),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [createPopupMenu(context)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<JournalsModelView>(
                builder: (_, modelView, ___) =>
                    getPage(_currentPage, modelView),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: createButtomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddPage();
          }));
        },
      ),
    );
  }

  PopupMenuButton createPopupMenu(BuildContext context) {
    return PopupMenuButton<dynamic>(
      padding: EdgeInsets.zero,
      onSelected: (valueSelected) {
        if (valueSelected == MenuAction.font_family_change) {
          print("Font change yet to be implemented");
        } else if (valueSelected == MenuAction.font_size_change) {
          print("Font size change yet to be implemented");
        } else if (valueSelected == MenuAction.clear_all_entries) {
          // show a dialogue that ask user if he/she wants to delete all entries or not
          var result = showAlertDialog(context, "Delete",
              "Are you sure you want to DELETE all entries?");
          result.then((value) {
            if (value == true)
              getJournalModelView().removeAllJournals(); 
          });
        } else if (valueSelected == CurrentThemeMode.dark ||
            valueSelected == CurrentThemeMode.light) {
          getJournalModelView().toggleThemeMode();
        }
      },
      itemBuilder: (context) {
        return getMenuItemList();
      },
    );
  }

  List<PopupMenuEntry> getMenuItemList() {
    return [
      PopupMenuItem<MenuAction>(
        child: Text("Change Font Family"),
        value: MenuAction.font_family_change,
      ),
      PopupMenuItem<MenuAction>(
        child: Text("Change Font Size"),
        value: MenuAction.font_size_change,
      ),
      PopupMenuItem<MenuAction>(
        child: Text("Clear All Entries"),
        value: MenuAction.clear_all_entries,
      ),
      PopupMenuItem<CurrentThemeMode>(
        child: getJournalModelView().currentThemeMode == CurrentThemeMode.dark
            ? Text("Toggle Light Mode")
            : Text("Toggle Dark Mode"),
        value: getJournalModelView().currentThemeMode, // value: ,
      ),
    ];
  }

  JournalsModelView getJournalModelView() {
    return getIt.get<JournalsModelView>();
  }

  Widget getPage(int index, JournalsModelView modelView) {
    // Future<JournalList> journals = modelView.readJournalListFromFile();
    Future<List<Journal>> journals = modelView.getSortedJournalEntries();
    List<Widget> pageList = [
      // SingleChildScrollView(
      FutureBuilder(
        future: journals,
        builder: (context, AsyncSnapshot<List<Journal>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text("No journal entry yet."),
            );
          } else
            return ListView.separated(
              // reverse: true,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(
                // thickness: 2,
                color: Theme.of(context).accentColor.withOpacity(.6),
              ),
              itemBuilder: (context, index) {
                return createDismissbleJournalItem(snapshot, index, context);
              },
            );
        },
      ),
      // ),
      buildCalendarSingleChildScrollView(),
    ];
    return pageList[index];
  }

  Dismissible createDismissbleJournalItem(
      AsyncSnapshot<List<Journal>> snapshot, int index, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      child: GestureDetector(
          child: ListTile(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.MMM().format(snapshot.data[index].editDate),
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Theme.of(context).accentColor),
                ),
                Text(DateFormat.d().format(snapshot.data[index].editDate)),
              ],
            ),
            title: Text(
              snapshot.data[index].title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              snapshot.data[index].content,
              maxLines: 3,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(snapshot.data[index].editDate)
                      .format(context),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditPage(
                journal: snapshot.data[index],
                index: index,
              );
            }));
          }),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.trash, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Delete",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Delete",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.trash, color: Colors.white),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        var result = showAlertDialog(
            context, "Delete", "Are you sure you want to delete this entry?");
        result.then((value) {
          if (value == true) {
            getJournalModelView().removeJournal(snapshot.data[index]);
          } else {
            getJournalModelView().notifyListeners();
          }
        });
      },
    );
  }

  Future<bool> showAlertDialog(
      BuildContext context, String title, String message) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              OutlineButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                color: Theme.of(context).accentColor,
                highlightedBorderColor: Theme.of(context).accentColor,
                textColor: Theme.of(context).accentColor,
              ),
              RaisedButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  SingleChildScrollView buildCalendarSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Today: ${_currentDate.toIso8601String().substring(0, 10)}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          TableCalendar(
            rowHeight: 40,
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(
              selectedColor: Theme.of(context).accentColor,
              weekendStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              outsideWeekendStyle:
                  TextStyle(color: Colors.black.withOpacity(.40)),
              todayColor: Colors.green,
              markersColor: Colors.black,
              contentPadding: EdgeInsets.zero,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Entries",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline6
                          .color
                          .withOpacity(.60)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              createFirstEntry(),
              SizedBox(height: 10),
              createSecondEntry(),
              SizedBox(height: 10),
              createThirdEntry(),
            ],
          ),
        ],
      ),
    );
  }

  Container createThirdEntry() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "10/03/2018",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context)
                    .textTheme
                    .headline4
                    .color
                    .withOpacity(.60),
              ),
            ),
            Text(
              "I got promoted",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      // padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        color: Theme.of(context).accentColor.withOpacity(.30),
      ),
    );
  }

  Container createSecondEntry() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "10/03/2018",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context)
                    .textTheme
                    .headline4
                    .color
                    .withOpacity(.60),
              ),
            ),
            Text(
              "I got promoted",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      // padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        color: Theme.of(context).accentColor.withOpacity(.30),
      ),
    );
  }

  Container createFirstEntry() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "13/03/2018",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context)
                      .textTheme
                      .headline4
                      .color
                      .withOpacity(.60),
                ),
              ),
              Text(
                "Full-day Hike in the Mountain",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ]),
      ),
      // padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        color: Theme.of(context).accentColor.withOpacity(.30),
      ),
    );
  }

  BottomNavigationBar createButtomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.home,
              size: 25,
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.calendar,
              size: 25,
            ),
            label: "Calendar"),
      ],
    );
  }
}
