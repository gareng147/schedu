import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedu/widgets/bannerad.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  bool notifikasiJadwal = true;
  bool notifikasiTugas = true;
  bool notifikasiUjian = true;
  int pengingatMenit = 60;

  @override
  void initState() {
    super.initState();
    _loadPengaturan();
  }

  Future<void> _loadPengaturan() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        notifikasiJadwal = data['notif_jadwal'] ?? true;
        notifikasiTugas = data['notif_tugas'] ?? true;
        notifikasiUjian = data['notif_ujian'] ?? true;
        pengingatMenit = data['pengingat_menit'] ?? 60;
      });
    }
  }

  Future<void> _simpanPengaturan() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'notif_jadwal': notifikasiJadwal,
      'notif_tugas': notifikasiTugas,
      'notif_ujian': notifikasiUjian,
      'pengingat_menit': pengingatMenit,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pengaturan notifikasi disimpan")),
    );
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
          "Notifikasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Notifikasi Jadwal"),
              value: notifikasiJadwal,
              onChanged: (val) => setState(() => notifikasiJadwal = val),
            ),
            SwitchListTile(
              title: const Text("Notifikasi Tugas"),
              value: notifikasiTugas,
              onChanged: (val) => setState(() => notifikasiTugas = val),
            ),
            SwitchListTile(
              title: const Text("Notifikasi Ujian"),
              value: notifikasiUjian,
              onChanged: (val) => setState(() => notifikasiUjian = val),
            ),
            const SizedBox(height: 20),
            const Text("Ingatkan sebelum jadwal (dalam menit):"),
            Slider(
              value: pengingatMenit.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              label: "$pengingatMenit menit",
              onChanged: (val) => setState(() => pengingatMenit = val.toInt()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simpanPengaturan,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A959A)),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
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
}
