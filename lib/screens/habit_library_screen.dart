import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/screens/create_routine.dart';
import 'package:habit_tracker/screens/update_habit.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';

class HabitLibraryScreen extends StatelessWidget {
  const HabitLibraryScreen({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color card = Color(0xFF1C1B1B);
  static const Color border = Color.fromRGBO(65, 73, 60, 0.30);
  static const Color muted = Color(0xFFC1C9B8);
  static const Color title = Color(0xFFE5E2E1);
  static const Color accent = Color(0xFF95D878);
  static const Color accentDark = Color(0xFF3E7B27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HabitService, HabitStates>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _TopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _PageHeader(),
                            const SizedBox(height: 30),
                            if (state is HabitLoaded) ...[
                              if (state.habits.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 64),
                                    child: Text(
                                      "Your library is empty.\nTap + to start your first habit!",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: muted, fontSize: 16),
                                    ),
                                  ),
                                )
                              else
                                HabitSection(
                                  title: "Your Habits",
                                  icon: Icons.spa_outlined,
                                  habits: state.habits,
                                ),
                            ] else if (state is HabitLoading)
                              const Center(
                                  child:
                                      CircularProgressIndicator(color: accent)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 24,
                  bottom: 84,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateRoutine()),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: accentDark,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: accentDark.withOpacity(.4), blurRadius: 12)
                        ],
                      ),
                      child: const Icon(Icons.add, color: accent, size: 26),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: HabitLibraryScreen.bg.withOpacity(.9),
        border: const Border(
            bottom: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.park_outlined,
                  color: HabitLibraryScreen.accent, size: 18),
              SizedBox(width: 8),
              Text("Habit Tracker",
                  style: TextStyle(
                      color: HabitLibraryScreen.accent,
                      fontSize: 32,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
            ),
            child: const Icon(Icons.person_outline,
                size: 16, color: HabitLibraryScreen.muted),
          )
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Habit Library",
            style: TextStyle(
                color: HabitLibraryScreen.title,
                fontSize: 44,
                fontWeight: FontWeight.w700)),
        SizedBox(height: 4),
        Text("Manage your active routines and routines.",
            style: TextStyle(color: HabitLibraryScreen.muted, fontSize: 14)),
      ],
    );
  }
}

class HabitSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Habit> habits;

  const HabitSection(
      {super.key,
      required this.title,
      required this.icon,
      required this.habits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: HabitLibraryScreen.accent),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  color: HabitLibraryScreen.title,
                  fontSize: 34,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        const Divider(color: Color.fromRGBO(65, 73, 60, 0.2), height: 1),
        const SizedBox(height: 16),
        ...habits.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HabitCard(habit: h),
            )),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final streak = HabitStatisticsService.currentStreak(habit, DateTime.now());
    final totalCompleted = habit.completedDates.length;
    final goalProgress = (totalCompleted / habit.targetDays).clamp(0.0, 1.0);

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateHabitPage(habit: habit)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: HabitLibraryScreen.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: HabitLibraryScreen.border),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(habit.name,
                                    style: const TextStyle(
                                        color: HabitLibraryScreen.title,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.event_note_outlined,
                                      size: 14,
                                      color: HabitLibraryScreen.muted),
                                  const SizedBox(width: 4),
                                  Text(habit.repeatDays.join(', '),
                                      style: const TextStyle(
                                          color: HabitLibraryScreen.muted,
                                          fontSize: 14)),
                                ]),
                              ],
                            ),
                          ),
                          const SizedBox(width: 80),
                        ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Goal Progress",
                                  style: TextStyle(
                                      color: HabitLibraryScreen.muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              Text("$totalCompleted / ${habit.targetDays} Days",
                                  style: const TextStyle(
                                      color: HabitLibraryScreen.title,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Current Streak",
                                  style: TextStyle(
                                      color: HabitLibraryScreen.muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              Text("$streak Days",
                                  style: TextStyle(
                                      color: streak > 0
                                          ? HabitLibraryScreen.accent
                                          : HabitLibraryScreen.muted,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: goalProgress.isFinite ? goalProgress : 0.0,
                        backgroundColor: const Color(0xFF353534),
                        valueColor: const AlwaysStoppedAnimation(
                            HabitLibraryScreen.accent),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 52,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromRGBO(65, 73, 60, 0.3)),
                  ),
                  child: const Icon(Icons.spa_outlined,
                      size: 16, color: HabitLibraryScreen.accent),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert,
                      size: 20, color: HabitLibraryScreen.muted),
                  color: HabitLibraryScreen.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: HabitLibraryScreen.border),
                  ),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context, habit);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: Color(0xFFFFB4AB)),
                          SizedBox(width: 10),
                          Text('Delete',
                              style: TextStyle(color: Color(0xFFFFB4AB))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _showDeleteDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HabitLibraryScreen.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: HabitLibraryScreen.border),
          ),
          title: Text("Delete Habit?",
              style: TextStyle(
                  color: HabitLibraryScreen.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          content: Text(
            "Are you sure you want to remove '${habit.name}'? This action cannot be undone.",
            style: const TextStyle(color: HabitLibraryScreen.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: HabitLibraryScreen.muted)),
            ),
            TextButton(
              onPressed: () {
                context.read<HabitService>().add(DeleteHabit(habit.id));
                Navigator.pop(context);
              },
              child: const Text("Delete",
                  style: TextStyle(
                      color: Color(0xFFFFB4AB), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
