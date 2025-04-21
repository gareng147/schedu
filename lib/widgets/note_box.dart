import 'package:flutter/material.dart';

class NoteBox extends StatelessWidget {
  const NoteBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: TextField(
        maxLines: 5,
        decoration: InputDecoration(
          hintText: "Tulis catatan...",
          filled: true,
          fillColor: Color.fromARGB(255, 217, 217, 217),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Icon(Icons.delete, color: Colors.black54),
        ),
      ),
    );
  }
}
