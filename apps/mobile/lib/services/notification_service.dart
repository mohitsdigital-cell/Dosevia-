import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local notification scheduling for medicine reminders
/// (Blueprint Parts 26.2, 27).
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Schedules a repeating daily reminder at [hour]:[minute].
  /// Each (medicineId, slot) pair maps to a stable notification id
  /// so re-scheduling replaces instead of duplicating (Blueprint 27).
  Future<void> scheduleDailyReminder({
    required int notificationId,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'dosevia_medicine_reminders',
      'Medicine reminders',
      channelDescription: 'Daily medicine dose reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      _nextInstanceOf(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel(int notificationId) async {
    await initialize();
    await _plugin.cancel(notificationId);
  }

  DateTime _nextInstanceOf(int hour, int minute) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
