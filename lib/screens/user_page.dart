import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // buat exit(0)
import 'package:flutter/services.dart'; // buat SystemNavigator.pop()

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Future<void> _logoutAndExit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus data login

    // Keluar dari aplikasi
    // Bisa pakai salah satu:
    // exit(0); atau SystemNavigator.pop();

    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
              _logoutAndExit(context); // Logout dan keluar
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
          backgroundColor: const Color.fromARGB(255, 0, 101, 101),
          foregroundColor: Colors.white,
        ),
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }
}
