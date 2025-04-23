import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TambahUjian extends StatefulWidget {
  const TambahUjian({super.key});

  @override
  State<TambahUjian> createState() => _TambahUjianState();
}

class _TambahUjianState extends State<TambahUjian> {
  String? selectedMatkul;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController tempatController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Ambil daftar mata kuliah dari koleksi 'jadwal'
  Future<List<String>> getMataKuliah() async {
    final snapshot = await FirebaseFirestore.instance.collection('jadwal').get();
    final matkulList = snapshot.docs.map((doc) => doc['matkul'] as String).toSet().toList();
    return matkulList;
  }

  Future<void> _simpanUjian() async {
    if (_formKey.currentState!.validate() &&
        selectedMatkul != null &&
        selectedDate != null &&
        selectedTime != null) {
      final data = {
        'judul': selectedMatkul,
        'deadline': Timestamp.fromDate(DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        )),
        'jam': "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
        'tempat': tempatController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('ujian').add(data);
      Navigator.pop(context);
    }
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
        title: const Text("Tambah Ujian", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: getMataKuliah(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final matkulList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Mata Kuliah"),
                    items: matkulList.map((matkul) {
                      return DropdownMenuItem(value: matkul, child: Text(matkul));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedMatkul = value),
                    value: selectedMatkul,
                    validator: (value) => value == null ? "Pilih mata kuliah" : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate == null
                          ? ''
                          : DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate!),
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() => selectedDate = pickedDate);
                      }
                    },
                    decoration: _inputDecoration("Tanggal Ujian"),
                    validator: (_) => selectedDate == null ? "Pilih tanggal ujian" : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedTime == null ? '' : selectedTime!.format(context),
                    ),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() => selectedTime = pickedTime);
                      }
                    },
                    decoration: _inputDecoration("Jam Ujian"),
                    validator: (_) => selectedTime == null ? "Pilih jam ujian" : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: tempatController,
                    decoration: _inputDecoration("Tempat Ujian"),
                    validator: (value) => value == null || value.isEmpty ? "Isi tempat ujian" : null,
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed: _simpanUjian,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2FD4DB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Simpan", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
