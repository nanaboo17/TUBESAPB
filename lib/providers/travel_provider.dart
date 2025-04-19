import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tubes/models/schedule.dart';
import 'package:tubes/models/booking.dart';
import 'package:tubes/models/user_profile.dart';

class TravelProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  List<Booking> _bookedTrips = []; // New list for booked trips
  bool _isLoading = false;
  String? _error = '';
  UserProfile? _profile; // To store the user profile

  List<Schedule> get schedules => _schedules;
  List<Booking> get bookedTrips => _bookedTrips; // Getter for booked trips
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserProfile? get profile => _profile; // Getter for profile

  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch schedules with error handling
  Future<void> fetchSchedules() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response =
      await _supabase
          .from('schedules')
          .select()
          .order('date', ascending: true)
          .execute();

      final List<dynamic> data = response.data;
      _schedules =
              data.map((item) => Schedule.fromJson(item)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to fetch schedules: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<List<Schedule>> fetchSchedulesByType(String destination, String transportType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase
          .from('schedules')
          .select()
          .ilike('to', '%$destination%')
          .ilike('type', '%${transportType.toLowerCase()}%')
          .order('date', ascending: true)
          .execute();

      print("Response data: ${response.data}"); // Log raw data here

      final List<dynamic> data = response.data;

      if (data.isEmpty) {
        _error = "No schedules found.";
        _isLoading = false;
        notifyListeners();
        return [];
      }

      _schedules = data.map((item) {
        print("Mapped schedule item: $item");  // Log each mapped item
        return Schedule.fromJson(item);
      }).toList();

      _isLoading = false;
      notifyListeners();

      return _schedules;  // Return the fetched schedules here
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to fetch schedules: ${e.toString()}';
      notifyListeners();
      return [];  // Return an empty list if there's an error
    }
  }


  /*Future<List<Schedule>> getSchedulesByType(String transportType) async {
    try {
      final response =
      await _supabase
          .from('schedules')
          .select()
          .eq('type', transportType)
          .order('date', ascending: true)
          .execute();

      return (response.data as List)
          .map((data) => Schedule.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: ${e.toString()}');
    }
  }*/

  // Modify this method to return a List<Schedule>





  // Create a booking with error handling
  Future<void> createBooking(Booking booking) async {
    try {
      final response = await Supabase.instance.client.from('bookings').insert([
        {
          'schedule_id': booking.scheduleId,  // Ensure this is the correct UUID
          'user_id': booking.userId,          // Ensure this is a UUID and is correctly passed
          'booking_id': booking.bookingId,
          'booking_date': booking.bookingDate.toIso8601String(),
          'tickets_booked': booking.ticketsBooked,
          'total_price': booking.totalPrice,
        }
      ]).execute();

      print('Booking created successfully!');
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;  // Rethrow the error to be handled elsewhere
    }
  }
  Future<void> cancelBooking(Booking booking) async {
    try {
      // Remove the booking from the list
      _bookedTrips.remove(booking);

      // Delete the booking from the database
      final response = await _supabase
          .from('bookings')
          .delete()
          .eq('id', booking.bookingId)
          .execute();

      notifyListeners();  // Notify listeners to update the UI
    } catch (e) {
      _error = 'Failed to cancel booking: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> bookTicket(String userId, String scheduleId, int ticketsBooked) async {
    try {
      final response = await _supabase
          .from('schedules')
          .select('tickets_available')
          .eq('id', scheduleId)
          .single()
          .execute();

      int availableTickets = response.data['tickets_available'];

      if (availableTickets >= ticketsBooked) {
        // Reduce the ticket count
        await _supabase
            .from('schedules')
            .update({
          'tickets_available': availableTickets - ticketsBooked,
        })
            .eq('schedule_id', scheduleId)
            .execute();

        // Insert the booking record
        await _supabase.from('bookings').insert({
          'user_id': userId,
          'schedule_id': scheduleId,
          'tickets_booked': ticketsBooked,
          'booking_date': DateTime.now().toIso8601String(),
        }).execute();

        print("Booking successful!");
      } else {
        throw Exception('Not enough tickets available');
      }
    } catch (e) {
      print('Error during ticket booking: $e');
    }
  }


  // Fetch bookings by user
  Future<void> getUserBookings(String userId) async {
    try {
      final response =
      await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('booking_date', ascending: false)
          .execute();

      _bookedTrips = response.data;
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }


  Future<void> fetchUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single()
          .execute();

      if (response.data != null) {
        _profile = UserProfile.fromMap(response.data);
      } else {
        _error = 'Profile not found';
      }
    } catch (e) {
      _error = 'Failed to fetch profile: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Search schedules by destination
  Future<List<Schedule>> searchSchedules(String destination) async {
    try {
      final response =
      await _supabase
          .from('schedules')
          .select()
          .ilike('to', '%$destination%')
          .order('date', ascending: true)
          .execute();

      return (response.data as List)
          .map((data) => Schedule.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to search schedules: ${e.toString()}');
    }
  }


  // Fetch schedules by transport type

}



/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tubes/models/schedule.dart';
import 'package:tubes/models/booking.dart';

class TravelProvider with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  Profile? profile;
  List<Schedule> _schedules = [];
  List<Booking> _bookings = [];

  List<Schedule> get schedules => _schedules;
  List<Booking> get bookings => _bookings;

  // Fetch Schedules from Supabase
  Future<void> fetchSchedules() async {
    final response = await supabase.from('schedules').select().execute();

    final List<dynamic> data = response.data;
    _schedules = data.map((item) => Schedule.fromJson(item)).toList();
    notifyListeners();
  }

  // Fetch user
  Future<String?> fetchUserId() async {
    final user = supabase.auth.currentUser;
    return user?.id;  // Returns the user ID or null if not logged in
  }

  // Add a method to fetch user profile or related data.
  Future<void> fetchUserProfile(String userId) async {
    final response = await supabase
        .from('profiles')  // Assuming you have a profiles table
        .select()
        .eq('user_id', userId)
        .single()
        .execute();

    // Handle the response (e.g., store it in a variable)
    profile = Profile.fromJson(response.data);
    // Update state or variables accordingly
    notifyListeners();
  }



  // Fetch Bookings from Supabase
  Future<void> fetchBookings(String userId) async {
    final response = await supabase
        .from('bookings')
        .select()
        .eq('user_id', userId)
        .execute();

    final List<dynamic> data = response.data;
    _bookings = data.map((item) => Booking.fromJson(item)).toList();
    notifyListeners();
  }

  // Create a new booking in Supabase
  Future<void> createBooking(Booking booking) async {
    final response = await supabase.from('bookings').insert(booking.toJson()).execute();


    // Add the new booking to local list and notify listeners
    _bookings.add(booking);
    notifyListeners();
  }

  // Fetch booked trips
  Future<void> fetchBookedTrips(String userId) async {
    final response = await supabase
        .from('bookings')
        .select()
        .eq('user_id', userId)
        .execute();

    bookedTrips = response.data;
    notifyListeners();
  }

  // Decrement available tickets in Supabase
  Future<void> decrementTickets(String scheduleId, int ticketsBooked) async {
    // First, fetch the current value of tickets_available
    final response = await supabase
        .from('schedules')
        .select('tickets_available')
        .eq('schedule_id', scheduleId)
        .single()
        .execute();

    final currentTickets = response.data['tickets_available'];

    // Calculate the new value
    final newTickets = currentTickets - ticketsBooked;

    // Update the tickets_available field with the new value
    final updateResponse = await supabase
        .from('schedules')
        .update({
      'tickets_available': newTickets,
    })
        .eq('schedule_id', scheduleId)
        .execute();

    // After the update, refresh schedules from Supabase
    await fetchSchedules();
  }

}


*/
