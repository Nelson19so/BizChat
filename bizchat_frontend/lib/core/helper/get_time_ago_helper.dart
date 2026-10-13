import 'package:intl/intl.dart';

String getTimeAgo(dynamic timeStamp) {
  DateTime? dateTime;

  if (timeStamp == null) return '';

  if (timeStamp is DateTime) {
    dateTime = timeStamp;
  } else {
    try {
      dateTime = timeStamp.toDate();
    } catch (_) {
      dateTime = DateTime.tryParse(timeStamp.toString());
    }
  }

  if (dateTime == null) return '';

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  return '${dateTime.minute}/${dateTime.hour}';
}

String formatHeaderDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day);
  final messageData = DateTime(date.year, date.month, date.day);

  if (messageData == today) {
    return "Today";
  } else if (messageData == yesterday) {
    return "Yesterday";
  } else {
    return DateFormat("MMMM d, yyyy").format(date);
  }
}

DateTime parseDate(dynamic timeStamp) {
  if (timeStamp is DateTime) return timeStamp;
  if (timeStamp is String) return DateTime.tryParse(timeStamp) ?? DateTime.now();
  return DateTime.now();
}