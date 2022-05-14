
import 'package:intl/intl.dart';

final DateTime today = DateTime.now();

String getTodayDay(){
  return DateFormat('d').format(today);
}

String getTodayMonth(){
  return DateFormat('MMMM', 'es').format(today);
}

String getTodayWeekDay(){
  return DateFormat('EEEE', 'es').format(today);
}
