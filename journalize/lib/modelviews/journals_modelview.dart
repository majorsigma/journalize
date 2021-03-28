import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/models/journal_list.dart';
import 'package:journalize/services/database_service.dart';
import 'package:journalize/services/service_locator.dart';

class JournalsModelView extends ChangeNotifier {
  DatabaseService dbService;
  CurrentThemeMode currentThemeMode = CurrentThemeMode.light;
  Map<DateTime, List<Journal>> calendarEvents = {};

  JournalsModelView({this.dbService});

  Future<JournalList> readJournalListFromFile() async {
    String journalListJSON = await dbService.readFromFile();
    JournalList database =
        JournalList.fromJson(json: jsonDecode(journalListJSON));

    return database;
  }

  Future<List<Journal>> getSortedJournalEntries() async {
    JournalList database = await readJournalListFromFile();
    database.journalList.sort(
        (journalA, journalB) => journalB.editDate.compareTo(journalA.editDate));

    return database.journalList;
  }

  void addJournal(Journal journal) async {
    JournalList journalList = await readJournalListFromFile();
    journalList.journalList.add(journal);
    dbService.writeToFile(jsonEncode(journalList.toJson()));
    notifyListeners();
  }

  void removeJournal(Journal journal) async {
    JournalList journalList = await readJournalListFromFile();
    journalList.journalList.remove(journal);
    dbService.resetFileToDefault();
    dbService.writeToFile(jsonEncode(journalList.toJson()));
    notifyListeners();
  }

  void updateJournal(
      {@required Journal journal,
      @required int index,
      String title,
      String content,
      DateTime editDate}) async {
    JournalList database = await readJournalListFromFile();
    database.journalList.remove(journal);
    Journal newJournal =
        Journal(title: title, content: content, editDate: editDate);
    database.journalList.add(newJournal);
    dbService.writeToFile(jsonEncode(database.toJson()));
    getSortedJournalEntries();
    notifyListeners();
  }

  void removeAllJournals() async {
    dbService.resetFileToDefault();
    getSortedJournalEntries();
    notifyListeners();
  }

  void toggleThemeMode() {
    if (currentThemeMode == CurrentThemeMode.light) {
      currentThemeMode = CurrentThemeMode.dark;
      notifyListeners();
    } else if (currentThemeMode == CurrentThemeMode.dark) {
      currentThemeMode = CurrentThemeMode.light;
      notifyListeners();
    }
  }

  Future<List<Journal>> getRecentJournalEntry() async {
    List<Journal> sortedJournalEntries =
        await getJournalModelView().getSortedJournalEntries();
    var recent = sortedJournalEntries.where((journal) {
      DateTime todaysDate = DateTime.now();
      DateTime removed2days = todaysDate.subtract(Duration(hours: 48));

      if (journal.editDate.compareTo(removed2days) < 0) {
        return false;
      } else {
        return true;
      }
    });

    return recent.toList();
  }

  Future<Map<DateTime, List<Journal>>> getCalendarEvents() async {
    Map<DateTime, List<Journal>> events = {};

    MapEntry<DateTime, List<Journal>> mapEntry = null;
    List<MapEntry<DateTime, List<Journal>>> mapEntryList = [];
    List<Journal> allJournalEntries =
        await getJournalModelView().getSortedJournalEntries();
    List<DateTime> listOfEventDate = await getListOfEventDates();

    listOfEventDate.forEach((eventDate) {
      mapEntry = MapEntry(
          eventDate,
          allJournalEntries.where((journal) {
            bool status;
            if (journal.editDate.year == eventDate.year &&
                journal.editDate.month == eventDate.month &&
                journal.editDate.day == eventDate.day) {
              status = true;
            } else
              status = false;

            return status;
          }).toList());
      mapEntryList.add(mapEntry);
      events.addEntries(mapEntryList);
      notifyListeners();
    });

    return events;
  }

  Future<List<DateTime>> getListOfEventDates() async {
    List<DateTime> listOfEventDate = [];
    List<Journal> allJournalEntries =
        await getJournalModelView().getSortedJournalEntries();

    DateTime eventDate;
    int day;
    int month;
    int year;
    for (int i = 0; i < allJournalEntries.length; i++) {
      day = allJournalEntries[i].editDate.day;
      month = allJournalEntries[i].editDate.month;
      year = allJournalEntries[i].editDate.year;
      eventDate = DateTime(year, month, day);

      if (!listOfEventDate.contains(eventDate)) {
        listOfEventDate.add(eventDate);
      }
    }

    return listOfEventDate;
  }

  Future<bool> isThereAnEntryOn(DateTime selectedDate) async {
    List<Journal> listOfJournal = await getSortedJournalEntries();
    bool status = false;
    listOfJournal.forEach((journal) {
      if (journal.editDate.year == selectedDate.year &&
          journal.editDate.month == selectedDate.month &&
          journal.editDate.day == selectedDate.day) {
        status = true;
        return status;
      }
    });
    return status;
  }

  Future<List<Journal>> getEntriesOn(DateTime selectedDate) async {
    List<Journal> listOfJournals =
        await getJournalModelView().getSortedJournalEntries();
    bool isThere = await getJournalModelView().isThereAnEntryOn(selectedDate);
    List<Journal> listForTheDay = [];
    if (isThere) {
      listForTheDay = listOfJournals.where((journal) {
        bool status = false;
        if (journal.editDate.year == selectedDate.year &&
            journal.editDate.month == selectedDate.month &&
            journal.editDate.day == selectedDate.day) {
          status = true;
          notifyListeners();
        } else {
          status = false;
          notifyListeners();
        }
        return status;
      }).toList();
    }
    return listForTheDay;
  }
}

// This function returns a singleton of JournalsModelView
JournalsModelView getJournalModelView() {
  return getIt.get<JournalsModelView>();
}

enum CurrentThemeMode { light, dark }

enum MenuAction { font_family_change, font_size_change, clear_all_entries }
