import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/models/journal_list.dart';
import 'package:journalize/services/database_service.dart';

class JournalsModelView extends ChangeNotifier {
  DatabaseService dbService;

  JournalsModelView({this.dbService});

  Future<JournalList> readJournalListFromFile() async {
    String journalListJSON = await dbService.readFromFile();
    JournalList journalList =
        JournalList.fromJson(json: jsonDecode(journalListJSON));
    return journalList;
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
    dbService.writeToFile(jsonEncode(journalList.toJson()));
    notifyListeners();
  }

  void removeAllJournals() async {
    dbService.resetFileToDefault();
    notifyListeners();
  }
}
