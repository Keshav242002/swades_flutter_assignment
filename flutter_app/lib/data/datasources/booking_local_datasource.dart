import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';

const _kBookingsKey = 'cached_my_bookings';

class BookingLocalDataSource {
  Future<void> cacheBookings(List<BookingModel> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(bookings.map((b) => b.toJson()).toList());
    await prefs.setString(_kBookingsKey, encoded);
  }

  Future<List<BookingModel>?> getCachedBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookingsKey);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List;
    return list.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
