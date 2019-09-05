import 'package:time_river/Database/Provider.dart';

import './Tables/MonthTaskTable.dart';
import './Tables/OnceTaskTable.dart';
import './Tables/WeekTaskTable.dart';

databaseClose() async {
  await databaseProvider.close();
}

databaseOpen() async {
  onceTaskTable.initTable();
  weekTaskTable.initTable();
  monthTaskTable.initTable();
  await databaseProvider.open();
}
