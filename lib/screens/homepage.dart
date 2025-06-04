import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedu/widgets/schedule_card.dart';
import 'edit/edit_jadwal.dart';
import 'catatan/catatan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDay = "hari_ini";

  String _getHari(DateTime date) {
    const hariList = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    return hariList[date.weekday % 7];
  }

  final user = FirebaseAuth.instance.currentUser;

  final List<Color> warnaCard = [
    const Color(0xFFD8B9A8),
    const Color(0xFFEADBC8),
    const Color(0xFFF6EFE7),
  ];

  final TextEditingController _catatanController = TextEditingController();
  bool _isSavingCatatan = false;

  Future<void> _simpanCatatan() async {
    final isi = _catatanController.text.trim();
    if (isi.isEmpty) return;
    if (!mounted) return;
    setState(() => _isSavingCatatan = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('catatan')
          .add({'isi': isi, 'waktu': Timestamp.now()});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Catatan berhasil disimpan")));

      _catatanController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan catatan")));
    } finally {
      if (!mounted) return;
      setState(() => _isSavingCatatan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final besok = today.add(Duration(days: 1));
    final filterHari =
        selectedDay == "hari_ini" ? _getHari(today) : _getHari(besok);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Jadwal Hari Ini",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      selectedDay = "hari_ini";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedDay == "hari_ini"
                            ? const Color(0xFF2FD4DB)
                            : Colors.grey.shade300,
                    foregroundColor:
                        selectedDay == "hari_ini"
                            ? Colors.white
                            : Colors.black87,
                  ),
                  child: const Text("Hari Ini"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      selectedDay = "besok";
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        selectedDay == "besok"
                            ? const Color(0xFF2FD4DB)
                            : Colors.grey.shade300,
                    foregroundColor:
                        selectedDay == "besok" ? Colors.white : Colors.black87,
                  ),
                  child: const Text("Besok"),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('jadwal')
                    .where('hari', isEqualTo: filterHari)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Tidak ada jadwal'));
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final title = data['matkul'] ?? '';
                  final ruang = data['ruang'] ?? '';
                  final jam = data['jam'] ?? '';
                  final warna = warnaCard[index % warnaCard.length];

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ScheduleCard(
                      title: title,
                      jam: jam,
                      ruang: ruang,
                      color: warna,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => editJadwal(
                                  docId: docs[index].id,
                                ), // pakai id dari dokumen Firestore
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text('Hapus Jadwal'),
                                content: const Text(
                                  'Yakin ingin menghapus jadwal ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('jadwal')
                              .doc(docs[index].id)
                              .delete();
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),

        const Divider(
          color: Colors.black,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Catatan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => catatan(docId: user!.uid),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _catatanController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Tulis catatan...",
                    filled: true,
                    fillColor: const Color.fromARGB(255, 217, 217, 217),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _catatanController.clear();
                    },
                  ),
                  IconButton(
                    icon:
                        _isSavingCatatan
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.save, color: Colors.green),
                    onPressed: _isSavingCatatan ? null : _simpanCatatan,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
