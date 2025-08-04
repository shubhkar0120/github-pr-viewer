import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    try {
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
  
  static String formatDateTime(DateTime? date) {
    if (date == null) return 'Unknown date';
    try {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
  
  static String timeAgo(DateTime? date) {
    if (date == null) return 'Unknown time';
    
    try {
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} year${difference.inDays > 730 ? 's' : ''} ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} month${difference.inDays > 60 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
  
  static DateTime? parseIsoDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(dateString);
      } catch (e2) {
        return null;
      }
    }
  }
}
