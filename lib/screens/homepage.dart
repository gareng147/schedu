import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDay = "hari_ini";

  // Data jadwal untuk Hari Ini dan Besok
  final List<Map<String, String>> jadwalHariIni = [
    {"title": "Digital Marketing", "room": "Ruang 2.2", "time": "08:00 - 10:00"},
    {"title": "Etika Profesi", "room": "Ruang 3.2", "time": "12:30 - 14:10"},
    {"title": "Kewirausahaan", "room": "Ruang 3.1", "time": "14:20 - 16:00"},
  ];

  final List<Map<String, String>> jadwalBesok = [
    {"title": "Manajemen Proyek", "room": "Ruang 2.1", "time": "08:50 - 10:30"},
    {"title": "Audit SI", "room": "Ruang 3.1", "time": "12:30 - 14:10"},
    {"title": "PBO", "room": "Ruang 3.4", "time": "14:20 - 16:00"},
  ];

  // Warna background berdasarkan index
  final List<Color> warnaCard = [
    const Color(0xFFD8B9A8),
    const Color(0xFFEADBC8),
    const Color(0xFFF6EFE7),
  ];

  @override
  Widget build(BuildContext context) {
    // Pilih daftar jadwal berdasarkan hari
    final jadwal = selectedDay == "hari_ini" ? jadwalHariIni : jadwalBesok;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Jadwal Hari Ini",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // Tombol Hari Ini & Besok
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = "hari_ini";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDay == "hari_ini"
                        ? const Color(0xFF2FD4DB)
                        : Colors.grey.shade300,
                    foregroundColor: selectedDay == "hari_ini"
                        ? Colors.white
                        : Colors.black87,
                  ),
                  child: const Text("Hari Ini"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = "besok";
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedDay == "besok"
                        ? const Color(0xFF2FD4DB)
                        : Colors.grey.shade300,
                    foregroundColor: selectedDay == "besok" 
                        ? Colors.white 
                        : Colors.black87,
                    
                  ),
                  child: const Text("Besok"),
                ),
              ),
            ],
          ),
        ),

        // List Jadwal
        Expanded(
          child: ListView.builder(
            itemCount: jadwal.length,
            itemBuilder: (context, index) {
              final item = jadwal[index];
              final warna = warnaCard[index % warnaCard.length];
              return buildCard(item['title']!, item['room']!, item['time']!, warna);
            },
          ),
        ),

        // Catatan
        const Divider(color: Colors.black, thickness: 1, indent: 16, endIndent: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Catatan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Tulis catatan...",
              filled: true,
              fillColor: const Color.fromARGB(255, 217, 217, 217),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.delete, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  // Widget Card
  Widget buildCard(String title, String room, String time, Color backgroundColor) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 4),
            Text(room),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 4),
            Text(time),
          ],
        ),
      ),
    );
  }
}
