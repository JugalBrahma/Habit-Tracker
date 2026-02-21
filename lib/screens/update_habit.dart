import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/screens/widgets/update_habit/color_picker.dart';
import 'package:habit_tracker/screens/widgets/update_habit/icon_picker.dart';
import 'package:habit_tracker/screens/widgets/update_habit/repeat_days_selector.dart';
import 'package:habit_tracker/screens/widgets/update_habit/reminder_tile.dart';
import 'package:habit_tracker/screens/widgets/update_habit/goal_duration_selector.dart';
import 'package:habit_tracker/screens/widgets/update_habit/update_form_fields.dart';
import 'package:habit_tracker/screens/widgets/update_habit/update_habit_button.dart';

class UpdateHabitPage extends StatefulWidget {
  final Habit habit;
  const UpdateHabitPage({super.key, required this.habit});

  @override
  State<UpdateHabitPage> createState() => _UpdateHabitPageState();
}

class _UpdateHabitPageState extends State<UpdateHabitPage> {
  late TextEditingController habitname;
  late TextEditingController description;

  final List<Map<String, dynamic>> _colors = [
    {'color': 0xFF6366F1, 'name': 'Indigo'},
    {'color': 0xFF8B5CF6, 'name': 'Purple'},
    {'color': 0xFFEC4899, 'name': 'Pink'},
    {'color': 0xFFEF4444, 'name': 'Red'},
    {'color': 0xFFF97316, 'name': 'Orange'},
    {'color': 0xFFEAB308, 'name': 'Yellow'},
    {'color': 0xFF22C55E, 'name': 'Green'},
    {'color': 0xFF06B6D4, 'name': 'Cyan'},
  ];

  final List<Map<String, dynamic>> _icons = [
    {'icon': Icons.fitness_center, 'name': 'Fitness'},
    {'icon': Icons.directions_run, 'name': 'Run'},
    {'icon': Icons.self_improvement, 'name': 'Meditate'},
    {'icon': Icons.book, 'name': 'Read'},
    {'icon': Icons.water, 'name': 'Water'},
    {'icon': Icons.bedtime, 'name': 'Sleep'},
    {'icon': Icons.medication, 'name': 'Medicine'},
    {'icon': Icons.restaurant, 'name': 'Food'},
    {'icon': Icons.code, 'name': 'Code'},
    {'icon': Icons.create, 'name': 'Write'},
    {'icon': Icons.music_note, 'name': 'Music'},
    {'icon': Icons.savings, 'name': 'Save'},
    {'icon': Icons.eco, 'name': 'Nature'},
    {'icon': Icons.brush, 'name': 'Art'},
    {'icon': Icons.computer, 'name': 'Computer'},
  ];

  final List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  late int _selectedColor;
  late String _selectedIconName;
  late Set<String> _selectedRepeatDays;
  late double _targetDays;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    habitname = TextEditingController(text: widget.habit.name);
    description = TextEditingController(text: widget.habit.description);
    _selectedColor = widget.habit.color;
    _selectedIconName = widget.habit.iconName;
    _selectedRepeatDays = Set<String>.from(widget.habit.repeatDays);
    _targetDays = widget.habit.targetDays.toDouble();
    _reminderTime = widget.habit.reminderTime;
  }

  @override
  void dispose() {
    habitname.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final primaryColor = Color(_selectedColor);
    final textColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurface.withOpacity(0.6);
    final scaffoldBg = isDark ? colorScheme.surface : Colors.grey[50];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          "Update Habit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("General Info", primaryColor),
              const SizedBox(height: 12),
              UpdateFormFields(
                habitname: habitname,
                description: description,
                selectedColor: _selectedColor,
              ),
              const SizedBox(height: 32),
              _sectionHeader("Appearance", primaryColor),
              const SizedBox(height: 16),
              _subHeader('Color Theme', secondaryTextColor),
              const SizedBox(height: 12),
              ColorPicker(
                colors: _colors,
                selectedColor: _selectedColor,
                onColorSelected: (color) =>
                    setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 24),
              _subHeader("Icon", secondaryTextColor),
              const SizedBox(height: 12),
              IconPicker(
                icons: _icons,
                selectedIconName: _selectedIconName,
                selectedColor: _selectedColor,
                onIconSelected: (name) =>
                    setState(() => _selectedIconName = name),
              ),
              const SizedBox(height: 32),
              _sectionHeader("Schedule", primaryColor),
              const SizedBox(height: 16),
              _subHeader('Repeat Days', secondaryTextColor),
              const SizedBox(height: 12),
              RepeatDaysSelector(
                weekdays: _weekdays,
                selectedRepeatDays: _selectedRepeatDays,
                selectedColor: _selectedColor,
                onDayToggled: (day) {
                  setState(() {
                    if (_selectedRepeatDays.contains(day)) {
                      _selectedRepeatDays.remove(day);
                    } else {
                      _selectedRepeatDays.add(day);
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              ReminderTile(
                reminderTime: _reminderTime,
                selectedColor: _selectedColor,
                onReminderChanged: (time) =>
                    setState(() => _reminderTime = time),
              ),
              const SizedBox(height: 24),
              _subHeader('Goal Duration', secondaryTextColor),
              const SizedBox(height: 12),
              GoalDurationSelector(
                targetDays: _targetDays,
                selectedColor: _selectedColor,
                onGoalChanged: (val) => setState(() => _targetDays = val),
              ),
              const SizedBox(height: 48),
              UpdateHabitButton(
                selectedColor: _selectedColor,
                onTap: _updateHabit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color primaryColor) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: primaryColor.withOpacity(0.8),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _subHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600),
    );
  }

  void _updateHabit() {
    final title = habitname.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit name cannot be empty')),
      );
      return;
    }

    context.read<HabitService>().add(
      UpdateHabit(
        id: widget.habit.id,
        title: title,
        description: description.text.trim(),
        color: _selectedColor,
        iconName: _selectedIconName,
        repeatDays: _selectedRepeatDays.toList(),
        reminderTime: _reminderTime,
        targetDays: _targetDays.round(),
      ),
    );
    Navigator.pop(context);
  }
}
