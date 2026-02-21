import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/statistics_service.dart';

void main() {
  group('Statistics unit testing', () {
    test('Completion rate / totals', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Meditate',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Wed'],
          completedDates: [DateTime(2024, 1, 1), DateTime(2024, 1, 2)],
        ),
        Habit(
          id: '2',
          name: 'Read',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Wed'],
          completedDates: const [],
        ),
        Habit(
          id: '3',
          name: 'Workout',
          color: 0xFF123456,
          iconName: 'run',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Wed'],
          completedDates: const [],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 3,
        referenceDate: DateTime(2024, 1, 3),
      );

      expect(snapshot.scheduled, 9); // 3 habits × 3 days
      expect(snapshot.completed, 2); // only first habit was done twice
      expect(snapshot.completionRate, 22); // round(2/9 * 100)
    });
  });

  group('Breakdown percentages', () {
    test('scheduled habit shows 25% and unscheduled stays 0%', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit A',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Wed', 'Thu'],
          completedDates: [DateTime(2024, 1, 1)],
        ),
        Habit(
          id: '2',
          name: 'Habit B',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const [],
          completedDates: const [],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 4,
        referenceDate: DateTime(2024, 1, 4),
      );
      expect(snapshot.breakdown.length, 2);
      expect(snapshot.breakdown[0].name, 'Habit A');
      expect(snapshot.breakdown[0].percent, 25);
      expect(snapshot.breakdown[1].name, 'Habit B');
      expect(snapshot.breakdown[1].percent, 0);
    });
  });

  group('Trend spots', () {
    test('Trend spots', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit A',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Wed', 'Fri'],
          completedDates: [DateTime(2024, 1, 3), DateTime(2024, 1, 5)],
        ),
        Habit(
          id: '2',
          name: 'Habit B',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon', 'Fri'],
          completedDates: [DateTime(2024, 1, 5)],
        ),
        Habit(
          id: '3',
          name: 'Habit C',
          color: 0xFF123456,
          iconName: 'run',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Tue'],
          completedDates: [DateTime(2024, 1, 2)],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 7,
        referenceDate: DateTime(2024, 1, 8),
      );

      final expected = [100, 100, 0, 100, 0, 0, 0];
      for (var i = 0; i < expected.length; i++) {
        expect(snapshot.trendSpots[i].y, expected[i]);
      }
    });
  });

  group('Heatmap data', () {
    test('counts only window dates and aggregates per day', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit A',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Mon'],
          completedDates: [
            DateTime(2024, 1, 2), // inside window
            DateTime(2024, 1, 5), // inside window
            DateTime(2023, 12, 30), // outside, should be ignored
          ],
        ),
        Habit(
          id: '2',
          name: 'Habit B',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2024, 1, 1),
          repeatDays: const ['Tue'],
          completedDates: [
            DateTime(
              2024,
              1,
              5,
            ), // same day as Habit A’s completion -> counts as 2
            DateTime(2024, 1, 8), // inside window
          ],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 7,
        referenceDate: DateTime(2024, 1, 8),
      );

      final map = snapshot.heatmapData;
      expect(map.length, 3); // days inside the window with completions

      expect(map[DateTime(2024, 1, 2)], 1); // only Habit A on Jan 2
      expect(map[DateTime(2024, 1, 5)], 2); // both habits completed Jan 5
      expect(map[DateTime(2024, 1, 8)], 1); // only Habit B on Jan 8
      expect(
        map.containsKey(DateTime(2023, 12, 30)),
        isFalse,
      ); // outside window ignored
    });
  });

  group('Streak Logic', () {
    test('picks habit with highest current strea', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit Alpha',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2026, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Fri'],
          completedDates: [
            DateTime(2026, 1, 6),
            DateTime(2026, 1, 7),
            DateTime(2026, 1, 8), // makes current streak 3 as of Jan 8
            // DateTime(2026, 1, 2),
            // DateTime(2026, 1, 3),
            // DateTime(2026, 1, 4), // earlier best streak run of 3 as well
          ],
        ),
        Habit(
          id: '2',
          name: 'Habit Beta',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2026, 1, 1),
          repeatDays: const ['Mon', 'Tue'],
          completedDates: [
            DateTime(2026, 1, 7),
            DateTime(2026, 1, 8), // current streak 2
          ],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 7,
        referenceDate: DateTime(2026, 1, 8),
      );

      expect(snapshot.topStreak!.name, 'Habit Alpha');
      expect(snapshot.topStreak!.current, 3);
      expect(
        snapshot.topStreak!.best,
        3,
      ); // or higher if you add a longer historical run
    });

    test('topStreak is null when nothing was completed', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit Alpha',
          color: 0xFF000000,
          iconName: 'sunny',
          createdAt: DateTime(2026, 1, 1),
          repeatDays: const ['Mon', 'Tue', 'Fri'],
          completedDates: const [],
        ),
        Habit(
          id: '2',
          name: 'Habit Beta',
          color: 0xFFFFFFFF,
          iconName: 'book',
          createdAt: DateTime(2026, 1, 1),
          repeatDays: const ['Mon', 'Tue'],
          completedDates: const [],
        ),
      ];

      final snapshot = HabitStatisticsService.derive(
        habits: habits,
        rangeDays: 7,
        referenceDate: DateTime(2026, 1, 8),
      );

      expect(snapshot.topStreak, isNull);
    });
  });
}
