import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tubes/models/schedule.dart';
import 'package:tubes/providers/travel_provider.dart'; // <-- Make sure to import the provider
import 'package:tubes/screens/home_screen.dart';
import 'package:tubes/screens/login_screen.dart';
import 'package:tubes/screens/register_screen.dart';
import 'package:tubes/screens/seat_selection_screen.dart';
import 'package:tubes/screens/splash_screen.dart';
import 'package:tubes/screens/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://hvpdhcsvfhwuhblllrke.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2cGRoY3N2Zmh3dWhibGxscmtlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwODYwMDYsImV4cCI6MjA1OTY2MjAwNn0.PwLjmn_T6-yTDIej-AYTg8n6h0EOFW3OslMibMd6wNE',
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TravelProvider(),
      child: MaterialApp(
        title: 'TravelKuy!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          /*'/search': (context) {
            final destination = "Los Angeles";  // Example dynamic value
            return SearchResultScreen(destination: destination);
          },*/
          '/seat-selection': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            if (args == null || args['schedule'] == null || args['numOfPassengers'] == null) {
              return Scaffold(body: Center(child: Text('Invalid route arguments')));
            }
            return SeatSelectionScreen(
              schedule: args['schedule'] as Schedule,
              numOfPassengers: args['numOfPassengers'] as int,
            );
          },
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}
