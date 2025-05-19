import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedu/screens/tambah/tambah_tugas.dart';
import 'tambah/tambah_ujian.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TugasUjianPage extends StatefulWidget {
  const TugasUjianPage({Key? key}) : super(key: key);

  @override
  State<TugasUjianPage> createState() => _TugasUjianPageState();
}

class _TugasUjianPageState extends State<TugasUjianPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool isTugasView = true;

  bool isLoadingEvents = false;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Map<String, dynamic>>> tugasEvents = {};
  Map<DateTime, List<Map<String, dynamic>>> ujianEvents = {};

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    final start = _selectedDate.subtract(const Duration(days: 14));
    final end = _selectedDate.add(const Duration(days: 14));
    loadEventsInRange(start, end);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadEventsInRange(DateTime start, DateTime end) async {
    setState(() => isLoadingEvents = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final tugasSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tugas')
        .where('deadline', isGreaterThanOrEqualTo: start)
        .where('deadline', isLessThanOrEqualTo: end)
        .get();

    final ujianSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('ujian')
        .where('waktu', isGreaterThanOrEqualTo: start)
        .where('waktu', isLessThanOrEqualTo: end)
        .get();

    final Map<DateTime, List<Map<String, dynamic>>> tempTugasEvents = {};
    final Map<DateTime, List<Map<String, dynamic>>> tempUjianEvents = {};

    for (var doc in tugasSnapshot.docs) {
      final data = doc.data();
      final deadline = (data['deadline'] as Timestamp).toDate();
      final date = DateTime(deadline.year, deadline.month, deadline.day);
      tempTugasEvents.putIfAbsent(date, () => []).add(data);
    }

    for (var doc in ujianSnapshot.docs) {
      final data = doc.data();
      final waktu = (data['waktu'] as Timestamp).toDate();
      final date = DateTime(waktu.year, waktu.month, waktu.day);
      tempUjianEvents.putIfAbsent(date, () => []).add(data);
    }

    setState(() {
      tugasEvents = tempTugasEvents;
      ujianEvents = tempUjianEvents;
      isLoadingEvents = false;
    });
  }


  Future<List<Map<String, dynamic>>> getTugasByDate(DateTime date) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tugas')
        .where('deadline', isGreaterThanOrEqualTo: start)
        .where('deadline', isLessThan: end)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }


  Future<List<Map<String, dynamic>>> getUjianByDate(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('ujian')
        .where('waktu',
            isGreaterThanOrEqualTo:
                DateTime(date.year, date.month, date.day),
            isLessThan:
                DateTime(date.year, date.month, date.day + 1))
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Widget _buildCalendar() {
    final events = isTugasView ? tugasEvents : ujianEvents;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        focusedDay: _selectedDate,
        firstDay: DateTime(2020),
        lastDay: DateTime(2030),
        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
        eventLoader: (day) => events[DateTime(day.year, day.month, day.day)] ?? [],
        calendarFormat: _calendarFormat, 
        onFormatChanged: (format) {      
          setState(() {
            _calendarFormat = format;
          });
        },
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDate = selected;
          });
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: Color(0xFF2FD4DB), shape: BoxShape.circle),
          markerDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
      ),
    );
  }


  Widget _buildStyledToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isTugasView = true;
                  final start = _selectedDate.subtract(const Duration(days: 14));
                  final end = _selectedDate.add(const Duration(days: 14));
                  loadEventsInRange(start, end);
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
                  isTugasView = false;
                  final start = _selectedDate.subtract(const Duration(days: 14));
                  final end = _selectedDate.add(const Duration(days: 14));
                  loadEventsInRange(start, end);
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

  Widget _buildList(String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: type == 'tugas'
          ? getTugasByDate(_selectedDate)
          : getUjianByDate(_selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data'));
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

  String _getDayName(int weekday) {
    const days = [
      "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const monthNames = [
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
      "Desember"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingEvents
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                _buildStyledToggle(),
                const SizedBox(height: 16),
                _buildCalendar(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${_getDayName(_selectedDate.weekday)}, ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: isTugasView
                      ? _buildList('tugas')
                      : _buildList('ujian'),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isTugasView) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahTugas()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahUjian()),
            );
          }
        },
        backgroundColor: const Color(0xFF2FD4DB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
