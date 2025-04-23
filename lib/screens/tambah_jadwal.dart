import 'package:flutter/material.dart';


class TambahJadwal extends StatefulWidget {
  const TambahJadwal({super.key});

  @override
  State<TambahJadwal> createState() => _TambahJadwalState();
}

class _TambahJadwalState extends State<TambahJadwal> {
final TextEditingController MatakuliahControler = TextEditingController();
final TextEditingController HariControler = TextEditingController();
final TextEditingController JamControler = TextEditingController();
final TextEditingController RuangControler = TextEditingController();
  
  String title = "Tambah Jadwal";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF2FD4DB),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(''), 
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
    ),

      body: Column(
        children: [  
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
                  controller: HariControler,
                  decoration: InputDecoration(
                    labelText: 'Hari',
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
                  controller: RuangControler,
                  decoration: InputDecoration(
                    labelText: 'Ruang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
          ),
          
        ],
      ),
      
    );
  }
}