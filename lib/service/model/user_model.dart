import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final int color;
  final String iconName;
  final DateTime createdAt;
  final List<String> repeatDays;
  final TimeOfDay? reminderTime;
  final bool isActive;
  final int targetDays;
final Set<DateTime> completedDates;
  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.color,
    required this.iconName,
    required this.createdAt,
    required this.repeatDays,
    this.reminderTime,
    this.isActive = true,
    this.targetDays = 21,
    this.completedDates = const {},
  });

  Habit copyWith({
    String? name,
    String? description,
    int? color,
    String? iconName,
    DateTime? createdAt,
    List<String>? repeatDays,
    TimeOfDay? reminderTime,
    bool? isActive,
    int? targetDays,
    Set<DateTime>? completedDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      repeatDays: repeatDays ?? this.repeatDays,
      reminderTime: reminderTime ?? this.reminderTime,
      isActive: isActive ?? this.isActive,
      targetDays: targetDays ?? this.targetDays,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}