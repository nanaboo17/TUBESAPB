import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/home_screen.dart';
import 'package:tubes/screens/favourite_screen.dart';
import 'package:tubes/screens/settings_screen.dart';
import 'package:tubes/screens/settings/edit_profile_screen.dart';
import 'package:tubes/screens/settings/change_password_screen.dart';
import 'package:tubes/screens/transaction_screen.dart'; // Assuming you have this screen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // Index for the current screen in the bottom navigation bar

  void _reloadProfileData() {
    setState(() {
      // Code to reload profile data goes here
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the appropriate screen based on the index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TransactionScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FavouriteScreen()));
        break;
      case 3:
      // Stay on SettingsScreen
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfcfb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfffdfcfb), Color(0xffe6d3c5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Akun Section
            Text(
              "Akun",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SettingsTile(
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              },
            ),
            SettingsTile(
              title: 'Ubah Sandi',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
              },
            ),
            const SizedBox(height: 24),

            // Aksi Lain Section
            Text(
              "Aksi Lain",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SettingsTile(
              title: 'Keluar',
              onTap: () {
                // TODO: implement logout confirmation
              },
            ),
            SettingsTile(
              title: 'Hapus Akun',
              onTap: () {
                // TODO: implement delete account confirmation
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped, // Using _onTabTapped to manage navigation
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      trailing: const Icon(Icons.chevron_right, color: Colors.brown),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
