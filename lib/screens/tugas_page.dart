import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedu/screens/tambah_tugas.dart';
import 'tambah_ujian.dart';

class TugasUjianPage extends StatefulWidget {
  const TugasUjianPage({Key? key}) : super(key: key);

  @override
  State<TugasUjianPage> createState() => _TugasUjianPageState();
}

class _TugasUjianPageState extends State<TugasUjianPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now(); // Menyimpan tanggal yang dipilih
  bool isTugasView = true; // Menentukan apakah tampilan adalah tugas atau ujian

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil tugas berdasarkan tanggal
  Future<List<Map<String, dynamic>>> getTugasByDate(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tugas')
        .where('deadline',
            isGreaterThanOrEqualTo:
                DateTime(date.year, date.month, date.day),
            isLessThan:
                DateTime(date.year, date.month, date.day + 1))
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fungsi untuk mengambil ujian berdasarkan tanggal
  Future<List<Map<String, dynamic>>> getUjianByDate(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ujian')
        .where('deadline',
            isGreaterThanOrEqualTo:
                DateTime(date.year, date.month, date.day),
            isLessThan:
                DateTime(date.year, date.month, date.day + 1))
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Widget untuk menampilkan kalender
  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  // Widget untuk menampilkan tombol toggle antara Tugas dan Ujian
  Widget _buildStyledToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isTugasView = true; // Menampilkan tugas
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isTugasView ? const Color(0xFF2FD4DB) : Colors.white,
                foregroundColor: isTugasView ? Colors.white : Colors.black,
                side: const BorderSide(color: Color(0xFF6D7470)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
              ),
              child: const Text("Tugas"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isTugasView = false; // Menampilkan ujian
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    !isTugasView ? const Color(0xFF2FD4DB) : Colors.white,
                foregroundColor: !isTugasView ? Colors.white : Colors.black,
                side: const BorderSide(color: Color(0xFF6D7470)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
              ),
              child: const Text("Ujian"),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar tugas atau ujian berdasarkan tanggal
  Widget _buildList(String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: type == 'tugas'
          ? getTugasByDate(_selectedDate) // Menampilkan tugas berdasarkan tanggal
          : getUjianByDate(_selectedDate), // Menampilkan ujian berdasarkan tanggal
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Menunggu data
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data')); // Tidak ada data
        }

        final dataList = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            final judul = data['matkul'] ?? data['judul'] ?? 'Tanpa Judul';
            final jam = data['jam'] ?? '-';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(judul, style: const TextStyle(fontSize: 16)),
                  Text(jam),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi untuk mengubah angka weekday menjadi nama hari
  String _getDayName(int weekday) {
    const days = [
      "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"
    ];
    return days[weekday - 1];
  }

  // Fungsi untuk mengubah angka bulan menjadi nama bulan
  String _getMonthName(int month) {
    const monthNames = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildStyledToggle(), // Menampilkan toggle untuk Tugas dan Ujian
          const SizedBox(height: 16),
          _buildCalendar(), // Menampilkan kalender
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${_getDayName(_selectedDate.weekday)}, ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: isTugasView ? _buildList('tugas') : _buildList('ujian'),
            // Menampilkan daftar tugas atau ujian berdasarkan tab yang dipilih
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isTugasView) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahTugas()), // Arahkan ke halaman tambah tugas
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahUjian()), // Arahkan ke halaman tambah ujian
            );
          }
        },
        backgroundColor: const Color(0xFF2FD4DB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
