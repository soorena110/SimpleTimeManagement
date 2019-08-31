import 'package:time_river/Database/Provider.dart';

databaseClose() async {
  await databaseProvider.close();
}

databaseOpen() async {
  await databaseProvider.open();
}
