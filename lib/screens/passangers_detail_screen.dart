import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/payment_detail_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({Key? key}) : super(key: key);

  @override
  _PassengerDetailsScreenState createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  // Define controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Penumpang',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Back button functionality
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Passenger Name Text Field
            _buildTextField(
              controller: _nameController,
              label: 'Nama Penumpang',
              hintText: 'Masukkan nama penumpang',
            ),
            const SizedBox(height: 16),
            // Phone Number Text Field
            _buildTextField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hintText: 'Masukkan No. Telepon',
            ),
            const SizedBox(height: 16),
            // Email Text Field
            _buildTextField(
              controller: _emailController,
              label: 'Email Pemesan',
              hintText: 'Masukkan Email Pemesan',
              additionalText: 'Email diperlukan untuk mengirim e-tiket, kode bayar & OTP',
            ),
            const SizedBox(height: 24),
            // Continue to payment button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentDetailsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Lanjut untuk bayar',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building the text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? additionalText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.brown),
            ),
          ),
        ),
        if (additionalText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              additionalText,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}




