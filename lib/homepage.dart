import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/create_routine.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = TextEditingController();

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
          Expanded(
            child: BlocBuilder<HabitService, HabitStates>(
              builder: (context, state) {
                if (state is HabitLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HabitLoaded) {
                  final habits = state.habits;

                  if (habits.isEmpty) {
                    return const Center(child: Text("No habits yet"));
                  }

                  return ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 9,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 1,
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         CreateTrackerPage(title: habit.title),
                              //   ),
                              // );
                            },
                            child: _checklist(
                              habit.name,
                              ()=>context.read<HabitService>().add(ToggleHabit(habit.id)),
                              habit.isActive,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _checklist(String text, VoidCallback onToggle, bool isDone) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: Colors.black12,
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            GestureDetector(
              onTap: onToggle,
              child: isDone
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
            ),
          ],
        ),
      ),
    ),
  );
}
