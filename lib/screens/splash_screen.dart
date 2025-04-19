import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay before navigating
    Future.delayed(Duration(seconds: 3), () async {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        print("User is still logged in: ${user.email}");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("No user session. Redirecting to login.");
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
      body: Container(
        // Set gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFCFB), Color(0xFFE2D1C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/travel_kuy_splash_screen.png'),
            ],
          ),
        ),
      ),
    );
  }
}
