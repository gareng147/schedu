import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedu/main.dart';
import 'package:flutter/material.dart';
import 'tambahCatatan.dart';
import 'detailcatatan.dart';


class catatan extends StatelessWidget {
  final String docId;
  const catatan({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    final catatanRef = FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .collection('catatan')
        .orderBy('waktu', descending: true);

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
              "Catatan",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: catatanRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error"));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text("Belum ada catatan"));

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final isi = data['isi'] ?? '';
              final catatanId = docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailCatatanPage(
                        userId: docId,
                        catatanId: catatanId,
                        isiAwal: isi,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      isi,
                      style: TextStyle(fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00B9AE),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahCatatanPage(userId: docId),
            ),
          );
        },
      ),
    );
  }
}