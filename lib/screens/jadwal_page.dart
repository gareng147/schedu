import 'package:flutter/material.dart';
import 'package:schedu/screens/tambah_jadwal.dart';
import 'package:schedu/widgets/schedule_card.dart';
import 'package:schedu/widgets/kalender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class JadwalKelasPage extends StatefulWidget {
  const JadwalKelasPage({super.key});

  @override
  State<JadwalKelasPage> createState() => _JadwalKelasPageState();
}

class _JadwalKelasPageState extends State<JadwalKelasPage> {
  DateTime _selectedDate = DateTime.now();
  bool isCalendarView = false;

  
  final List<Map<String, String>> jadwal = [
    {"title": "Digital Marketing", "subtitle": "Ruang 2.2 | 08:20 - 10:30"},
    {"title": "DMDW", "subtitle": "Ruang 3.2 | 08:20 - 10:30"},
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
                      setState(() {
                        isCalendarView = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isCalendarView ? const Color(0xFF2FD4DB) : Colors.white,
                      foregroundColor: !isCalendarView ? Colors.white : Colors.black,
                      side: const BorderSide(color: Color(0xFF6D7470)),
                    ),
                    child: const Text("Jadwal"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isCalendarView = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCalendarView ? const Color(0xFF2FD4DB) : Colors.white,
                      foregroundColor: isCalendarView ? Colors.white : Colors.black,
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('jadwal')
                  .where('hari', isEqualTo: _namaHari(_selectedDate.weekday))
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
                    // Hanya tambahkan padding horizontal di tab kalender
                    padding: isCalendarView ? const EdgeInsets.symmetric(horizontal: 16) : EdgeInsets.zero,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final title = data['matkul'] ?? '';
                      final ruang = data['ruang'] ?? '';
                      final jam = data['jam'] ?? '';
                      return Padding(
                        padding: isCalendarView ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero, // Hanya beri margin bawah di kalender
                        child: ScheduleCard(
                          title: data['matkul'] ?? '',
                          jam: data['jam'] ?? '',
                          ruang: data['ruang'] ?? '',
                          color: Colors.pink[100], // contoh warna
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              '/edit-jadwal',
                              arguments: docs[index].id,
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hapus Jadwal'),
                                content: const Text('Yakin ingin menghapus jadwal ini?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseFirestore.instance.collection('jadwal').doc(docs[index].id).delete();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            )


          ] else ...[
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jadwal')
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada jadwal'));
                  }

                  
                  final Map<String, List<Map<String, dynamic>>> groupedData = {};

                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final hari = data['hari'] ?? 'Lainnya';
                    groupedData.putIfAbsent(hari, () => []).add(data);
                  }

                  final hariList = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: hariList.where((h) => groupedData.containsKey(h)).map((hari) {
                      final items = groupedData[hari]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hari,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          ...items.map((item) {
                            return ScheduleCard(
                              title: item['matkul'] ?? '',
                              jam: item['jam'] ?? '',
                              ruang: item['ruang'] ?? '',
                              color: Colors.pink[100],
                              onEdit: () {
                                Navigator.pushNamed(
                                  context,
                                  '/edit-jadwal',
                                  arguments: item['id'], // ini mungkin perlu disesuaikan
                                );
                              },
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Hapus Jadwal'),
                                    content: const Text('Yakin ingin menghapus jadwal ini?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  // di sini kita butuh id dokumen Firestore
                                  await FirebaseFirestore.instance
                                    .collection('jadwal')
                                    .where('matkul', isEqualTo: item['matkul']) // ganti ini kalau ada ID
                                    .get()
                                    .then((snapshot) {
                                      for (var doc in snapshot.docs) {
                                        doc.reference.delete();
                                      }
                                    });
                                }
                              },
                            );
                          }).toList(),

                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_)=> TambahJadwal()));
        },
        backgroundColor: const Color(0xFF2FD4DB),
        child: const Icon(Icons.add)
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    final hari = _namaHari(date.weekday);
    final bulan = _namaBulan(date.month);
    return "$hari, ${date.day} $bulan ${date.year}";
  }

  String _namaHari(int weekday) {
    const hari = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
    return hari[weekday - 1];
  }

  String _namaBulan(int month) {
    const bulan = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return bulan[month - 1];
  }
}
