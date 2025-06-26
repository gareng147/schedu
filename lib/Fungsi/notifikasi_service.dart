import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedu/main.dart'; // akses instance global
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission();
    String? token = await _messaging.getToken();
    print("🔑 FCM Token: $token");
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel_id',
              'Default Channel',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );

      }
    });





    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📥 Notifikasi dibuka: ${message.data}');
      // Arahkan ke halaman kalau kamu mau
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fcmToken': newToken,
        });
        print("🔁 Token diperbarui: $newToken");
      }
    });

  }

  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
    print("🗑️ FCM Token dihapus");
  }

static Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledTime,
}) async {
  tz.initializeTimeZones();

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel_id',
        'Default Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );
}

static Future<void> scheduleJadwalKuliahWeekly({
  required String title,
  required int weekday, // 1 = Senin ... 7 = Minggu
  required TimeOfDay time,
  required int pengingatMenit,
}) async {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = _nextInstanceOfWeekday(weekday, time);

  // Kurangi waktu pengingat
  scheduledDate = scheduledDate.subtract(Duration(minutes: pengingatMenit));

  await flutterLocalNotificationsPlugin.zonedSchedule(
    scheduledDate.hashCode,
    title,
    'Pengingat jadwal: $title',
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel_id',
        'Default Channel',
        channelDescription: 'Pengingat Jadwal Mingguan',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

static tz.TZDateTime _nextInstanceOfWeekday(int weekday, TimeOfDay time) {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  // Cari hari berikutnya jika bukan hari yang dituju atau waktunya sudah lewat
  while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}




static Future<Map<String, dynamic>> getUserNotificationPrefs() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};

  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.data() ?? {};
}




}
