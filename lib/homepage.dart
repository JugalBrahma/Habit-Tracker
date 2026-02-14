import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/create_routine.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = TextEditingController();
final kHabitIcons = {
  'Fitness': Icons.fitness_center,
  'Run': Icons.directions_run,
  'Meditate': Icons.self_improvement,
  'Read': Icons.book,
  'Water': Icons.water,
  'Sleep': Icons.bedtime,
  'Medicine': Icons.medication,
  'Food': Icons.restaurant,
  'Code': Icons.code,
  'Write': Icons.create,
  'Music': Icons.music_note,
  'Save': Icons.savings,
  'Nature': Icons.eco,
  'Art': Icons.brush,
  'Computer': Icons.computer,
};
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(const Duration(days: 3));

    return Scaffold(
      appBar: AppBar(title: Text("My Habit"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clear();
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<HabitService>(),
      child: const CreateRoutine(),
    ),
  ),
);
        },
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          SizedBox(height: 50),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                final isSelected =
                    date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isSelected
                            ? const Color.fromARGB(101, 223, 13, 79)
                            : const Color.fromARGB(22, 223, 13, 79),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: Column(
                          children: [
                            Text(DateFormat.E().format(date)),
                            SizedBox(height: 4),
                            Text(DateFormat.d().format(date)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          BlocBuilder<HabitService, HabitStates>(
            builder: (context, state) {
              if (state is HabitLoading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }

              if (state is HabitLoaded) {
                final habits = state.habits;
                final normalizedSelected = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                );
                final weekdayLabel = DateFormat.E().format(normalizedSelected);
                final scheduledHabits = habits
                    .where((habit) => habit.repeatDays.contains(weekdayLabel))
                    .toList();
                final totalToday = scheduledHabits.length;
                final doneToday = scheduledHabits
                    .where((habit) =>
                        habit.completedDates.contains(normalizedSelected))
                    .length;

                if (totalToday == 0) {
                  return const Expanded(
                      child: Center(child: Text("No routines scheduled today")));
                }
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Today's progress",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(_selectedDate),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                '$doneToday / $totalToday',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: scheduledHabits.length,
                          itemBuilder: (context, index) {
                            final habit = scheduledHabits[index];
                            final isDone = habit.completedDates
                                .contains(normalizedSelected);
                            final streak = _currentStreak(
                              habit,
                              normalizedSelected,
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 9,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(7),
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {},
                                  child: _checklist(
                                    habit,
                                    () => context
                                        .read<HabitService>()
                                        .add(ToggleHabit(
                                            habit.id, normalizedSelected)),
                                    isDone,
                                    streak,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Expanded(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _checklist(
      Habit habit, VoidCallback onToggle, bool isDone, int streak) {
    final icon = kHabitIcons[habit.iconName] ?? Icons.circle;
    final badgeColor = Color(habit.color);

  return Container(
    height: 60,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    'Streak: $streak day${streak == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onToggle,
            child: isDone
                ? const Icon(Icons.check_box)
                : const Icon(Icons.check_box_outline_blank),
          ),
        ],
      ),
    ),
  );
  }

  int _currentStreak(Habit habit, DateTime referenceDate) {
    int streak = 0;
    DateTime cursor = referenceDate;

    while (habit.completedDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

