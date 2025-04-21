import 'package:flutter/material.dart';
import 'package:schedu/widgets/tambah_appbar.dart';

class TambahTugas extends StatefulWidget {
  const TambahTugas({super.key});

  @override
  State<TambahTugas> createState() => _TambahTugasState();
}

class _TambahTugasState extends State<TambahTugas> {
final TextEditingController MatakuliahControler = TextEditingController();
final TextEditingController DeadlineControler = TextEditingController();
final TextEditingController JamControler = TextEditingController();
final TextEditingController TPControler = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TambahAppbar(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: MatakuliahControler,
                  decoration: InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: DeadlineControler,
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: JamControler,
                  decoration: InputDecoration(
                    labelText: 'Jam',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: TPControler,
                  decoration: InputDecoration(
                    labelText: 'Tempat Pengumpulan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}