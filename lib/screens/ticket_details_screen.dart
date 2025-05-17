
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),),),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Travel Information Header
            _buildTravelInfoHeader(),

            const SizedBox(height: 20),

            // Ticket Details Section
            _buildTicketDetails(),

            const SizedBox(height: 20),

            // Barcode Section
            _buildBarcode(),

            const SizedBox(height: 20),

            // Rest Stops Section
            _buildRestStops(),

            const SizedBox(height: 20),

            // Help Section (Chat with support)
            _buildHelp(),

            const SizedBox(height: 20),

            // Rating Section
            _buildRating(),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelInfoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TravelYuk!',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bandung → Jakarta',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '27 Nov 2025',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTicketDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Passengers', '2 Adults'),
            _buildDetailRow('Ticket No', 'STW10'),
            _buildDetailRow('Ticket Fare', '\$89'),
            _buildDetailRow('Rest Stops', '1 Stop'),
            _buildDetailRow('Ticket Status', 'CONFIRMED', isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcode() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(
            'assets/images/barcode.png',
            height: 100,
            width: 300,
          ),
          const SizedBox(height: 8),
          Text(
            'Scan to verify ticket',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRestStops() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rest Stops',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        const SizedBox(height: 8),
        _buildRestStopItem('Saturday Cafe', '30 mins'),
        _buildRestStopItem('Wood Bakery', '20 mins'),
      ],
    );
  }

  Widget _buildRestStopItem(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            name,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHelp() {
    return Row(
      children: [
        Icon(Icons.help_outline, size: 20, color: Colors.brown),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Chat with me',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.brown),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate this bus',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return Icon(
              index < 4 ? Icons.star : Icons.star_border,
              size: 24,
              color: Colors.orange,
            );
          }),
        ),
      ],
    );
  }
}