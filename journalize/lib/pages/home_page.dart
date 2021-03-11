import 'package:flutter/material.dart';
import 'package:journalize/pages/add_page.dart';
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.only(top: 5),
                  child: getPage(_currentPage),
                ),
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

  Widget getPage(int index) {
    List<Widget> pageList = [
      Container(),
      buildCalendarSingleChildScrollView(),
    ];
    return pageList[index];
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
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).accentColor,
      // unselectedItemColor: Colors.red,
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
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.calendar,
              size: 25,
            ),
            label: ""),
      ],
    );
  }
}
