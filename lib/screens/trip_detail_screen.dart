import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'book_ticket_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final Map<String, String> trip;

  const TripDetailScreen({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTripHeader(),
            const SizedBox(height: 24),
            _buildTripInformation(),
            const SizedBox(height: 24),
            _buildBookButton(context),
          ],
        ),
      ),
    );
  }

  // Trip Header Widget
  Widget _buildTripHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, size: 30, color: Colors.brown),
        const SizedBox(width: 8),
        Text(
          "${trip['from']} → ${trip['to']}",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
      ],
    );
  }

  // Trip Information Widget
  Widget _buildTripInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.calendar_today, "Date: ${trip['date']}"),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.access_time, "Time: ${trip['time']}"),
      ],
    );
  }

  // Helper method to create info rows (icon + text)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
        ),
      ],
    );
  }

  // Book Button
  Widget _buildBookButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookTicketScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          "Book Ticket",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}