import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';
import 'edit_password.dart';
import 'notifikasi.dart';
import 'package:schedu/widgets/bannerad.dart';
class Setinguser extends StatefulWidget {
  const Setinguser({super.key});

  @override
  State<Setinguser> createState() => _SetinguserState();
}

class _SetinguserState extends State<Setinguser> {
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
          "Pengaturan Akun",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Edit Profil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Pengaturan Notifikasi"),
            onTap: () {showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Pengaturan Notifikasi"),
                  content: Text("Fitur Ini MAsih dalam pengembangan"),
                  actions: [
                    TextButton(
                      child: Text("Tutup"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              },
            );
              //Navigator.push(
              //  context,
              //  MaterialPageRoute(builder: (_) => const NotifikasiPage()),
              //);
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text("Ubah Password"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditPassword()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Hapus Akun"),
            onTap: () async {
              final confirm = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Konfirmasi Hapus Akun"),
                  content: const Text(
                    "Apakah kamu yakin ingin menghapus akun ini? Tindakan ini tidak dapat dibatalkan!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await FirebaseAuth.instance.currentUser!.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Akun berhasil dihapus")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus akun: $e")),
                  );
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 16), // space ke bawah layar
        child: BannerAdWidget(),
      ),
    );
  }
}
