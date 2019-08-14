import 'Provider.dart';
import 'TaskTable.dart';

var provider = Provider();

databaseInit(){
  TaskTable.addTable(provider);
  provider.open();
}

databaseClose(){
  provider.close();
}