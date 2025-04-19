import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import 'booking_confirmation_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class SeatSelectionScreen extends StatefulWidget {
  final Schedule schedule;
  final int numOfPassengers;

  const SeatSelectionScreen({
    Key? key,
    required this.schedule,
    required this.numOfPassengers,
  }) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late Schedule schedule;
  List<int> selectedSeats = [];
  List<bool> seatAvailability = List.filled(14, false); // 14 seats, false = available

  String? userId; // userId is now nullable
  String selectedPaymentMethod = "Transfer Bank"; // Replace with actual payment method from selection

  @override
  void initState() {
    super.initState();
    schedule = widget.schedule;

    // Fetch the userId from Supabase auth system
    _fetchUserId();
  }

  // Fetch the userId from Supabase authentication
  Future<void> _fetchUserId() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      setState(() {
        userId = session.user?.id; // Fetch userId from the session
      });
    } else {
      print('No user is signed in');
    }
  }

  void _toggleSeatSelection(int seatIndex) {
    setState(() {
      if (selectedSeats.contains(seatIndex)) {
        selectedSeats.remove(seatIndex);
      } else {
        if (selectedSeats.length < widget.numOfPassengers) {
          selectedSeats.add(seatIndex);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can only select ${widget.numOfPassengers} seats'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.white, 'Available'),
          _buildLegendItem(Colors.green, 'Selected'),
          _buildLegendItem(Colors.grey, 'Booked'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Kursi'),
        backgroundColor: Colors.brown,
      ),
      body: userId == null
          ? Center(child: CircularProgressIndicator()) // Show loading while fetching userId
          : Column(
        children: [
          // Schedule info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${schedule.from} → ${schedule.to}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 4),
                    Text('${schedule.date}'),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 4),
                    Text(schedule.time),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Rp${schedule.price.toStringAsFixed(0)} per kursi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.numOfPassengers} penumpang'),
              ],
            ),
          ),

          // Seat legend
          _buildSeatLegend(),

          // Seat grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 14,
              itemBuilder: (context, index) {
                bool isBooked = seatAvailability[index]; // In real app, check from DB
                bool isSelected = selectedSeats.contains(index);

                return GestureDetector(
                  onTap: isBooked ? null : () => _toggleSeatSelection(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.grey[300]
                          : isSelected
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBooked ? Colors.grey : Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              color: isBooked
                                  ? Colors.grey[600]
                                  : isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isBooked)
                            Icon(Icons.lock, size: 14, color: Colors.grey[600])
                          else if (isSelected)
                            Icon(Icons.check, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Selected seats info
          if (selectedSeats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kursi terpilih: ${selectedSeats.map((s) => s + 1).join(', ')}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          // Total price and confirm button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: Rp${(schedule.price * selectedSeats.length).toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeats.length == widget.numOfPassengers
                        ? () {
                      print("Navigating to BookingConfirmationScreen...");
                      // Pass the entire schedule object to BookingConfirmationScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationScreen(
                            schedule: schedule, // Pass the whole schedule object
                            selectedSeats: selectedSeats, // Selected seats list
                            numOfPassengers: widget.numOfPassengers,
                            selectedPaymentMethod: selectedPaymentMethod, // Payment method
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Konfirmasi Pemesanan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
