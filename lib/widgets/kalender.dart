import 'package:flutter/material.dart';

class KalenderWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const KalenderWidget({
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320, // Ubah sesuai desain
        child: CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026),
          onDateChanged: onDateChanged,
        ),
      ),
    );
  }
}
