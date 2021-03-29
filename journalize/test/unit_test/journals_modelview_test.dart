import 'package:flutter_test/flutter_test.dart';
import 'package:journalize/models/journal.dart';
import 'package:journalize/models/journal_list.dart';
import 'package:journalize/modelviews/journals_modelview.dart';
import 'package:journalize/services/database_service.dart';
import 'package:mockito/mockito.dart';

class DatabaseServiceMock extends Mock implements DatabaseService {}

void main() {
  List<Journal> listOfJournal = [];
  Journal journal = Journal(
      editDate: DateTime.now(),
      title: "This is just a test",
      content: "Body of the test");

  DatabaseServiceMock databaseServiceMock = DatabaseServiceMock();
  when(databaseServiceMock.readFromFile())
      .thenAnswer((_) async => '{"journalList": []}');

  JournalsModelView journalsModelView =
      new JournalsModelView(dbService: databaseServiceMock);

  // group();
  test(
    "Append journal to the empty listOfJournal",
    () {
      listOfJournal.add(journal);
      expect(listOfJournal.length, 1);
    },
  );

  test(
      "create a JournalList from the listOfJournal variable and then output json representation",
      () {
    JournalList journalList = JournalList(journalList: listOfJournal);
    print(journalList.toJson());
  });

  test(
      "read journals from file, create a journal, add it to JournalList object and print to console",
      () async {
    JournalList journalList = await journalsModelView.readJournalListFromFile();
    journalList.journalList.add(journal);
    print(journalList.toJson());
  });

  test("updates a previously saved journal entry", () {
    journalsModelView.updateJournal(
        journal: journal, index: 0, title: "Welcome of the updated");
    expect(journal.title, "Welcome of the updated");
  }, skip: true);
}
