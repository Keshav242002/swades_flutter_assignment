class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String authSync = '/auth/sync/';
  static const String venues = '/venues/';
  static const String bookings = '/bookings/';
  static const String myBookings = '/me/bookings/';

  static String venueSlots(int venueId) => '/venues/$venueId/slots/';
  static String cancelBooking(int bookingId) => '/bookings/$bookingId/';
}
