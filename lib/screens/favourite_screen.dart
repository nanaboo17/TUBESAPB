import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/screens/home_screen.dart'; // Example, add your actual screens
import 'package:tubes/screens/transaction_screen.dart';
import 'package:tubes/screens/settings_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String selectedTransport = 'kereta api';
  late SharedPreferences prefs;
  int _selectedIndex = 0; // Track the selected index for the Bottom Navigation Bar

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    prefs = await SharedPreferences.getInstance();
    // Retrieve the notes stored in SharedPreferences
    for (int i = 0; i < favouriteSchedules.length; i++) {
      final note = prefs.getString('note_$i') ?? '';
      setState(() {
        favouriteSchedules[i]['note'] = note;
      });
    }
  }

  void _saveNotes() async {
    for (int i = 0; i < favouriteSchedules.length; i++) {
      final note = favouriteSchedules[i]['note'] ?? '';
      await prefs.setString('note_$i', note);
    }
    // Show SnackBar when notes are successfully saved
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil disimpan!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmRemoveSchedule(Map<String, String> schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah kamu yakin ingin menghapus item dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                favouriteSchedules.remove(schedule);
              });
              Navigator.of(context).pop();
              _saveNotes(); // Save the updated notes list after removing an item
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> favouriteSchedules = [
    {
      'from': 'Bandung',
      'to': 'Jakarta',
      'date': '10 April 2025',
      'time': '12:33 AM',
      'type': 'kereta api',
      'note': '',
    },
    {
      'from': 'Surabaya',
      'to': 'Jakarta',
      'date': '10 April 2025',
      'time': '14:33 AM',
      'type': 'kereta api',
      'note': '',
    },
    {
      'from': 'Solo',
      'to': 'Yogyakarta',
      'date': '12 April 2025',
      'time': '10:00 AM',
      'type': 'bus',
      'note': '',
    },
  ];

  final Map<int, TextEditingController> noteControllers = {};

  @override
  Widget build(BuildContext context) {
    final filteredSchedules =
    favouriteSchedules.where((schedule) => schedule['type'] == selectedTransport).toList();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/travel_kuy_text.png',
          height: 50,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add profile navigation here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfffdfcfb), Color(0xffe6d3c5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Favourite",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 16),
                buildTransportFilter(),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: filteredSchedules
                        .map((schedule) => buildScheduleCard(schedule))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to the corresponding screen
          switch (_selectedIndex) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TransactionScreen()),
              );
              break;
            case 2:
            // Already on FavouriteScreen
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget buildTransportFilter() {
    final List<String> types = ['kereta api', 'bus', 'travel'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types.map((type) {
        bool isSelected = selectedTransport == type;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTransport = type;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown[300] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  type,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.brown,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildScheduleCard(Map<String, String> schedule) {
    final index = favouriteSchedules.indexOf(schedule);

    // Inisialisasi controller jika belum ada
    noteControllers.putIfAbsent(index, () => TextEditingController(text: schedule['note']));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${schedule['from']} → ${schedule['to']}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(schedule['date']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(schedule['time']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black)),
            ],
          ),
          const Spacer(),
          // Tampilkan note jika ada
          if (schedule['note'] != null && schedule['note']!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Catatan: ${schedule['note']!}",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.brown),
              ),
            ),
          const SizedBox(height: 6),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: noteControllers[index],
                    decoration: InputDecoration(
                      hintText: "Tinggalkan pesan...",
                      hintStyle: GoogleFonts.poppins(fontSize: 10),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: GoogleFonts.poppins(fontSize: 10),
                    onChanged: (value) {
                      setState(() {
                        schedule['note'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    _saveNotes(); // Save the note after editing
                    // Toggle saved status
                    setState(() {
                      schedule['note'] = noteControllers[index]!.text;
                    });
                  },
                  child: const Icon(Icons.edit, size: 16),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _confirmRemoveSchedule(schedule);
                  },
                  child: const Icon(Icons.bookmark, size: 16, color: Colors.brown),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
