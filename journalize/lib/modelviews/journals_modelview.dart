import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/models/journal_list.dart';
import 'package:journalize/services/database_service.dart';

class JournalsModelView extends ChangeNotifier {
  DatabaseService dbService;
  CurrentThemeMode currentThemeMode = CurrentThemeMode.light;

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
    database.journalList.removeAt(index);
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
}

enum CurrentThemeMode { light, dark }

enum MenuAction { font_family_change, font_size_change, clear_all_entries }
