String formatDateTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final lastWeek = today.subtract(const Duration(days: 7));

  if (dateTime.isAfter(lastWeek) && dateTime.isBefore(today)) {
    return '${_getDayName(dateTime.weekday)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else if (dateTime.year == today.year &&
      dateTime.month == today.month &&
      dateTime.day == today.day) {
    return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return 'Yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else if (dateTime.year == today.year) {
    return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else {
    return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

String _getDayName(int weekday) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  return days[weekday - 1];
}

String _getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  return months[month - 1];
}
