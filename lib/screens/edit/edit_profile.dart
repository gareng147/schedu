import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:schedu/widgets/bannerad.dart';


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

  String? _base64Image;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
        _base64Image = data['photo_base64'];

        
      });
    }
  }
 


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Kompres file
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800, // atur sesuai kebutuhan
        minHeight: 800,
        quality: 70, // 70% kualitas
      );

      if (compressedBytes == null || compressedBytes.length > 1048576) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran gambar terlalu besar atau gagal dikompres (maks 1MB).'),
          ),
        );
        return;
      }

      setState(() {
        _base64Image = base64Encode(compressedBytes);
        _imageFile = file;
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
    

    if ([nama, nim, nohp].any((e) => e.isEmpty)) {
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
      'photo_base64': _base64Image, 
     
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF2FD4DB),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : _base64Image != null
                            ? MemoryImage(base64Decode(_base64Image!))
                            : null,
                    child: (_imageFile == null && _base64Image == null)
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, size: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField("Nama", namaController),
            _buildTextField("NIM/NIS", nimController),
            _buildTextField("No WA", noController),
            _buildTextField("Email", emailController,readOnly: true),
            
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
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 16), // space ke bawah layar
        child: BannerAdWidget(),
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
