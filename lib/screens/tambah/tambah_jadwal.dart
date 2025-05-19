import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahJadwal extends StatefulWidget {
  const TambahJadwal({super.key});

  @override
  State<TambahJadwal> createState() => _TambahJadwalState();
}

class _TambahJadwalState extends State<TambahJadwal> {
  final TextEditingController matakuliahController = TextEditingController();
  final TextEditingController ruangController = TextEditingController();
  final TextEditingController jamMulaiController = TextEditingController();
  final TextEditingController jamSelesaiController = TextEditingController();

  TimeOfDay? selectedJamMulai;
  TimeOfDay? selectedJamSelesai;

  String? selectedHari;
  final List<String> hariList = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  String formatJam(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
  String? selectedLantai;
  String? selectedRuang;

  final Map<String, List<String>> ruangPerLantai = {
    '2': ['2.1', '2.2', '2.3', '2.4'],
    '3': ['3.1', '3.2', '3.3', '3.4', '3.5', '3.6', '3.7', '3.8', '3.9'],
    '4': ['lab1', 'lab2', 'lab3', 'lab4', '4.1', '4.2', '4.3', '4.4'],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2FD4DB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              "Tambah Jadwal",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mata Kuliah", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: matakuliahController,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 10),

            const Text("Hari", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedHari,
              decoration: _inputDecoration(),
              hint: const Text("Pilih Hari"),
              items: hariList.map((hari) => DropdownMenuItem(value: hari, child: Text(hari))).toList(),
              onChanged: (value) => setState(() => selectedHari = value),
            ),
            const SizedBox(height: 10),

            const Text("Jam Mulai", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            _buildTimePicker(
              controller: jamMulaiController,
              onPick: (picked) {
                setState(() {
                  selectedJamMulai = picked;
                  jamMulaiController.text = picked.format(context);
                });
              },
            ),
            const SizedBox(height: 10),

            const Text("Jam Selesai", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            _buildTimePicker(
              controller: jamSelesaiController,
              onPick: (picked) {
                setState(() {
                  selectedJamSelesai = picked;
                  jamSelesaiController.text = picked.format(context);
                });
              },
            ),
            const SizedBox(height: 10),

            const Text("Tempat", style: TextStyle(fontSize: 15)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedLantai,
                decoration: _inputDecoration(),
                hint: const Text("Pilih Lantai"),
                items: ['2', '3', '4']
                    .map((lantai) => DropdownMenuItem(value: lantai, child: Text("Lantai $lantai")))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLantai = value;
                    selectedRuang = null; 
                  });
                },
              ),
              const SizedBox(height: 10),
              if (selectedLantai != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ruang", style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedRuang,
                      decoration: _inputDecoration(),
                      hint: const Text("Pilih Ruang"),
                      items: ruangPerLantai[selectedLantai]!
                          .map((ruang) => DropdownMenuItem(value: ruang, child: Text(ruang)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedRuang = value),
                    ),
                  ],
                ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _simpanJadwal,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2FD4DB)),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget _buildTimePicker({required TextEditingController controller, required Function(TimeOfDay) onPick}) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (picked != null) onPick(picked);
      },
      child: IgnorePointer(
        child: TextField(
          controller: controller,
          decoration: _inputDecoration().copyWith(suffixIcon: const Icon(Icons.access_time)),
        ),
      ),
    );
  }

  Future<void> _simpanJadwal() async {
   
    final matkul = matakuliahController.text;
    final ruang = selectedRuang;
    final hari = selectedHari;
    final mulai = selectedJamMulai;
    final selesai = selectedJamSelesai;

    if (matkul.isEmpty || ruang == null || hari == null || mulai == null || selesai == null) return;


    final jamGabungan = "${formatJam(mulai)} - ${formatJam(selesai)}";
    final user = FirebaseAuth.instance.currentUser;

    Navigator.pop(context);

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('jadwal').add({
      'matkul': matkul,
      'hari': hari,
      'jam': jamGabungan,
      'ruang': ruang,
      'createdAt': FieldValue.serverTimestamp(),
    });

    
  }
}
