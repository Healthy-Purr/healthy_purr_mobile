import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService{

  static final _notifications = FlutterLocalNotificationsPlugin();

  static final onNotifications = BehaviorSubject<String?>();

  static void cancel() async{
    await _notifications.cancelAll();
  }

  //WHEN APP IS CLOSED
  static Future init({bool initScheduled = true}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));

    await _notifications.initialize(
        settings,
        onSelectNotification: (payload) async {
          onNotifications.add(details!.payload);
        }
    );


  }


  static Future _notificationDetails() async {

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static void showBreakfastScheduledNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required Time time,
    required int day
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleWeekly(time, days: [day]),
          await _notificationDetails(),
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true
      );

  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now) ?
    scheduleDate.add(const Duration(days: 6)) : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}){
    tz.TZDateTime scheduleDate = _scheduleDaily(time);

    while (!days.contains(scheduleDate.weekday)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }
}