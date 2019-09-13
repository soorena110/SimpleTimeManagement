import 'package:time_river/Database/Provider.dart';

import 'Tables/Tasks/TaskTable.dart';
import 'Tables/Ticks/TickBaseTable.dart';

databaseClose() async {
  await databaseProvider.close();
}

databaseOpen() async {
  taskTable.initTable();
  tickTable.initTable();

  await databaseProvider.open();
}
