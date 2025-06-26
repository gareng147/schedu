import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailCatatanPage extends StatefulWidget {
  final String userId;
  final String catatanId;
  final String isiAwal;

  const DetailCatatanPage({
    super.key,
    required this.userId,
    required this.catatanId,
    required this.isiAwal,
  });

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late TextEditingController _isiController;

  @override
  void initState() {
    super.initState();
    _isiController = TextEditingController(text: widget.isiAwal);
  }

  Future<void> _updateCatatan() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('catatan')
        .doc(widget.catatanId)
        .update({
      'isi': _isiController.text,
      'waktu': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan diperbarui')),
    );

    Navigator.pop(context);
  }

  Future<void> _hapusCatatan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Catatan'),
        content: Text('Apakah kamu yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('catatan')
          .doc(widget.catatanId)
          .delete();

      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Catatan'),
        backgroundColor: Color(0xFF2FD4DB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _isiController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,  
                decoration: InputDecoration(
                  hintText: 'Tulis catatan...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),      
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _updateCatatan,
                    icon: Icon(Icons.save,color: Colors.white),
                    label: Text('Simpan',style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _hapusCatatan,
                    icon: Icon(Icons.delete,color: Colors.white,),
                    label: Text('Hapus',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
