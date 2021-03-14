import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DatabaseService {
  String journalFile = "journalized_data.json";

  Future<String> get _localAppDirectory async {
    var directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localPathFile async {
    final String path = await _localAppDirectory;
    File localFile = File("$path/$journalFile");
    return localFile;
  }

  Future<File> writeToFile(String data) async {
    final fileLocation = await localPathFile;

    return fileLocation.writeAsString(data);
  }

  Future<String> readFromFile() async {
    final fileLocation = await localPathFile;

    try {
      if (!fileLocation.existsSync()) {
        print(
            "$fileLocation does not exist in the file system: ${fileLocation.absolute}");
        await fileLocation.writeAsString('{"journalList": []}');
      }

      return fileLocation.readAsString();
    } catch (e) {
      print("Error reading file from disk!!!");
    }
    return "";
  }

  void resetFileToDefault() async {
    final fileLocation = await localPathFile;
    fileLocation.delete();
  }
}
