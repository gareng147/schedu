import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahAppbar extends StatefulWidget {
  const TambahAppbar({super.key});

  @override
  State<TambahAppbar> createState() => _TambahAppbarState();
}

class _TambahAppbarState extends State<TambahAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Tambah Tugas"),
      backgroundColor: const Color(0xFF6D7470),
    );
  }
}