import 'package:flutter/material.dart';
import 'dart:async';
import 'package:schedu/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'package:schedu/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplasgScreenState();
}

class _SplasgScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
    late AnimationController _controller;
    late Animation<double> _animation;
  
 @override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

  _checkLogin();
}

Future<void> _checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');

  await Future.delayed(const Duration(seconds: 2)); 

  if (username != null && username.isNotEmpty) {
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  } else {
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>
            [
            Color(0xFF2FD4DB),
            Color(0xFF0A959A)
            ],begin: Alignment.topCenter,end: Alignment.bottomCenter
          )
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            const Text(
              "Schedu",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
