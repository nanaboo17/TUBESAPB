import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes/screens/payment_success_screen.dart';

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