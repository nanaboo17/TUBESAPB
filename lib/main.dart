import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/models/schedule.dart';
import 'package:tubes/providers/travel_provider.dart'; // <-- Make sure to import the provider
import 'package:tubes/screens/home_screen.dart';
import 'package:tubes/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tubes/screens/register_screen.dart';
import 'package:tubes/screens/seat_selection_screen.dart';
import 'package:tubes/screens/splash_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyB1FiSpYd3dojYilQCHuFhAkL0D8x9leQM',
        appId: '1:103065317664:android:f4ae6f6255986b5911a745',
        messagingSenderId: '103065317664',
        projectId: 'tubes-apb-37c05',
        storageBucket: 'tubes-apb-37c05.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp();
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
        },
      ),
    );
  }
}
