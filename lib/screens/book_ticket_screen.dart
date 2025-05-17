import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/passangers_detail_screen.dart';

class BookTicketScreen extends StatefulWidget {
  const BookTicketScreen({Key? key}) : super(key: key);

  @override
  _BookTicketScreenState createState() => _BookTicketScreenState();
}

class _BookTicketScreenState extends State<BookTicketScreen> {
  // Define seat availability states
  List<int> bookedSeats = [1, 5, 8, 9]; // Pre-booked seats
  List<int> selectedSeats = []; // User-selected seats

  // Seat size and style
  final double seatSize = 50.0;

  // Function to handle seat selection
  void _toggleSeatSelection(int seatNumber) {
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  // Widget to build the seat grid
  Widget _buildSeatGrid() {
    return GridView.builder(
      itemCount: 14, // Total seats
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of seats per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        int seatNumber = index + 1;
        bool isBooked = bookedSeats.contains(seatNumber);
        bool isSelected = selectedSeats.contains(seatNumber);

        return GestureDetector(
          onTap: isBooked
              ? null // Disable tap if the seat is booked
              : () => _toggleSeatSelection(seatNumber),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green
                  : isBooked
                  ? Colors.grey
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.brown,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                seatNumber.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isBooked ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget to display booking information
  Widget _buildBookingInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date: 27 November 2025',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: 12:00 PM',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Confirm button
  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PassengerDetailsScreen(),),);
          // You can add functionality to confirm booking
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Confirmed!')),
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
          'Confirm Booking',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seat Selection',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Trip Information
            _buildBookingInfo(),
            const SizedBox(height: 20),
            // Seat Grid
            Expanded(
              child: _buildSeatGrid(),
            ),
            // Confirm Button
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }
}