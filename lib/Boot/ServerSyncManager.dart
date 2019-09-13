import 'package:shared_preferences/shared_preferences.dart';

class ServerSyncManager {
  static String lastSyncDateTime;

  static getLastSyncDateTime() async {
    if (lastSyncDateTime == null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      lastSyncDateTime =
          pref.getString('lastSyncDateTime') ?? '1398/06/01 00:00';
    }
    return lastSyncDateTime;
  }

  static setLastSyncDateTime(String dateTime) async {
    if (dateTime == lastSyncDateTime) return true;

    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString('lastSyncDateTime', dateTime);
  }

  static sync() async {
    final lastUpdate = await getLastSyncDateTime();

//    final tasks = await TaskService.getAllTasksUpdatedAfter(lastUpdate);
//    await http.post('http://time.sainapedia.ir/tasks',
//        body: jsonEncode(tasks));
//
//    final ticks = await TaskService.getAllTicksUpdatedAfter(lastUpdate);
//    await http.post('http://time.sainapedia.ir/ticks', body: jsonEncode(tasks));
//
//    final taskHttpResponse = await http
//        .get('http://time.sainapedia.ir/tasks?fromLastUpdate=$lastUpdate');
//    final fetchedTasks = json.decode(taskHttpResponse.body);
//
//    final tickHttpResponse = await http
//        .get('http://time.sainapedia.ir/ticks?fromLastUpdate=$lastUpdate');
//    final fetchedTicks = json.decode(tickHttpResponse.body);

//    await setLastSyncDateTime(getNow());
  }
}
