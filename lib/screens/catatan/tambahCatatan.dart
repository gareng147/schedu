import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahCatatanPage extends StatefulWidget {
  final String userId;

  TambahCatatanPage({required this.userId});

  @override
  _TambahCatatanPageState createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final TextEditingController _isiController = TextEditingController();
  bool _isLoading = false;

  void _simpanCatatan() async {
    final isi = _isiController.text.trim();

    if (isi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Catatan tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('catatan')
          .add({
        'isi': isi,
        'waktu': Timestamp.now(),
      });

      Navigator.pop(context); // kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan catatan")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Catatan"),
        backgroundColor: Color(0xFF2FD4DB),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _isiController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Tulis catatan di sini...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
             Center(
                    child: ElevatedButton(
                      onPressed: _isLoading? null : _simpanCatatan,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2FD4DB)),
                      child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
