import 'package:get_it/get_it.dart';
import 'package:journalize/modelviews/journals_modelview.dart';

import 'database_service.dart';

final GetIt getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  getIt.registerSingleton<JournalsModelView>(JournalsModelView(dbService: getIt.get<DatabaseService>()));
}
