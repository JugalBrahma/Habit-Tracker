import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/screens/create_routine.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_header.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_date_selector.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_progress_card.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_habit_tile.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(const Duration(days: 3));

    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(scaffoldKey: _scaffoldKey),
            const SizedBox(height: 20),
            HomeDateSelector(
              startDate: startDate,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<HabitService, HabitStates>(
                builder: (context, state) {
                  if (state is HabitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HabitLoaded) {
                    final normalizedSelected = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    final weekdayLabel = DateFormat.E().format(
                      normalizedSelected,
                    );
                    final scheduledHabits = state.habits
                        .where(
                          (habit) => habit.repeatDays.contains(weekdayLabel),
                        )
                        .toList();
                    final totalToday = scheduledHabits.length;
                    final doneToday = scheduledHabits
                        .where(
                          (habit) =>
                              habit.completedDates.contains(normalizedSelected),
                        )
                        .length;

                    if (totalToday == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No routines scheduled today",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        HomeProgressCard(done: doneToday, total: totalToday),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 100,
                            ),
                            itemCount: scheduledHabits.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final habit = scheduledHabits[index];
                              final isDone = habit.completedDates.contains(
                                normalizedSelected,
                              );
                              final streak = _currentStreak(
                                habit,
                                normalizedSelected,
                              );
                              return HomeHabitTile(
                                habit: habit,
                                isDone: isDone,
                                streak: streak,
                                date: normalizedSelected,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
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
          child: const Icon(Icons.add),
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
