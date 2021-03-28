import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/pages/add_page.dart';
import 'package:journalize/pages/edit_page.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  DateTime _selectedDate;

  int _currentPage = 0;
  List<String> _pageTitles = ["Home", "Calendar"];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
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
        if (valueSelected == MenuAction.clear_all_entries) {
          // show a dialogue that ask user if he/she wants to delete all entries or not
          var result = showAlertDialog(context, "Delete",
              "Are you sure you want to DELETE all entries?");
          result.then((value) {
            if (value == true) getJournalModelView().removeAllJournals();
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
      PopupMenuItem<CurrentThemeMode>(
        child: getJournalModelView().currentThemeMode == CurrentThemeMode.dark
            ? Text("Toggle Light Mode")
            : Text("Toggle Dark Mode"),
        value: getJournalModelView().currentThemeMode, // value: ,
      ),
      PopupMenuItem<MenuAction>(
        child: Text("Clear All Entries"),
        value: MenuAction.clear_all_entries,
      ),
    ];
  }

  Widget getPage(int index, JournalsModelView modelView) {
    Future<List<Journal>> journals = modelView.getSortedJournalEntries();
    List<Widget> pageList = [
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
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).accentColor.withOpacity(.6),
              ),
              itemBuilder: (context, index) {
                return createDismissbleJournalItem(snapshot, index, context);
              },
            );
        },
      ),
      buildCalendarView(),
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
              Icon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(width: 10),
              Text(
                "Delete",
                style: TextStyle(fontSize: 16, color: Colors.white),
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
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 10),
              Icon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: 15,
              ),
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

  Widget buildCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Today: " + DateFormat.yMMMd().format(DateTime.now()),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8),
          child: Consumer(
            builder: (_, JournalsModelView model, __) =>
                FutureBuilder<Map<DateTime, List<Journal>>>(
              future: model.getCalendarEvents(),
              builder: (context, snapshot) => TableCalendar(
                rowHeight: 40,
                events: snapshot.data,
                onDaySelected: (selectedDate, _, __) async {
                  _selectedDate = selectedDate;
                  if (await getJournalModelView()
                      .isThereAnEntryOn(selectedDate)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Center(
                                child: Text(
                                    "Entries for ${DateFormat.yMMMd().format(selectedDate)}"),
                              ),
                              automaticallyImplyLeading: false,
                            ),
                            body: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FutureBuilder<List<Journal>>(
                                future: model.getEntriesOn(selectedDate),
                                builder: (context,
                                    AsyncSnapshot<List<Journal>> snapshot) {
                                  if (!snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else
                                    return ListView.separated(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) =>
                                          createDismissbleJournalItem(
                                              snapshot, index, context),
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                              color:
                                                  Theme.of(context).accentColor),
                                    );
                                },
                              ),
                            ),
                            floatingActionButton: FloatingActionButton(
                                child: Icon(FontAwesomeIcons.pen, color: Colors.white,),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddPage(dateOfEntry: _selectedDate),
                                    ),
                                  );
                                },
                                tooltip: "Add an entry on this date",
                                ),
                          );
                        },
                      ),
                    );
                  } else {
                    print("No entry for the selected day");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddPage(
                          dateOfEntry: selectedDate,
                        ),
                      ),
                    );
                  }
                },
                calendarController: _calendarController,
                headerVisible: false,
                calendarStyle: CalendarStyle(
                  selectedColor: Theme.of(context).accentColor,
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                  outsideWeekendStyle:
                      TextStyle(color: Colors.black.withOpacity(.40)),
                  todayColor: Colors.black,
                  markersColor: Colors.black,
                  contentPadding: EdgeInsets.zero,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
            ),
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
              GestureDetector(
                child: Text(
                  "See All",
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline6
                          .color
                          .withOpacity(.60)),
                ),
                onTap: () {
                  setState(() {
                    _currentPage = 0;
                    // getJournalModelView().getCalendarEventsDeprecated();
                  });
                },
              ),
            ],
          ),
        ),
        buildExpandedWidget()
      ],
    );
  }

  Expanded buildExpandedWidget() {
    return Expanded(
      child: FutureBuilder(
        future: getJournalModelView().getRecentJournalEntry(),
        builder: (BuildContext context, AsyncSnapshot<List<Journal>> snapshot) {
          if (!snapshot.hasData)
            // return Center(child: CircularProgressIndicator());
            return Center(child: Text("No Recent Entry"));
          else
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, int) => SizedBox(
                height: 8,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(10)),
                        color: Theme.of(context).accentColor.withOpacity(.3),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      height: 70,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat.yMMMEd()
                              .add_jm()
                              .format(snapshot.data[index].editDate)),
                          Text(
                            snapshot.data[index].title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            journal: snapshot.data[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
        },
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
            label: "  Home"),
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
