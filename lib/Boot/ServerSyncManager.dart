import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_river/Database/Tables/TaskTable.dart';
import 'package:time_river/Database/Tables/TickTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Services/TaskService.dart';

const headers = const {
  "Accept": "application/json",
  "content-type": "application/json"
};

class ServerSyncManager {
  static String lastSyncDateTime;

  static _getLastSyncDateTime() async {
    if (lastSyncDateTime == null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      lastSyncDateTime =
          pref.getString('lastSyncDateTime') ?? '1398/06/01 00:00';
    }
    return lastSyncDateTime;
  }

  static _setLastSyncDateTime(String dateTime) async {
    if (dateTime == lastSyncDateTime) return true;

    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString('lastSyncDateTime', dateTime);
  }

  static sync() async {
    try {
      await _fetchServerNewTasks();
      await _sendDatasToServer();
      await _setLastSyncDateTime(getNow());
    } catch (e) {
      print(e);
    }
  }

  static _sendDatasToServer() async {
    final lastUpdate = await _getLastSyncDateTime();

    final tasks = await TaskService.getAllTasksUpdatedAfter(lastUpdate);
    await http.post('http://time.sainapedia.ir/api/tasks',
        headers: headers, body: jsonEncode(tasks.toList()));

    final ticks = await TaskService.getAllTicksUpdatedAfter(lastUpdate);
    await http.post('http://time.sainapedia.ir/api/ticks',
        headers: headers, body: jsonEncode(ticks.toList()));
  }

  static _fetchServerNewTasks() async {
    final lastUpdate = await _getLastSyncDateTime();

    final taskHttpResponse = await http
        .get('http://time.sainapedia.ir/api/tasks?fromLastUpdate=$lastUpdate');
    final List<dynamic> fetchedTasks = json.decode(taskHttpResponse.body);
    await Future.wait(fetchedTasks.map((t) => taskTable.insertOrUpdate(t)));

    final tickHttpResponse = await http
        .get('http://time.sainapedia.ir/api/ticks?fromLastUpdate=$lastUpdate');
    final List<dynamic> fetchedTicks = json.decode(tickHttpResponse.body);
    await Future.wait(fetchedTicks.map((t) => tickTable.insertOrUpdate(t)));
  }
}
