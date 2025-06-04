import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LupapasswordPage extends StatefulWidget {
  const LupapasswordPage({super.key});

  @override
  State<LupapasswordPage> createState() => _LupapasswordState();
}

class _LupapasswordState extends State<LupapasswordPage> {
  @override
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim ke email.'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim email reset: $e')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Masukkan email akunmu untuk menerima link reset password.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text("Kirim Link Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
