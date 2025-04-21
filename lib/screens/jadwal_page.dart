import 'package:flutter/material.dart';
import 'package:schedu/widgets/schedule_card.dart';
import 'package:schedu/widgets/kalender.dart';

class JadwalKelasPage extends StatefulWidget {
  const JadwalKelasPage({super.key});

  @override
  State<JadwalKelasPage> createState() => _JadwalKelasPageState();
}

class _JadwalKelasPageState extends State<JadwalKelasPage> {
  DateTime _selectedDate = DateTime.now();
  bool isCalendarView = false;

  // Jadwal untuk tampilan kalender (misalnya: tanggal tertentu)
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

          // Tombol toggle Jadwal / Kalender
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
                          !isCalendarView ? const Color(0xFF6D7470) : Colors.white,
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
                          isCalendarView ? const Color(0xFF6D7470) : Colors.white,
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

          // Konten berdasarkan mode
          if (isCalendarView) ...[
            // == KALENDER MODE ==
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
              child: ListView.builder(
                itemCount: jadwal.length,
                itemBuilder: (context, index) {
                  final item = jadwal[index];
                  return ScheduleCard(
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                  );
                },
              ),
            ),
          ] else ...[
            // == JADWAL MINGGUAN MODE ==
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text(
                    "Senin",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ScheduleCard(
                    title: "PMO",
                    subtitle: "Ruang 2.2 | 08:20 - 10:30",
                  ),
                  ScheduleCard(
                    title: "Analisis Desain",
                    subtitle: "Ruang 3.2 | 08:20 - 10:30",
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Selasa",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ScheduleCard(
                    title: "Digital Marketing",
                    subtitle: "Ruang 2.2 | 08:20 - 10:30",
                  ),
                  ScheduleCard(
                    title: "DMDW",
                    subtitle: "Ruang 3.2 | 08:20 - 10:30",
                  ),

                  // Tambahkan Rabu, Kamis, dst. kalau perlu
                ],
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Aksi saat tombol ditekan
          print("Tambah ditekan!");
        },
        backgroundColor: const Color(0xFF6D7470), // warna abu-abu gelap
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
