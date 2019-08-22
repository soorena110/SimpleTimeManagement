import 'package:time_river/Database/Tables/OnceTaskTable.dart';

import 'Provider.dart';

var provider = Provider();

databaseInit() async {
  OnceTaskTable.init(provider);
  await provider.open();
}

databaseClose() async {
  await provider.close();
}

databaseOpen() async {
  await provider.open();
}