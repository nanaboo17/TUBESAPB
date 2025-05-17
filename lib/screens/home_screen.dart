import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/payment_detail_screen.dart';
import 'package:tubes/screens/settings_screen.dart';
import 'package:tubes/screens/transaction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/database/schedule_database.dart';
import 'package:tubes/models/schedule.dart';
import 'package:tubes/screens/trip_detail_screen.dart';

import 'book_ticket_screen.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _destinationController = TextEditingController();
  String? _selectedTransport;
  int _selectedIndex = 0; // Keep track of selected bottom nav tab

  // Dummy Data for Upcoming Trips and Transport options
  List<Map<String, String>> _upcomingTrips = [
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '10 April 2025', 'time': '12:33 AM'},
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '10 April 2025', 'time': '12:33 AM'},
  ];

  List<Map<String, String>> _schedules = [
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '2025-06-27', 'time': '12:00 PM', 'type': 'kereta api'},
    {'from': 'Surabaya', 'to': 'Jakarta', 'date': '2025-07-01', 'time': '02:00 PM', 'type': 'bus'},
    {'from': 'Solo', 'to': 'Yogyakarta', 'date': '2025-07-05', 'time': '04:00 PM', 'type': 'travel'},
  ];

  // List of screens for each BottomNavigationBar tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  // Filter schedules based on the selected transport and destination
  void _fetchSchedules() {
    final destination = _destinationController.text;

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a destination")));
      return;
    }

    if (_selectedTransport == null || _selectedTransport!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a transport type")));
      return;
    }

    List<Map<String, String>> filteredSchedules = _schedules.where((schedule) {
      return schedule['to'] == destination && schedule['type'] == _selectedTransport;
    }).toList();

    setState(() {
      _schedules = filteredSchedules;
    });
  }



  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TravelKuy!',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Greeting and search bar
              Text(
                "Hello, tungsahur!",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSearchBox(),
              const SizedBox(height: 20),
              _buildTransportOptions(),
              const SizedBox(height: 20),
              _buildUpcomingTripsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // Search Box Widget
  Widget _buildSearchBox() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xffedd2c2), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: "Mau kemana hari ini?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.brown.shade700),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Transport Options Widget
  Widget _buildTransportOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _TransportItem(
          label: "kereta api",
          assetPath: "assets/images/train.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'kereta api';
            });
            _fetchSchedules();
          },
        ),
        _TransportItem(
          label: "bus",
          assetPath: "assets/images/bus.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'bus';
            });
            _fetchSchedules();
          },
        ),
        _TransportItem(
          label: "travel",
          assetPath: "assets/images/car.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'travel';
            });
            _fetchSchedules();
          },
        ),
      ],
    );
  }

  // Upcoming Trips Section
  Widget _buildUpcomingTripsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trip Mendatang",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        const SizedBox(height: 8),
        _upcomingTrips.isEmpty
            ? Center(child: Text("Tidak ada trip mendatang", style: GoogleFonts.poppins(fontSize: 16)))
            : _buildTripsListView(),
      ],
    );
  }

  // List View for Upcoming Trips
  Widget _buildTripsListView() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _upcomingTrips.length,
        itemBuilder: (context, index) {
          final trip = _upcomingTrips[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 6,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text("${trip['from']} → ${trip['to']}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${trip['date']} | ${trip['time']}", style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailScreen(trip: trip)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Detail", style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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



