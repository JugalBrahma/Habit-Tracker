import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../model/user_model.dart';

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
      final todaysHabits = habits
          .where((habit) => habit.repeatDays.contains(weekday))
          .toList();
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
          : (doneToday / todaysHabits.length * 100).clamp(0, 100).toDouble();
      spots.add(FlSpot(i.toDouble(), percent));
    }

    final allStreaks = <HabitStreak>[];

    for (final habit in habits) {
      final scheduledDays = days
          .where((day) => habit.repeatDays.contains(formatter.format(day)))
          .length;
      final completedDays = habit.completedDates.where((dateTime) {
        final normalized = _normalize(dateTime);
        return !normalized.isBefore(start) && !normalized.isAfter(today);
      }).length;

      breakdown.add(
        HabitBreakdown(
          name: habit.name,
          iconName: habit.iconName,
          color: habit.color,
          percent: scheduledDays == 0
              ? 0
              : (completedDays / scheduledDays * 100).clamp(0, 100).toDouble(),
        ),
      );

      for (final date in habit.completedDates) {
        final normalized = _normalize(date);
        if (normalized.isAfter(today)) continue;
        heatmap[normalized] = (heatmap[normalized] ?? 0) + 1;
      }

      final current = currentStreak(habit, today);
      final best = _bestStreak(habit);
      if (current == 0 && best == 0) {
        continue;
      }
      final existingCurrent = bestStreak?.current ?? -1;
      final existingBest = bestStreak?.best ?? -1;
      if (current > existingCurrent) {
        bestStreak = HabitStreak(habit.name, current, best);
      } else if (current == existingCurrent && best > existingBest) {
        bestStreak = HabitStreak(habit.name, current, best);
      }
      
      allStreaks.add(HabitStreak(habit.name, current, best));
    }

    allStreaks.sort((a, b) {
      if (b.current != a.current) return b.current.compareTo(a.current);
      return b.best.compareTo(a.best);
    });

    int streaksToShow = 1;
    if (habits.length > 5) {
      streaksToShow = 3;
    } else if (habits.length > 3) {
      streaksToShow = 2;
    }

    final topStreaks = allStreaks.take(streaksToShow).toList();

    final completionRate = scheduled == 0
        ? 0
        : ((completed / scheduled) * 100).clamp(0, 100).round();

    return StatisticsSnapshot(
      completionRate: completionRate,
      completed: completed,
      scheduled: scheduled,
      trendSpots: spots,
      breakdown: breakdown,
      topStreak: bestStreak,
      topStreaks: topStreaks,
      heatmapData: heatmap,
    );
  }

  static DateTime _normalize(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  static int _bestStreak(Habit habit) {
    if (habit.completedDates.isEmpty) return 0;
    
    final formatter = DateFormat.E();
    final uniqueDates = habit.completedDates.map(_normalize).toSet().toList()
      ..sort((a, b) => a.compareTo(b));
      
    int best = 0;
    int current = 0;
    DateTime? expectedNext;

    for (final date in uniqueDates) {
      if (expectedNext == null) {
        current = 1;
      } else {
        bool broken = false;
        DateTime check = expectedNext;
        while (check.isBefore(date)) {
          if (habit.repeatDays.contains(formatter.format(check))) {
            broken = true;
            break;
          }
          check = check.add(const Duration(days: 1));
        }
        
        if (broken) {
          current = 1; 
        } else {
          current += 1;
        }
      }
      if (current > best) best = current;
      expectedNext = date.add(const Duration(days: 1));
    }
    return best;
  }

  static int currentStreak(Habit habit, DateTime referenceDate) {
    if (habit.completedDates.isEmpty) return 0;
    final formatter = DateFormat.E();
    
    int streak = 0;
    DateTime cursor = referenceDate;

    if (!habit.completedDates.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      while (true) {
        if (habit.completedDates.contains(cursor)) {
          break;
        }
        if (habit.repeatDays.contains(formatter.format(cursor))) {
          return 0; // Missed a scheduled day
        }
        cursor = cursor.subtract(const Duration(days: 1));
        if (referenceDate.difference(cursor).inDays > 14) return 0;
      }
    }

    while (true) {
      if (habit.completedDates.contains(cursor)) {
        streak += 1;
      } else if (habit.repeatDays.contains(formatter.format(cursor))) {
        break; 
      }
      cursor = cursor.subtract(const Duration(days: 1));
      if (referenceDate.difference(cursor).inDays > 3650) break; 
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
  final List<HabitStreak> topStreaks;
  final Map<DateTime, int> heatmapData;

  const StatisticsSnapshot({
    required this.completionRate,
    required this.completed,
    required this.scheduled,
    required this.trendSpots,
    required this.breakdown,
    required this.topStreak,
    required this.topStreaks,
    required this.heatmapData,
  });
}

class HabitBreakdown {
  final String name;
  final String iconName;
  final int color;
  final double percent;

  const HabitBreakdown({
    required this.name,
    required this.iconName,
    required this.color,
    required this.percent,
  });
}

class HabitStreak {
  final String name;
  final int current;
  final int best;

  const HabitStreak(this.name, this.current, this.best);
}
