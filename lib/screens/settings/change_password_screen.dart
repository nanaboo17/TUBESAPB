import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../settings_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Ubah Sandi',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
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
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/lock.png',
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 24),
            Text(
              'Jangan bagikan kata sandi mu kepada siapapun demi keamanan data anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField('Kata Sandi Sekarang', _currentPasswordController, _isCurrentPasswordVisible, (val) {
              setState(() {
                _isCurrentPasswordVisible = val;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField('Kata Sandi Baru', _newPasswordController, _isNewPasswordVisible, (val) {
              setState(() {
                _isNewPasswordVisible = val;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField('Ulangi Kata Sandi Baru', _confirmPasswordController, _isConfirmPasswordVisible, (val) {
              setState(() {
                _isConfirmPasswordVisible = val;
              });
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add logic for password validation and change here
                if (_newPasswordController.text == _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isVisible, Function(bool) onVisibilityChanged) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 16),
        suffixIcon: GestureDetector(
          onTap: () {
            onVisibilityChanged(!isVisible);
          },
          child: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.brown,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.brown),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
