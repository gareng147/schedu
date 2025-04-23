import 'package:flutter/material.dart';
import 'package:schedu/screens/login.dart';
import 'package:schedu/screens/splash.dart';
import 'package:schedu/widgets/custom_appbar.dart';
import 'package:schedu/screens/homepage.dart';
import 'package:schedu/screens/jadwal_page.dart';
import 'package:schedu/screens/tugas_page.dart';
import 'package:schedu/screens/user_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async{

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('🔥 Caught Flutter error: ${details.exception}');
    print('🔥 Stack trace:\n${details.stack}');
  };
  runApp(Schedu());
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
    "Profil User"
  ];

  final List<Widget> pages = [
    const HomePage(),
    const JadwalKelasPage(),
    const TugasUjianPage(),
    const UserPage()
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
        children: [
          const CustomAppBar(),
          Expanded(child: pages[selectedIndex]),
        ],
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












