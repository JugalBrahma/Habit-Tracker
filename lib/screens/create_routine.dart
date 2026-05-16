import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/screens/widgets/common/premium_snackbar.dart';
import 'package:habit_tracker/screens/widgets/create_routine/color_picker.dart';
import 'package:habit_tracker/screens/widgets/create_routine/icon_picker.dart';
import 'package:habit_tracker/screens/widgets/create_routine/repeat_days_selector.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';

import 'package:habit_tracker/screens/widgets/create_routine/goal_duration_selector.dart';
import 'package:habit_tracker/screens/widgets/create_routine/time_goal_selector.dart';
import 'package:habit_tracker/screens/widgets/create_routine/routine_form_fields.dart';
import 'package:habit_tracker/screens/widgets/create_routine/create_habit_button.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final TextEditingController habitname = TextEditingController();
  final TextEditingController description = TextEditingController();

  static const Color appGreen = Color(0xFF95D878);

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
    {'icon': Icons.pool, 'name': 'Swim'},
    {'icon': Icons.directions_car, 'name': 'Drive'},
    {'icon': Icons.directions_bike, 'name': 'Bike'},
    {'icon': Icons.blender, 'name': 'Protein'},
    {'icon': Icons.airline_seat_individual_suite, 'name': 'Rest'},
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

  int _selectedColor = 0xFF95D878;
  String _selectedIconName = 'Run';
  final Set<String> _selectedRepeatDays = {
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  };
  double _targetDays = 21;
  int? _targetMinutes;
  TimeOfDay? _reminderTime;

  @override
  void dispose() {
    habitname.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFF131313);
    const Color cardBg = Color(0xFF1E1E1E);
    const Color cardBorder = Color(0xFF2A3326);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          "New Habit",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: bg.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildSectionCard(
                title: "GENERAL INFO",
                bg: cardBg,
                border: cardBorder,
                child: RoutineFormFields(
                  habitname: habitname,
                  description: description,
                  selectedColor: _selectedColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: "APPEARANCE",
                bg: cardBg,
                border: cardBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Icon",
                      style: TextStyle(color: Color(0xFFC1C9B8), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    IconPicker(
                      icons: _icons,
                      selectedIconName: _selectedIconName,
                      selectedColor: _selectedColor,
                      onIconSelected: (name) => setState(() => _selectedIconName = name),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: "SCHEDULE",
                bg: cardBg,
                border: cardBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Repeat Days",
                      style: TextStyle(color: Color(0xFFC1C9B8), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
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
                    const SizedBox(height: 24),
                    const Text(
                      "Goal Duration",
                      style: TextStyle(color: Color(0xFFC1C9B8), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    GoalDurationSelector(
                      targetDays: _targetDays,
                      selectedColor: _selectedColor,
                      onGoalChanged: (val) => setState(() => _targetDays = val),
                    ),
                    const SizedBox(height: 24),
                    TimeGoalSelector(
                      targetMinutes: _targetMinutes,
                      selectedColor: _selectedColor,
                      onTimeGoalChanged: (val) => setState(() => _targetMinutes = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CreateHabitButton(
                selectedColor: _selectedColor,
                onTap: _submitHabit,
                text: "Create Habit",
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    required Color bg,
    required Color border,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF95D878),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border, width: 1.5),
          ),
          child: child,
        ),
      ],
    );
  }

  void _submitHabit() {
    final title = habitname.text.trim();
    if (title.isEmpty) {
      PremiumSnackBar.show(
        context,
        message: 'Enter a habit name before saving',
        isError: true,
      );
      return;
    }

    if (_selectedIconName.isEmpty) {
      PremiumSnackBar.show(
        context,
        message: 'Pick an icon for this habit',
        isError: true,
      );
      return;
    }

    context.read<HabitService>().add(
      AddHabit(
        title: title,
        description: description.text.trim(),
        color: _selectedColor,
        iconName: _selectedIconName,
        repeatDays: _selectedRepeatDays.toList(),
        reminderTime: _reminderTime,
        targetDays: _targetDays.round(),
        targetMinutes: _targetMinutes,
      ),
    );
    Navigator.pop(context);
  }
}
