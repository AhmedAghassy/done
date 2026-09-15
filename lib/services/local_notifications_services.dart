import 'dart:developer';

import 'package:done/constants/constants.dart';
import 'package:done/models/task_model.dart';
import 'package:done/ui/pages/notification_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsServices {
  LocalNotificationsServices._();

  static final LocalNotificationsServices instance =
      LocalNotificationsServices._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> requestAndroidPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> requestIOSPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(
          sound: true,
          alert: true,
          badge: true,
          carPlay: true,
        );
  }

  Future<void> requestMacOSPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(sound: true, alert: true, badge: true);
  }

  Future<void> initNotifications() async {
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');

    const IOSInitializationSettings iosSettings = IOSInitializationSettings(
      requestCarPlayPermission: true,
    );

    const DarwinInitializationSettings macSettings =
        DarwinInitializationSettings();

    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const WindowsInitializationSettings windowsSettings =
        WindowsInitializationSettings(
          appName: 'Done',
          appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
          guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macSettings,
      linux: linuxSettings,
      windows: windowsSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      //await Get.to(() => NotificationPage(payload: payload));
      selectNotificationSubject.add(payload);
    }
  }

  Future<void> displayNotification({required TaskModel task}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'tasks_channel',
          'Tasks Notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: 'app_icon',
          category: AndroidNotificationCategory.reminder,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const LinuxNotificationDetails linuxDetails = LinuxNotificationDetails();

    const WindowsNotificationDetails windowsDetails =
        WindowsNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    await _notificationsPlugin.show(
      id: task.id!,
      title: task.title,
      body: task.note,
      notificationDetails: details,
      payload:
          '${task.title}|${task.note}|${task.date}|${task.startTime}|${task.endTime}',
    );
  }

  Future<void> scheduledNotification({
    required int hour,
    required int minutes,
    required TaskModel task,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: 'app_icon',
          category: AndroidNotificationCategory.reminder,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const LinuxNotificationDetails linuxDetails = LinuxNotificationDetails();

    const WindowsNotificationDetails windowsDetails =
        WindowsNotificationDetails();

    NotificationDetails details = const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id: task.id!,
      scheduledDate: _nextInstanceOfTenAM(
        hour,
        minutes,
        task.remind,
        task.repeat,
        task.date,
      ),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: task.title,
      body: task.note,
      payload:
          '${task.title}|${task.note}|${task.date}|${task.startTime}|${task.endTime}',
      matchDateTimeComponents: _timeComponents(task.repeat),
    );
  }

  DateTimeComponents? _timeComponents(String repeat) {
    if (repeat == Constants.dailyKey) {
      return DateTimeComponents.time;
    }
    if (repeat == Constants.weeklyKey) {
      return DateTimeComponents.dayOfWeekAndTime;
    }
    if (repeat == Constants.monthlyKey) {
      return DateTimeComponents.dayOfMonthAndTime;
    }
    return null;
  }

  tz.TZDateTime _nextInstanceOfTenAM(
    int hour,
    int minutes,
    int remind,
    String repeat,
    String date,
  ) {
    final tz.Location localLocation = tz.local;
    final tz.TZDateTime now = tz.TZDateTime.now(localLocation);
    final DateTime _formattedSelectedDate = intl.DateFormat(
      'dd/MM/yyyy',
      'en',
    ).parse(date);
    final tz.TZDateTime _formattedSelectedLocalDate = tz.TZDateTime.from(
      _formattedSelectedDate,
      localLocation,
    );
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      localLocation,
      _formattedSelectedLocalDate.year,
      _formattedSelectedLocalDate.month,
      _formattedSelectedLocalDate.day,
      hour,
      minutes,
    );

    log('Now: $now');
    log('ScheduledDate: $scheduledDate');

    scheduledDate = _setupRemindTasks(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = _setupRepeatTasks(
        repeat,
        scheduledDate,
        now,
        hour,
        minutes,
        localLocation,
        _formattedSelectedLocalDate,
      );
      scheduledDate = _setupRemindTasks(remind, scheduledDate);
    }

    log('Next scheduledDate: $scheduledDate');
    return scheduledDate;
  }

  tz.TZDateTime _setupRemindTasks(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  tz.TZDateTime _setupRepeatTasks(
    String repeat,
    tz.TZDateTime scheduledDate,
    tz.TZDateTime now,
    int hour,
    int minutes,
    tz.Location localLocation,
    tz.TZDateTime _selectedDate,
  ) {
    if (repeat == Constants.dailyKey) {
      scheduledDate = tz.TZDateTime(
        localLocation,
        now.year,
        now.month,
        (_selectedDate.day) + 1,
        hour,
        minutes,
      );
    }
    if (repeat == Constants.weeklyKey) {
      scheduledDate = tz.TZDateTime(
        localLocation,
        now.year,
        now.month,
        (_selectedDate.day) + 7,
        hour,
        minutes,
      );
    }
    if (repeat == Constants.monthlyKey) {
      scheduledDate = tz.TZDateTime(
        localLocation,
        now.year,
        (_selectedDate.month) + 1,
        _selectedDate.day,
        hour,
        minutes,
      );
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => NotificationPage(payload: payload));
    });
  }

  Future<void> cancelNotification(TaskModel task) async {
    await _notificationsPlugin.cancel(id: task.id!);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
