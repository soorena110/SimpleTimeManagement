import 'Provider.dart';
import 'TaskTable.dart';

databaseInit(){
  var provider = Provider();
  TaskTable.addTable(provider);
}