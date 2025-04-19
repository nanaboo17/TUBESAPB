import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes/models/schedule.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final Schedule schedule;

  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
    DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(schedule.date);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Jadwal')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dari: ${schedule.from}', style: const TextStyle(fontSize: 20)),
            Text('Ke: ${schedule.to}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Tanggal: $formattedDate'),
            Text('Waktu Berangkat: ${schedule.time}'),
            Text('Harga: Rp ${schedule.price}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
