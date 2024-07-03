import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _notificationsEnabled = false;

  static bool get notificationsEnabled {
    return _notificationsEnabled;
  }

  static Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      _notificationsEnabled = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();
      _notificationsEnabled = grantedNotificationPermission ?? false;
      _notificationsEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> init() async {
    await requestPermissions();

    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings("image");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );
    final initNotification = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initNotification,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // static Future<void> periodicallyShowNotification({
  //   required String title,
  //   required String body,
  //   required Timestamp timestamp,
  // }) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     channelDescription: 'your_channel_description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   // Calculate the initial notification time
  //   final initialTime = timestamp.toDate();
  //   final currentTime = DateTime.now();
  //   final duration = initialTime.difference(currentTime);

  //   if (-duration.inMinutes >= 1) {
  //     await _flutterLocalNotificationsPlugin.periodicallyShow(
  //       0,
  //       title,
  //       body,
  //       RepeatInterval.everyMinute,
  //       platformChannelSpecifics,
  //     );
  //   } else {
  //     print("Duration must be at least one minute or more ${duration.inMinutes}");
  //   }
  // }

  static void showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      "GoodChannelId",
      "GoodChannelName",
      sound: RawResourceAndroidNotificationSound("notification"),
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: "ticker",
      // actions: <AndroidNotificationAction>[
      //   AndroidNotificationAction('id_1', 'Action 1'),
      //   AndroidNotificationAction('id_2', 'Action 2'),
      //   AndroidNotificationAction('id_3', 'Action 3'),
      // ],
    );
    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
      categoryIdentifier: "demoCategory",
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      // payload: "Hello World",
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Match only the time component
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    print("on background tap");
  }
}
