import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        namaController.text = data['nama'] ?? '';
        nimController.text = data['nim'] ?? '';
        noController.text = data['no_hp'] ?? '';
        emailController.text = data['email'] ?? '';
        webController.text = data['web'] ?? '';
      });
    }
  }

  Future<void> _simpanProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final nama = namaController.text;
    final nim = nimController.text;
    final nohp = noController.text;
    final email = emailController.text;
    final web = webController.text;

    if ([nama, nim, nohp, web].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    final data = {
      'nama': nama,
      'nim': nim,
      'no': nohp,
      'email': email,
      'web': web,
    };

    await FirebaseFirestore.instance.collection('users').doc(uid).set(data, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2FD4DB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nama", namaController),
            _buildTextField("NIM", nimController),
            _buildTextField("No WA", noController),
            _buildTextField("Email", emailController,readOnly: true),
            _buildTextField("Web Student", webController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _simpanProfile,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A959A)),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }


  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
