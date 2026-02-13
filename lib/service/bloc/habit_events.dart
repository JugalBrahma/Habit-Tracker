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
  ToggleHabit(this.habitId);
}