import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedu/screens/tambah/tambah_jadwal.dart';
import 'package:schedu/widgets/schedule_card.dart';
import 'package:schedu/widgets/kalender.dart';
import 'edit/edit_jadwal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalKelasPage extends StatefulWidget {
  const JadwalKelasPage({super.key});

  @override
  State<JadwalKelasPage> createState() => _JadwalKelasPageState();
}

class _JadwalKelasPageState extends State<JadwalKelasPage> {
  DateTime _selectedDate = DateTime.now();
  bool isCalendarView = false;

  String? docId;
  final user = FirebaseAuth.instance.currentUser;

    final List<Color> warnaCard = [
    Color(0xFFD8B9A8), // Soft Brownish
    Color(0xFFC3CEDA), // Soft Blue Gray
    Color(0xFFD5E8D4), // Pastel Green
    Color(0xFFFCE1E4), // Light Pink
    Color(0xFFFFF3CD),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        isCalendarView = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isCalendarView
                              ? const Color(0xFF2FD4DB)
                              : Colors.white,
                      foregroundColor:
                          !isCalendarView ? Colors.white : Colors.black,
                      side: const BorderSide(color: Color(0xFF6D7470)),
                    ),
                    child: const Text("Jadwal"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        isCalendarView = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCalendarView
                              ? const Color(0xFF2FD4DB)
                              : Colors.white,
                      foregroundColor:
                          isCalendarView ? Colors.white : Colors.black,
                      side: const BorderSide(color: Color(0xFF6D7470)),
                    ),
                    child: const Text("Kalender"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (isCalendarView) ...[
            KalenderWidget(
              selectedDate: _selectedDate,
              onDateChanged: (newDate) {
                if (!mounted) return;
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_formatTanggal(_selectedDate)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('jadwal')
                        .where(
                          'hari',
                          isEqualTo: _namaHari(_selectedDate.weekday),
                        )
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada jadwal'));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    padding:
                        isCalendarView
                            ? const EdgeInsets.symmetric(horizontal: 16)
                            : EdgeInsets.zero,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final title = data['matkul'] ?? '';
                      final ruang = data['ruang'] ?? '';
                      final jam = data['jam'] ?? '';
                      return Padding(
                        padding:
                            isCalendarView
                                ? const EdgeInsets.only(bottom: 16)
                                : EdgeInsets
                                    .zero, 
                        child: ScheduleCard(
                          title: data['matkul'] ?? '',
                          jam: data['jam'] ?? '',
                          ruang: data['ruang'] ?? '',
                          color: warnaCard[index % warnaCard.length],
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        editJadwal(docId: docs[index].id),
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
                                        onPressed:
                                            () => Navigator.pop(ctx, false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(ctx, true),
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
          ] else ...[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('jadwal')
                    .snapshots(), // Tanpa orderBy
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada jadwal'));
                  }

                  final List<String> urutanHari = [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu'
                  ];

                  final docs = snapshot.data!.docs;
                  final Map<String, List<QueryDocumentSnapshot>> jadwalPerHari = {};

                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final hari = data['hari'];
                    if (hari != null) {
                      jadwalPerHari.putIfAbsent(hari, () => []).add(doc);
                    }
                  }

                  final List<Widget> listItems = [];
                  int colorIndex = 0;

                  for (var hari in urutanHari) {
                    final jadwalHariIni = jadwalPerHari[hari];
                    if (jadwalHariIni == null) continue;

                    // Urutkan berdasarkan jam (opsional, jika field jam bisa diurutkan)
                    jadwalHariIni.sort((a, b) {
                      final jamA = (a.data() as Map<String, dynamic>)['jam'] ?? '';
                      final jamB = (b.data() as Map<String, dynamic>)['jam'] ?? '';
                      return jamA.compareTo(jamB);
                    });

                    listItems.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          hari,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );

                    for (var doc in jadwalHariIni) {
                      final data = doc.data() as Map<String, dynamic>;
                      listItems.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ScheduleCard(
                            title: data['matkul'] ?? '',
                            jam: data['jam'] ?? '',
                            ruang: data['ruang'] ?? '',
                            color: warnaCard[colorIndex % warnaCard.length],
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => editJadwal(docId: doc.id),
                                ),
                              );
                            },
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Jadwal'),
                                  content: const Text('Yakin ingin menghapus jadwal ini?'),
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
                                    .doc(doc.id)
                                    .delete();
                              }
                            },
                          ),
                        ),
                      );
                      colorIndex++;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(children: listItems),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahJadwal()),
          );
        },
        backgroundColor: const Color(0xFF2FD4DB),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    final hari = _namaHari(date.weekday);
    final bulan = _namaBulan(date.month);
    return "$hari, ${date.day} $bulan ${date.year}";
  }

  String _namaHari(int weekday) {
    const hari = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];
    return hari[weekday - 1];
  }

  String _namaBulan(int month) {
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return bulan[month - 1];
  }
}
