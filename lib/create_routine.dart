import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/habit_service.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final TextEditingController habitname = TextEditingController();
  final TextEditingController description = TextEditingController();

  final List<Map<String, dynamic>> colors = [
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

  int _selectedColor = 0xFF6366F1;
  String _selectedIconName = 'Run';
  final Set<String> _selectedRepeatDays = {};
  double _targetDays = 21;
  TimeOfDay? _reminderTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Routine"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: habitname,
                decoration: InputDecoration(
                  labelText: 'Routine Name',
                  hintText: 'create routine',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                maxLines: 4,
                controller: description,
                decoration: InputDecoration(
                  labelText: 'Description(optional)',
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text('Color'),
              SizedBox(height: 10),
              _buildColorPicker(),
              SizedBox(height: 20),
              Text("Icon", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildIconPicker(),
              SizedBox(height: 20),
              Text('Repeat Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildRepeatDays(),
              SizedBox(height: 20),
              Text('Reminder Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _buildReminderTile(),
              SizedBox(height: 20),
              Text('Target Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildGoalDays(),
              SizedBox(height: 40),
              _buildCreateHabitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final value = color['color'] as int;
        final isSelected = value == _selectedColor;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = value;
            });
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(value),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
            ),
            child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIconPicker() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _icons.length,
          itemBuilder: (context, index) {
            final icon = _icons[index];
            final name = icon['name'] as String;
            final isSelected = name == _selectedIconName;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIconName = name;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? Color(_selectedColor) : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon['icon'] as IconData, size: 24),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRepeatDays() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _weekdays.map((day) {
        final isSelected = _selectedRepeatDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedRepeatDays.remove(day);
              } else {
                _selectedRepeatDays.add(day);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Color(_selectedColor) : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderTile() {
    final reminderText = _reminderTime != null
        ? _reminderTime!.format(context)
        : 'No Reminder Set';
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: _reminderTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            _reminderTime = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.alarm),
            const SizedBox(width: 10),
            Text(reminderText),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalDays() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Goal days'),
              const Spacer(),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(31, 22, 99, 241),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${_targetDays.round()} days',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            min: 7,
            max: 60,
            value: _targetDays,
            onChanged: (value) {
              setState(() {
                _targetDays = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateHabitButton() {
    return GestureDetector(
      onTap: () {
        final title = habitname.text.trim();
      if (title.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter a habit name before saving')));
  return;
}
 
if (_selectedIconName.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick an icon for this habit')));
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
              ),
            );
        Navigator.pop(context);
      },
      child: Center(
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(_selectedColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              'Create Habit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}