import 'package:flutter/material.dart';
import 'package:schedu/screens/tambah_tugas.dart';

class TugasUjianPage extends StatefulWidget {
  const TugasUjianPage({Key? key}) : super(key: key);

  @override
  State<TugasUjianPage> createState() => _TugasUjianPageState();
}

class _TugasUjianPageState extends State<TugasUjianPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

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

  Widget _buildList(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selasa, ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type == 'tugas' ? "Tugas Pemrograman" : "Ujian Kecerdasan Bisnis",
                style: const TextStyle(fontSize: 16),
              ),
              const Text("08.20 - 10.30"),
            ],
          ),
        ),
      ],
    );
  }

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
          _buildCalendar(),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList('tugas'),
                _buildList('ujian'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahTugas()),
          );
        },
        backgroundColor: const Color(0xFF2FD4DB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
