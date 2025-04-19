import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tubes/models/schedule.dart';

import '../models/booking.dart';
import '../providers/travel_provider.dart'; // Add this import

class BookingConfirmationScreen extends StatelessWidget {
  final Schedule schedule;
  final List<int> selectedSeats;
  final int numOfPassengers;
  final String selectedPaymentMethod;

  const BookingConfirmationScreen({
    super.key,
    required this.schedule,  // Pass the whole schedule object
    required this.selectedSeats,
    required this.numOfPassengers,
    required this.selectedPaymentMethod,
  });

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konfirmasi Pemesanan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon and Title
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Pemesanan Berhasil!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Trip Information Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Rute', '${schedule.from} → ${schedule.to}'),
                    Divider(),
                    _buildInfoRow('Tanggal', DateFormat('yyyy-MM-dd').format(schedule.date)),
                    Divider(),
                    _buildInfoRow('Waktu', schedule.time),
                    Divider(),
                    _buildInfoRow('Jumlah Penumpang', numOfPassengers.toString()),
                    Divider(),
                    _buildInfoRow(
                      'Kursi Terpilih',
                      selectedSeats.map((s) => s + 1).join(', '),
                      isImportant: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Price Summary
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ringkasan Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildPriceRow('Harga per Kursi', schedule.price.toDouble()),
                    _buildPriceRow('Jumlah Kursi', numOfPassengers.toDouble()),
                    Divider(),
                    _buildPriceRow(
                      'Total Pembayaran',
                      schedule.price.toDouble() * numOfPassengers,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  final user = Supabase.instance.client.auth.currentUser;

                  if (user == null) {
                    // Handle the case where the user is not authenticated
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in first'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Handle booking submission logic
                  final booking = Booking(
                    bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
                    scheduleId: schedule.scheduleId,
                    ticketsBooked: selectedSeats.length, // Number of selected seats
                    userId: user.id, // Provide the actual user ID
                    bookingDate: DateTime.now(),
                    totalPrice: schedule.price.toInt() * selectedSeats.length.toInt(),
                  );
                  // Assuming a function to store booking is available
                  TravelProvider().createBooking(booking);

                  // Navigate to home screen after booking
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  // Option to print or save ticket
                },
                child: Text(
                  'Simpan atau Cetak Tiket',
                  style: GoogleFonts.poppins(
                    color: Colors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatCurrency(value),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
