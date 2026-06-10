import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String formatDisplayDate(DateTime date) =>
      DateFormat('MMMM d, yyyy').format(date);

  static String formatDayShort(DateTime date) => DateFormat('d').format(date);

  static String formatDayName(DateTime date) => DateFormat('EEE').format(date);

  static String formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat('h:mm a').format(dt);
  }

  static List<DateTime> getNextDays(int count) {
    final today = DateTime.now();
    return List.generate(count, (i) => today.add(Duration(days: i)));
  }

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}
