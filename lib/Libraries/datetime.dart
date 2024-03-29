import 'package:shamsi_date/shamsi_date.dart';

String getNowDate() {
  return getJalaliOf(DateTime.now());
}

String getJalaliOf(DateTime datetime) {
  final j = Gregorian.fromDateTime(datetime).toJalali();
  final m = j.month.toString().padLeft(2, '0');
  final d = j.day.toString().padLeft(2, '0');
  return '${j.year}/$m/$d';
}

DateTime getGregorian(String jalali) {
  final jalaliParts = jalali.split('/').map((jp) => int.parse(jp)).toList();
  return Jalali(jalaliParts[0], jalaliParts[1], jalaliParts[2]).toDateTime();
}

String getNow() {
  final now = DateTime.now();
  final h = now.hour.toString().padLeft(2, '0');
  final m = now.minute.toString().padLeft(2, '0');
  return '${getNowDate()} $h:$m';
}

int compareDate(String d1, String d2) {
  return getDateDiff(d1, d2).inMilliseconds.sign;
}

int compareDateTime(String dt1, String dt2) {
  if (dt1 == dt2) return 0;
  if (dt1 == null) return 1;
  if (dt2 == null) return -1;

  return getDateTimeDiff(dt1, dt2).inMilliseconds.sign;
}

Duration getDateTimeDiff(String d1, String d2) {
  final dateDiff = getDateDiff(d1, d2);
  final timeDiff = getTimeDiff(d1.split(' ')[1], d2.split(' ')[1]);

  return Duration(
      microseconds: dateDiff.inMicroseconds + timeDiff.inMicroseconds);
}

Duration getDateDiff(String d1, String d2) {
  var date1 = convertStringToJalali(d1.split(' ')[0]).toDateTime();
  var date2 = convertStringToJalali(d2.split(' ')[0]).toDateTime();
  return date1.difference(date2);
}

Duration getTimeDiff(String t1, String t2) {
  var t1Parts = t1.split(':').map((p) => int.parse(p)).toList();
  var t2Parts = t2.split(':').map((p) => int.parse(p)).toList();
  var d1 = DateTime(0, 0, 0, t1Parts[0], t1Parts[1]);
  var d2 = DateTime(0, 0, 0, t2Parts[0], t2Parts[1]);

  return d1.difference(d2);
}

Jalali convertStringToJalali(String str) {
  var strParts = str.split('/').map((p) => int.parse(p)).toList();
  return Jalali(strParts[0], strParts[1], strParts[2]);
}

String getDiffrenceText(String dt1, String dt2) {
  final diff = getDateTimeDiff(dt1, dt2);

  final dayDiff = diff.inDays;
  if (dayDiff != 0)
    return dayDiff.abs().toString() + ' روز ' + (dayDiff > 0 ? 'بعد' : 'پیش');

  if (diff.inHours != 0)
    return diff.inHours.abs().toString() +
        ' ساعت ' +
        (diff.inHours > 0 ? 'بعد' : 'پیش');
  if (diff.inMinutes != 0)
    return diff.inMinutes.abs().toString() +
        ' دقیقه ' +
        (diff.inMinutes > 0 ? 'بعد' : 'پیش');
}

String convertDoubleTimeToString(double hm) {
  if (hm == null) return null;
  if (hm == null) return '';
  final h = hm.floor();
  final m = ((hm - h) * 60).round();

  var ret = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  return ret;
}

double convertStringTimeToDouble(String hm) {
  if (hm == null) return null;

  final parts = hm.split(':');
  final value = double.parse(parts[0]) + double.parse(parts[1]) / 60;
  return value;
}
