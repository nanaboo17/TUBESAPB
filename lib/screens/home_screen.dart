import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _destinationController = TextEditingController();
  String? _selectedTransport;
  int _selectedIndex = 0; // Keep track of selected bottom nav tab

  // Dummy Data for Upcoming Trips and Transport options
  List<Map<String, String>> _upcomingTrips = [
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '10 April 2025', 'time': '12:33 AM'},
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '10 April 2025', 'time': '12:33 AM'},
  ];

  List<Map<String, String>> _schedules = [
    {'from': 'Bandung', 'to': 'Jakarta', 'date': '2025-06-27', 'time': '12:00 PM', 'type': 'kereta api'},
    {'from': 'Surabaya', 'to': 'Jakarta', 'date': '2025-07-01', 'time': '02:00 PM', 'type': 'bus'},
    {'from': 'Solo', 'to': 'Yogyakarta', 'date': '2025-07-05', 'time': '04:00 PM', 'type': 'travel'},
  ];

  // List of screens for each BottomNavigationBar tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  // Filter schedules based on the selected transport and destination
  void _fetchSchedules() {
    final destination = _destinationController.text;

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a destination")));
      return;
    }

    if (_selectedTransport == null || _selectedTransport!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a transport type")));
      return;
    }

    List<Map<String, String>> filteredSchedules = _schedules.where((schedule) {
      return schedule['to'] == destination && schedule['type'] == _selectedTransport;
    }).toList();

    setState(() {
      _schedules = filteredSchedules;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TravelKuy!',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Greeting and search bar
              Text(
                "Hello, tungsahur!",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSearchBox(),
              const SizedBox(height: 20),
              _buildTransportOptions(),
              const SizedBox(height: 20),
              _buildUpcomingTripsSection(),
              const SizedBox(height: 20),
              _buildVoucherBox(),
              const SizedBox(height: 20),
              _buildScheduleList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
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

  // Search Box Widget
  Widget _buildSearchBox() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xffedd2c2), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: "Mau kemana hari ini?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.brown.shade700),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Transport Options Widget
  Widget _buildTransportOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _TransportItem(
          label: "kereta api",
          assetPath: "assets/images/train.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'kereta api';
            });
            _fetchSchedules();
          },
        ),
        _TransportItem(
          label: "bus",
          assetPath: "assets/images/bus.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'bus';
            });
            _fetchSchedules();
          },
        ),
        _TransportItem(
          label: "travel",
          assetPath: "assets/images/car.png",
          onTap: () {
            setState(() {
              _selectedTransport = 'travel';
            });
            _fetchSchedules();
          },
        ),
      ],
    );
  }

  // Upcoming Trips Section
  Widget _buildUpcomingTripsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trip Mendatang",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        const SizedBox(height: 8),
        _upcomingTrips.isEmpty
            ? Center(child: Text("Tidak ada trip mendatang", style: GoogleFonts.poppins(fontSize: 16)))
            : _buildTripsListView(),
      ],
    );
  }

  // List View for Upcoming Trips
  Widget _buildTripsListView() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _upcomingTrips.length,
        itemBuilder: (context, index) {
          final trip = _upcomingTrips[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 6,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text("${trip['from']} → ${trip['to']}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${trip['date']} | ${trip['time']}", style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailScreen(trip: trip)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Detail", style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Voucher Section
  Widget _buildVoucherBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffae7dd),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/coupon.png', height: 50, width: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Kamu Memiliki", style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text("10 Vouchers", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Lihat Semua", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Schedule List Section
  Widget _buildScheduleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Available Schedules", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _schedules.isEmpty
            ? Center(child: Text("No schedules available", style: GoogleFonts.poppins(fontSize: 16)))
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _schedules.length,
          itemBuilder: (context, index) {
            final schedule = _schedules[index];
            return ListTile(
              title: Text("${schedule['from']} → ${schedule['to']}"),
              subtitle: Text("${schedule['date']} | ${schedule['time']}"),
              trailing: IconButton(
                icon: const Icon(Icons.book),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookTicketScreen()),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

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

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final TextEditingController _promoController = TextEditingController();

  double ticketPrice = 115.00;
  double totalDiscount = 0.0;
  double additionalFee = 0.0;

  @override
  Widget build(BuildContext context) {
    double totalPrice = ticketPrice + additionalFee - totalDiscount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
            // Payment summary section
            Text(
              'Rincian pembayaran:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Ticket Price
            _buildPaymentDetailRow('Tiket', 'Rp ${ticketPrice.toStringAsFixed(2)}'),
            // Discount
            _buildPaymentDetailRow('Total Diskon', '-Rp ${totalDiscount.toStringAsFixed(2)}'),
            // Additional Fee
            _buildPaymentDetailRow('Biaya Tambahan', '+Rp ${additionalFee.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            // Total Price
            _buildPaymentDetailRow(
              'Harga Total',
              'Rp ${totalPrice.toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 24),
            // Promo Code Input
            _buildPromoInput(),
            const SizedBox(height: 24),
            // Payment Method
            _buildPaymentMethod(),
            const SizedBox(height: 24),
            // Departure Details
            _buildDepartureDetails(),
            const SizedBox(height: 24),
            // Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentSuccessScreen()),
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
                  'Bayar',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build payment detail rows
  Widget _buildPaymentDetailRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Promo code input section
  Widget _buildPromoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kode promo:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _promoController,
          decoration: InputDecoration(
            hintText: 'Masukkan kode promo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.brown),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                setState(() {
                  if (_promoController.text.isNotEmpty) {
                    totalDiscount = 10.0;
                  } else {
                    totalDiscount = 0.0;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Payment method selection section
  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bayar dengan:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Credit Card / Debit
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 40,
                      color: Colors.brown,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kartu Kredit atau Debit',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Departure details section
  Widget _buildDepartureDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Detail Keberangkatan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kamis, 27 November 2025 13:00',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'JAKARTA',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.arrow_forward),
              Text(
                'BANDUNG',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade50,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            // Payment success message
            Text(
              'Pembayaran Berhasil!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pembayaran anda telah diproses',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 24),
            // Lihat Tiket Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicketDetailsScreen(),
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
                'Lihat Tiket',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

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

class _TransportItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final Function() onTap;

  const _TransportItem({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(assetPath, width: 70),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String _selectedTab = "Aktif"; // Active, Completed, Canceled

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

  int _selectedIndex = 0; // Keep track of selected bottom nav tab

  // List of screens for each BottomNavigationBar tab
  final List<Widget> _screens = [
    const TransactionScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen>{


  void _reloadProfileData() {
    setState(() {

    });
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
        leading: IconButton(onPressed: () {Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()),);
              },
            ),
            SettingsTile(
              title: 'Ubah Sandi',
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),);
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
        currentIndex: 3,
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // TODO: Navigate to the tapped screen
        },
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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _noIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();  // Load existing profile data
  }

  // Mock function to load profile data (replace this with real data fetching logic)
  void _loadProfileData() {
    // For now, let's assume we have this data coming from the profile
    _nameController.text = 'Tung Tung Tung Sahur';
    _phoneController.text = '08987654321';
    _emailController.text = 'tungtungsahur@gmail.com';
    _idController.text = 'KTP';
    _noIdController.text = '312345678910';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
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
            icon: Icon(Icons.arrow_back)),
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
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nama Lengkap', _nameController),
            const SizedBox(height: 16),
            _buildTextField('No Telepon', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('E-Mail', _emailController),
            const SizedBox(height: 16),
            _buildTextField('ID', _idController),
            const SizedBox(height: 16),
            _buildTextField('No ID', _noIdController),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add cancel functionality
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add save functionality
                    // You can save the changes to the profile here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Updated")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
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

