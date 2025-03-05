import 'package:intl/intl.dart';

import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';

int countDailyStreak(Tank tank, List<TankReading> tankReadings) {
  List<TankReading> readings = [...tankReadings];
  readings.removeWhere((test) => test.tankId != tank.id);
  // readings.removeWhere((test) => test.type != TankReadingType.measurement);
  readings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  if (readings.isEmpty) return 0;

  int streak = 1;
  DateTime lastDate = DateFormat('yyyy-MM-dd').parse(readings.first.createdAt);
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

  if (lastDate.difference(yesterday).inDays != 0) {
    return 0;
  }

  for (int i = 1; i < readings.length; i++) {
    DateTime currentDate =
        DateFormat('yyyy-MM-dd').parse(readings[i].createdAt);
    if (lastDate.difference(currentDate).inDays == 0) {
      continue;
    } else if (lastDate.difference(currentDate).inDays == 1) {
      streak++;
      lastDate = currentDate;
    } else if (lastDate.difference(currentDate).inDays > 1) {
      break;
    }
  }

  return streak;
}
