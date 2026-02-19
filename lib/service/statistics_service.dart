import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'model/user_model.dart';

class HabitStatisticsService {
  static StatisticsSnapshot derive({
    required List<Habit> habits,
    required int rangeDays,
    DateTime? referenceDate,
  }) {
    final formatter = DateFormat.E();
    final today = _normalize(referenceDate ?? DateTime.now());
    final start = today.subtract(Duration(days: rangeDays - 1));
    final days = List.generate(
      rangeDays,
      (index) => _normalize(start.add(Duration(days: index))),
    );

    int scheduled = 0;
    int completed = 0;
    final List<FlSpot> spots = [];
    final Map<DateTime, int> heatmap = {};
    final List<HabitBreakdown> breakdown = [];
    HabitStreak? bestStreak;

    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final weekday = formatter.format(day);
      final todaysHabits =
          habits.where((habit) => habit.repeatDays.contains(weekday)).toList();
      scheduled += todaysHabits.length;
      var doneToday = 0;
      for (final habit in todaysHabits) {
        if (habit.completedDates.contains(day)) {
          doneToday += 1;
        }
      }
      completed += doneToday;
      final percent = todaysHabits.isEmpty
          ? 0.0
          : (doneToday / todaysHabits.length * 100)
              .clamp(0, 100)
              .toDouble();
      spots.add(FlSpot(i.toDouble(), percent));
    }

    for (final habit in habits) {
      final scheduledDays = days
          .where((day) => habit.repeatDays.contains(formatter.format(day)))
          .length;
      final completedDays = habit.completedDates.where((dateTime) {
        final normalized = _normalize(dateTime);
        return !normalized.isBefore(start) && !normalized.isAfter(today);
      }).length;

      breakdown. add(
        HabitBreakdown(
          name: habit.name,
          percent: scheduledDays == 0
              ? 0
              : (completedDays / scheduledDays * 100)
                  .clamp(0, 100)
                  .toDouble(),
        ),
      );

      for (final date in habit.completedDates) {
        final normalized = _normalize(date);
        if (normalized.isBefore(start) || normalized.isAfter(today)) continue;
        heatmap[normalized] = (heatmap[normalized] ?? 0) + 1;
      }

      final current = _currentStreak(habit, today);
      final best = _bestStreak(habit);
      if (current == 0 && best == 0) {
        continue;
      }
      final existingCurrent = bestStreak?.current ?? -1;
      if (current > existingCurrent) {
        bestStreak = HabitStreak(habit.name, current, best);
      }
    }

    final completionRate = scheduled == 0
        ? 0
        : ((completed / scheduled) * 100).round();

    return StatisticsSnapshot(
      completionRate: completionRate,
      completed: completed,
      scheduled: scheduled,
      trendSpots: spots,
      breakdown: breakdown,
      topStreak: bestStreak,
      heatmapData: heatmap,
    );
  }

  static DateTime _normalize(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  static int _bestStreak(Habit habit) {
    final sorted = habit.completedDates.map(_normalize).toList()
      ..sort((a, b) => a.compareTo(b));
    int best = 0;
    int current = 0;
    DateTime? previous;
    for (final date in sorted) {
      final prev = previous;
      if (prev == null) {
        current = 1;
      } else {
        final diff = date.difference(prev).inDays;
        if (diff == 1) {
          current += 1;
        } else if (diff == 0) {
          continue;
        } else {
          current = 1;
        }
      }
      if (current > best) best = current;
      previous = date;
    }
    return best;
  }

  static int _currentStreak(Habit habit, DateTime referenceDate) {
    int streak = 0;
    DateTime cursor = referenceDate;

    while (habit.completedDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

class StatisticsSnapshot {
  final int completionRate;
  final int completed;
  final int scheduled;
  final List<FlSpot> trendSpots;
  final List<HabitBreakdown> breakdown;
  final HabitStreak? topStreak;
  final Map<DateTime, int> heatmapData;

  const StatisticsSnapshot({
    required this.completionRate,
    required this.completed,
    required this.scheduled,
    required this.trendSpots,
    required this.breakdown,
    required this.topStreak,
    required this.heatmapData,
  });
}

class HabitBreakdown {
  final String name;
  final double percent;

  const HabitBreakdown({required this.name, required this.percent});
}

class HabitStreak {
  final String name;
  final int current;
  final int best;

  const HabitStreak(this.name, this.current, this.best);
}
