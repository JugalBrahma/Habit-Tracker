import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/service/model/user_model.dart';

void main() {
  group('Habit model helpers', () {
    test('stores reminderTime as minutes and rebuilds TimeOfDay', () {
      final habit = Habit(
        id: '1',
        name: 'Meditate',
        color: 0xFF000000,
        iconName: 'sunny',
        createdAt: DateTime(2024, 1, 1),
        repeatDays: const ['Mon'],
        reminderTime: const TimeOfDay(hour: 6, minute: 30),
      );

      expect(habit.reminderMinutes, 390); // 6*60 + 30
      expect(habit.reminderTime, const TimeOfDay(hour: 6, minute: 30));
    });

    test('completedDates stored as list but exposed as set', () {
      final dateA = DateTime(2024, 1, 1);
      final dateB = DateTime(2024, 1, 2);

      final habit = Habit(
        id: '2',
        name: 'Read',
        color: 0xFFFFFFFF,
        iconName: 'book',
        createdAt: DateTime(2024, 1, 1),
        repeatDays: const ['Tue'],
        completedDates: [dateA, dateB],
      );

      expect(habit.completedDates, [dateA, dateB]);
      expect(habit.completedDateSet, {dateA, dateB});
    });

    test('copyWith updates selected fields and keeps conversions', () {
      final baseHabit = Habit(
        id: '3',
        name: 'Workout',
        color: 0xFF123456,
        iconName: 'run',
        createdAt: DateTime(2024, 1, 1),
        repeatDays: const ['Wed'],
        reminderTime: const TimeOfDay(hour: 7, minute: 0),
        completedDates: [DateTime(2024, 1, 1)],
      );

      final updated = baseHabit.copyWith(
        name: 'Gym',
        reminderTime: const TimeOfDay(hour: 8, minute: 15),
        completedDates: {DateTime(2024, 1, 1), DateTime(2024, 1, 2)},
      );

      expect(updated.name, 'Gym');
      expect(updated.reminderTime, const TimeOfDay(hour: 8, minute: 15));
      expect(updated.completedDateSet,
          {DateTime(2024, 1, 1), DateTime(2024, 1, 2)});
    });
  });
}