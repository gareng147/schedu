import 'package:flutter/material.dart';
import 'package:schedu/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; 
import 'package:flutter/services.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Future<void> _logoutAndExit(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); 
      
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      print("Logout error: $e");
    }
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _logoutAndExit(context); 
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2FD4DB),
          foregroundColor: Colors.white,
        ),
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }
}
