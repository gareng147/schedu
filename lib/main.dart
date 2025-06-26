import 'package:flutter/material.dart';
import 'package:schedu/Fungsi/notifikasi_service.dart';
import 'package:schedu/screens/awal/login.dart';
import 'package:schedu/screens/awal/splash.dart';
import 'package:schedu/widgets/custom_appbar.dart';
import 'package:schedu/screens/homepage.dart';
import 'package:schedu/screens/jadwal_page.dart';
import 'package:schedu/screens/tugas_page.dart';
import 'package:schedu/screens/user_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;





final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}


Future<void> initializeTimeZone() async {
  tz.initializeTimeZones();

  // Default ke Asia/Jakarta agar tidak error meski tidak pakai native_timezone
  const String defaultTimeZone = 'Asia/Jakarta';

  tz.setLocalLocation(tz.getLocation(defaultTimeZone));
}


Future<void> simpanTokenKeFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final token = await FirebaseMessaging.instance.getToken();
  if (token == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({'fcmToken': token});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Tambahkan ini:
  await initializeTimeZone(); // <-- Ini WAJIB untuk notifikasi berdasarkan waktu lokal

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(const AndroidNotificationChannel(
      'default_channel_id',
      'Default Channel',
      description: 'Digunakan untuk notifikasi penting',
      importance: Importance.high,
    ));

  await NotificationService.init();

  runApp(const Schedu());
}






class Schedu extends StatelessWidget {
  const Schedu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<String> appBarTitles = [
    "Home",
    "Jadwal Kuliah",
    "Tugas Kuliah",
    "Profil User",
  ];

  final List<Widget> pages = [
    const HomePage(),
    const JadwalKelasPage(),
    const TugasUjianPage(),
    const UserPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [const CustomAppBar(), Expanded(child: pages[selectedIndex])],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: const Color(0xFF2FD4DB),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
