import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/home_screen.dart'; // Assuming HomeScreen is another screen widget
import 'package:tubes/screens/favourite_screen.dart'; // Assuming FavouriteScreen is another screen widget
import 'package:tubes/screens/passangers_detail_screen.dart';
import 'package:tubes/screens/settings_screen.dart'; // Assuming SettingsScreen is another screen widget

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String _selectedTab = "Aktif"; // Active, Completed, Canceled
  int _selectedIndex = 1; // Set the initial index to the correct tab (Transaction)

  // Dummy Data for Bookings
  List<Map<String, String>> _activeBookings = [
    {
      'from': 'Bandung',
      'to': 'Jakarta',
      'departure': 'BDG',
      'arrival': 'JKT',
      'time': '3:00 PM',
      'status': 'Active',
      'price': 'Rp 150.000',
    },
    {
      'from': 'Surabaya',
      'to': 'Jakarta',
      'departure': 'SUB',
      'arrival': 'JKT',
      'time': '4:00 PM',
      'status': 'Active',
      'price': 'Rp 200.000',
    },
  ];

  List<Map<String, String>> _completedBookings = [
    {
      'from': 'Bandung',
      'to': 'Jakarta',
      'departure': 'BDG',
      'arrival': 'JKT',
      'time': '12:00 PM',
      'status': 'Completed',
      'price': 'Rp 100.000',
    },
  ];

  List<Map<String, String>> _canceledBookings = [
    {
      'from': 'Solo',
      'to': 'Yogyakarta',
      'departure': 'SOC',
      'arrival': 'YOG',
      'time': '2:00 PM',
      'status': 'Canceled',
      'price': 'Rp 120.000',
    },
  ];

  // List of screens for each BottomNavigationBar tab
  final List<Widget> _screens = [
    HomeScreen(),       // Assuming HomeScreen is another screen
    TransactionScreen(), // This is the TransactionScreen itself
    FavouriteScreen(),  // Assuming FavouriteScreen is another screen
    SettingsScreen(),   // Assuming SettingsScreen is another screen
  ];

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = HomeScreen();
        break;
      case 1:
        return; // Stay on TransactionScreen
      case 2:
        nextScreen = FavouriteScreen();
        break;
      case 3:
        nextScreen = SettingsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pemesanan',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabSelector(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBookingList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped, // Properly using the onTap for index change
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

  // Tab Selector for Aktif, Selesai, and Dibatalkan
  Widget _buildTabSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabButton("Aktif"),
        _buildTabButton("Selesai"),
        _buildTabButton("Dibatalkan"),
      ],
    );
  }

  // Individual Tab Button
  Widget _buildTabButton(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _selectedTab == label ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: _selectedTab == label ? Colors.white : Colors.brown,
          ),
        ),
      ),
    );
  }

  // Build the List of Bookings based on the selected tab
  Widget _buildBookingList() {
    List<Map<String, String>> bookings;

    switch (_selectedTab) {
      case "Aktif":
        bookings = _activeBookings;
        break;
      case "Selesai":
        bookings = _completedBookings;
        break;
      case "Dibatalkan":
        bookings = _canceledBookings;
        break;
      default:
        bookings = [];
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  // Booking Card Widget
  Widget _buildBookingCard(Map<String, String> booking) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // From and To Locations
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking['from']} → ${booking['to']}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${booking['departure']} → ${booking['arrival']}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  booking['time']!,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
            // Price and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  booking['price']!,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  booking['status']!,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


