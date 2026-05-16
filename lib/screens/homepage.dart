import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:intl/intl.dart';

class TodayHabitsScreen extends StatelessWidget {
  const TodayHabitsScreen({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color card = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A3326);
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
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator(color: accent));
            }
            if (state is HabitLoaded) {
              final now = DateTime.now();
              final weekday = DateFormat.E().format(now);
              
              // Filter habits for today
              final todayHabits = state.habits.where((h) => h.repeatDays.contains(weekday)).toList();
              
              // Calculate statistics for today
              final stats = HabitStatisticsService.derive(
                habits: state.habits,
                rangeDays: 1,
                referenceDate: now,
              );

              // Overall statistics for streak (using 30 days for context)
              final overallStats = HabitStatisticsService.derive(
                habits: state.habits,
                rangeDays: 30,
                referenceDate: now,
              );

              return Column(
                children: [
                  const _TopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 108),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _GreetingSection(),
                          const SizedBox(height: 16),
                          _DailyProgressCard(
                            progress: stats.completionRate / 100.0,
                            completedCount: stats.completed,
                            totalCount: stats.scheduled,
                          ),
                          const SizedBox(height: 12),
                          _CurrentStreakCard(
                            streakDays: overallStats.topStreak?.current ?? 0,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Today's Focus",
                            style: TextStyle(
                              color: title,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (todayHabits.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Text(
                                  "No habits scheduled for today.\nRest well!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: muted, fontSize: 16),
                                ),
                              ),
                            )
                          else
                            ...todayHabits.map((habit) {
                              final isDone = habit.getCompletionPercentage(now) >= 100;
                              return _HabitTile(
                                habit: habit,
                                done: isDone,
                                strike: isDone,
                                highlighted: !isDone,
                                onTap: () {
                                  context.read<HabitService>().add(ToggleHabit(habit.id, now));
                                },
                              );


                            }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text("Error loading habits", style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(19, 19, 19, .8),
        border: Border(bottom: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                "park",
                style: TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Habit Tracker",
                style: TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF353534),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
            ),
            child: const Icon(Icons.person, color: TodayHabitsScreen.muted, size: 20),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d').format(now);
    final hour = now.hour;
    String greeting = "Good morning";
    if (hour >= 12 && hour < 17) greeting = "Good afternoon";
    if (hour >= 17) greeting = "Good evening";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$greeting, User.",
          style: const TextStyle(
            color: TodayHabitsScreen.title,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: const TextStyle(
            color: TodayHabitsScreen.muted,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _DailyProgressCard extends StatelessWidget {
  final double progress;
  final int completedCount;
  final int totalCount;

  const _DailyProgressCard({
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: TodayHabitsScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TodayHabitsScreen.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Progress",
                style: TextStyle(
                  color: TodayHabitsScreen.title,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${(progress * 100).round()}%",
                style: const TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress.isFinite ? progress : 0.0,
              backgroundColor: const Color(0xFF1E331A),
              valueColor: const AlwaysStoppedAnimation(TodayHabitsScreen.accent),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "$completedCount of $totalCount habits completed today.",
            style: const TextStyle(color: TodayHabitsScreen.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CurrentStreakCard extends StatelessWidget {
  final int streakDays;

  const _CurrentStreakCard({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 17),
      decoration: BoxDecoration(
        color: TodayHabitsScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TodayHabitsScreen.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.local_fire_department_outlined, color: TodayHabitsScreen.accent, size: 30),
          const SizedBox(height: 8),
          Text(
            "$streakDays Days",
            style: const TextStyle(
              color: TodayHabitsScreen.title,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            "CURRENT STREAK",
            style: TextStyle(
              color: TodayHabitsScreen.muted,
              fontSize: 12,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  final bool done;
  final bool strike;
  final bool highlighted;
  final VoidCallback? onTap;

  const _HabitTile({
    required this.habit,
    required this.done,
    this.strike = false,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final streak = HabitStatisticsService.currentStreak(habit, DateTime.now());
    final totalCompleted = habit.completedDates.length;
    final goalProgress = (totalCompleted / habit.targetDays).clamp(0.0, 1.0);
    
    // Icon mapping
    IconData getIcon(String name) {
      switch (name) {
        case 'Fitness': return Icons.fitness_center;
        case 'Run': return Icons.directions_run;
        case 'Meditate': return Icons.self_improvement;
        case 'Read': return Icons.book;
        case 'Water': return Icons.water;
        case 'Sleep': return Icons.bedtime;
        case 'Medicine': return Icons.medication;
        case 'Food': return Icons.restaurant;
        case 'Code': return Icons.code;
        case 'Write': return Icons.create;
        case 'Music': return Icons.music_note;
        case 'Save': return Icons.savings;
        case 'Nature': return Icons.eco;
        case 'Art': return Icons.brush;
        case 'Computer': return Icons.computer;
        case 'Swim': return Icons.pool;
        case 'Drive': return Icons.directions_car;
        case 'Bike': return Icons.directions_bike;
        case 'Protein': return Icons.blender;
        case 'Rest': return Icons.airline_seat_individual_suite;
        default: return Icons.spa;
      }
    }

    final accentColor = habit.targetMinutes != null ? const Color(0xFF2196F3) : const Color(0xFF5BC8D3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark grey as requested
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Left accent bar
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Icon Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF386B4D),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getIcon(habit.iconName),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: strike ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        habit.description.isNotEmpty 
                            ? habit.description 
                            : "${habit.repeatDays.length} days/week",
                        style: const TextStyle(
                          color: Color(0xFFA5D6A7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (habit.targetMinutes != null) ...[
                            _SmallChip(text: "${habit.targetMinutes}min"),
                            const SizedBox(width: 8),
                          ],
                          _SmallChip(text: "🔥 $streak days"),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Indicator (Progress or Checkmark)
                if (habit.targetMinutes != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          value: goalProgress,
                          strokeWidth: 4,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(accentColor),
                        ),
                      ),
                      Text(
                        "${(goalProgress * 100).round()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  _DailyCheckmark(done: done, color: accentColor),
              ],
            ),
            if (habit.targetMinutes != null) ...[

              const SizedBox(height: 16),
              // Bottom Progress Bar with Arrow
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final progressWidth = constraints.maxWidth * goalProgress;
                        return Row(
                          children: [
                            Container(
                              height: 2,
                              width: (progressWidth - 10).clamp(0, constraints.maxWidth),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            if (goalProgress > 0)
                              Icon(
                                Icons.play_arrow,
                                size: 14,
                                color: accentColor,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}




class _SmallChip extends StatelessWidget {
  final String text;
  const _SmallChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DailyCheckmark extends StatelessWidget {
  final bool done;
  final Color color;
  const _DailyCheckmark({required this.done, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? color : Colors.transparent,
        border: Border.all(
          color: done ? color : color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.check,
        color: done ? Colors.black : Colors.white.withOpacity(0.1),
        size: 24,
      ),
    );
  }
}