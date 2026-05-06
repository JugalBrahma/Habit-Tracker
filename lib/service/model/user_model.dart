import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int color;

  @HiveField(4)
  final String iconName;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final List<String> repeatDays;

  // Store reminder as minutes since midnight so Hive can serialize it.
  @HiveField(7)
  final int? reminderMinutes;

  @HiveField(8)
  final bool isActive;

  @HiveField(9)
  final int targetDays;

  // Hive can store List<DateTime>; wrap to Set when using it.
  @HiveField(10)
  final List<DateTime> completedDates;

  // Store completion percentage for each date (0-100)
  @HiveField(11)
  final Map<String, int> completionPercentage;

  // Target duration per session in minutes (null = no time target)
  @HiveField(12)
  final int? targetMinutes;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.color,
    required this.iconName,
    required this.createdAt,
    required this.repeatDays,
    TimeOfDay? reminderTime,
    this.isActive = true,
    this.targetDays = 21,
    List<DateTime>? completedDates,
    Map<String, int>? completionPercentage,
    this.targetMinutes,
  })  : reminderMinutes = reminderTime == null
            ? null
            : reminderTime.hour * 60 + reminderTime.minute,
        completedDates = List<DateTime>.from(completedDates ?? const []),
        completionPercentage = completionPercentage ?? {};

  TimeOfDay? get reminderTime => reminderMinutes == null
      ? null
      : TimeOfDay(
          hour: reminderMinutes! ~/ 60,
          minute: reminderMinutes! % 60,
        );

  Set<DateTime> get completedDateSet => completedDates.toSet();

  int getCompletionPercentage(DateTime date) {
    final dateKey = '${date.year}-${date.month}-${date.day}';
    return completionPercentage[dateKey] ?? 0;
  }

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
    Map<String, int>? completionPercentage,
    int? targetMinutes,
    bool clearTargetMinutes = false,
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
      completedDates: completedDates == null
          ? this.completedDates
          : completedDates.toList(),
      completionPercentage: completionPercentage ?? this.completionPercentage,
      targetMinutes: clearTargetMinutes ? null : (targetMinutes ?? this.targetMinutes),
    );
  }
}