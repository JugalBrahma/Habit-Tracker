import 'package:flutter/material.dart';

abstract class HabitEvents {}

class LoadHabit extends HabitEvents {}

class AddHabit extends HabitEvents {
  final String title;
  final String description;
  final int color;
  final String iconName;
  final List<String> repeatDays;
  final TimeOfDay? reminderTime;
  final int targetDays;

  AddHabit({
    required this.title,
    required this.description,
    required this.color,
    required this.iconName,
    required this.repeatDays,
    this.reminderTime,
    this.targetDays = 21,
  });
}

class ToggleHabit extends HabitEvents {
  final String habitId;
  final DateTime date;
  ToggleHabit(this.habitId, this.date);
}

class DeleteHabit extends HabitEvents {
  final String habitId;
  DeleteHabit(this.habitId);
}

class UpdateHabit extends HabitEvents {
  final String id;
  final String title;
  final String description;
  final int color;
  final String iconName;
  final List<String> repeatDays;
  final TimeOfDay? reminderTime;
  final int targetDays;

  UpdateHabit({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.iconName,
    required this.repeatDays,
    this.reminderTime,
    this.targetDays = 21,
  });
}
