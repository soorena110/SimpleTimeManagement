import 'Provider.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';

import 'Tables/OnceTaskTickTable.dart';

var provider = Provider();

databaseInit() async {
  OnceTaskTable.init(provider);
  OnceTaskTickTable.init(provider);
  await provider.open();
}

databaseClose() async {
  await provider.close();
}

databaseOpen() async {
  await provider.open();
}
