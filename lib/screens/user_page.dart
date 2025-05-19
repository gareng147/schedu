import 'package:flutter/material.dart';
import 'package:schedu/screens/awal/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit/edit_profile.dart';
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = '';
  String nim = '';
  String noWa = '';
  String email = '';
  String webStudent = '';


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          username = data['nama'] ?? '';
          nim = data['nim'] ?? '-';
          noWa = data['no_hp'] ?? '-';
          email = data['email'] ?? '-';
          webStudent = data['web_student'] ?? '-';
        });
      }
    }
  }


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

  void _goToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfile()));
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = username.isNotEmpty ? username[0].toUpperCase() : "?";

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24.0, bottom: 100),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF2FD4DB),
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                username.isNotEmpty ? username : "Loading...",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.badge, "NIM: $nim"),
              _buildInfoCard(Icons.phone, "No WA: $noWa"),
              _buildInfoCard(Icons.email, "Email: $email"),
              _buildInfoCard(Icons.school, "Web Student: $webStudent"),

              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2FD4DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),

        
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfile()));
            },
            backgroundColor: const Color(0xFF2FD4DB),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F6F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
