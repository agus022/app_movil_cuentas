import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import '../models/debt.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    await Permission.notification.request();

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleReminder(
    Debt debt,
  ) async {

    if (debt.reminderDays <= 0) return;

    final nextDate =
        debt.referenceDate.add(
      Duration(
        days: debt.reminderDays,
      ),
    );

    await _notifications.zonedSchedule(
      debt.id.hashCode,
      '💸 TOCA SOBREEE...',
      'TOCA PAGAR A ${debt.personName.toUpperCase()}, la cantidad de \$${debt.pendingAmount.toStringAsFixed(0)}',
      tz.TZDateTime.from(
        nextDate,
        tz.local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'debt_reminders',
          'Recordatorios de Deudas',
          channelDescription:
              'Notificaciones de pago',
          importance:
              Importance.max,
          priority:
              Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancelReminder(
    String debtId,
  ) async {

    await _notifications.cancel(
      debtId.hashCode,
    );
  }

  static Future<void> cancelAll() async {

    await _notifications.cancelAll();
  }
}