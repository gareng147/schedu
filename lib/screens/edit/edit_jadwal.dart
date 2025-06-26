import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedu/widgets/bannerad.dart';

class editJadwal extends StatefulWidget {
  final String docId;

  const editJadwal({Key? key, required this.docId}) : super(key: key);

  @override
  State<editJadwal> createState() => _editJadwalState();
}

class _editJadwalState extends State<editJadwal> {

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

  

  @override
  void initState() {
    super.initState();
    _loadData();
  }



  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('jadwal').doc(widget.docId).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        matakuliahController.text = data['matkul'];
        ruangController.text = data['ruang'];
        selectedHari = data['hari'];

        final jam = data['jam']; 
        final parts = jam.split(' - ');
        if (parts.length == 2) {
          jamMulaiController.text = parts[0];
          jamSelesaiController.text = parts[1];
          selectedJamMulai = _parseTime(parts[0]);
          selectedJamSelesai = _parseTime(parts[1]);
        }
      });
    }
  }


  Future<void> _simpanJadwal() async {
    final matkul = matakuliahController.text;
    final ruang = ruangController.text;
    final hari = selectedHari;
    final mulai = selectedJamMulai;
    final selesai = selectedJamSelesai;

    if (matkul.isEmpty || ruang.isEmpty || hari == null || mulai == null || selesai == null) return;

    final jamGabungan = "${formatJam(mulai)} - ${formatJam(selesai)}";

    final data = {
      'matkul': matkul,
      'hari': hari,
      'jam': jamGabungan,
      'ruang': ruang,
    };

    if (widget.docId.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('jadwal').doc(widget.docId).update(data);
    } else {
      await FirebaseFirestore.instance.collection('jadwal').add(data);
    }

    Navigator.pop(context);
  }

TimeOfDay _parseTime(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
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
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              "Edit Jadwal",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          )
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

            const Text("Ruang", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: ruangController,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _simpanJadwal,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A959A)),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ),

            
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 16), // space ke bawah layar
        child: BannerAdWidget(),
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

    

}