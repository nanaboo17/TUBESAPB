/*
class ScheduleListScreen extends StatelessWidget {
  final String destination;
  final String transportType;

  const ScheduleListScreen({
    Key? key,
    required this.destination,
    required this.transportType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = ProviderPackage.Provider.of<TravelProvider>(context);
    final schedules = provider.schedules;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules for $destination'),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return ListTile(
            title: Text('${schedule.from} → ${schedule.to}'),
            subtitle: Text('${schedule.date} | ${schedule.time}'),
            trailing: Icon(Icons.book),
            onTap: () {
              // Handle booking functionality here
            },
          );
        },
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as StateProvider;
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/models/schedule.dart';
import '../../providers/travel_provider.dart';
import '../../models/schedule.dart'; // Make sure you import the Schedule model

class ScheduleListScreen extends StatefulWidget {
  final String destination;

  const ScheduleListScreen({
    super.key,
    required this.destination
  });

  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  TextEditingController _destinationController = TextEditingController();
  String? _selectedTransport;
  late Future<List<Schedule>> _schedulesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _destinationController.text = widget.destination;
    _schedulesFuture = _getInitialSchedules();  // Ensure schedules are fetched initially
  }

  Future<List<Schedule>> _getInitialSchedules() async {
    return []; // Placeholder until we fetch actual data
  }

  void _fetchSchedules() {
    final destination = _destinationController.text;
    if (destination.isNotEmpty && _selectedTransport != null) {
      StateProvider.Provider.of<TravelProvider>(context, listen: false)
          .fetchSchedulesByType(destination, _selectedTransport!)
          .then((schedules) {
        print("Schedules fetched: $schedules");
        setState(() {
          _schedulesFuture = Future.value(schedules);
        });
      }).catchError((e) {
        print("Error fetching schedules: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch schedules: $e")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a destination and transport type")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Schedules"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFCFB), Color(0xFFE2D1C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: "Enter Destination",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchSchedules,
                    ),
                  ],
                ),
              ),
              // Transport Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TransportItem(
                      label: "kereta api",
                      assetPath: "assets/images/train.png",
                      onTap: () {
                        setState(() {
                          _selectedTransport = "kereta api";
                        });
                        _fetchSchedules();  // Fetch schedules after selection
                      },
                    ),
                    _TransportItem(
                      label: "bus",
                      assetPath: "assets/images/bus.png",
                      onTap: () {
                        setState(() {
                          _selectedTransport = "bus";
                        });
                        _fetchSchedules();  // Fetch schedules after selection
                      },
                    ),
                    _TransportItem(
                      label: "travel",
                      assetPath: "assets/images/car.png",
                      onTap: () {
                        setState(() {
                          _selectedTransport = "travel";
                        });
                        _fetchSchedules();  // Fetch schedules after selection
                      },
                    ),
                  ],
                ),
              ),
              // Fetch and Display Schedules
              Expanded(
                child: FutureBuilder<List<Schedule>>(
                  future: _schedulesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final schedules = snapshot.data!;
                    print('Schedules fetched: $schedules');

                    if (schedules.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada jadwal untuk ${_selectedTransport ?? ''} ke ${_destinationController.text}',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      schedule.from ?? 'Unknown',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward, color: Colors.orange),
                                    Text(
                                      schedule.to ?? 'Unknown',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${schedule.date.day}/${schedule.date.month}/${schedule.date.year}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      schedule.time ?? 'Unknown',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatDuration(schedule.time ?? '00:00', 120),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatPrice(schedule.price.toInt() ?? 0),
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(
                                      'Pesan Sekarang',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(String startTime, int durationInMinutes) {
    final startDateTime = DateTime.parse("2000-01-01 $startTime");
    final endDateTime = startDateTime.add(Duration(minutes: durationInMinutes));

    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    return '${hours}h ${minutes}m';
  }

  String _formatPrice(int price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}';
  }
}


class _TransportItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final Function() onTap;

  const _TransportItem({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(assetPath, width: 70),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }
}