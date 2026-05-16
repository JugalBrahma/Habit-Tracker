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
                                  if (habit.targetMinutes != null) {
                                    final currentProgress = habit.getCompletionPercentage(now);
                                    int nextProgress = (currentProgress + 25);
                                    if (nextProgress > 100) nextProgress = 0;
                                    
                                    context.read<HabitService>().add(UpdateHabitPercentage(
                                      habit.id,
                                      {'${now.year}-${now.month}-${now.day}': nextProgress},
                                    ));
                                  } else {
                                    context.read<HabitService>().add(ToggleHabit(habit.id, now));
                                  }
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
    final now = DateTime.now();
    final streak = HabitStatisticsService.currentStreak(habit, now);
    final dailyProgress = (habit.getCompletionPercentage(now) / 100.0).clamp(0.0, 1.0);
    
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

    const appGreen = Color(0xFF95D878);
    final accentColor = appGreen;
    final iconBgColor = appGreen.withOpacity(0.15);
    final bool isTimeBased = habit.targetMinutes != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: double.infinity,
        height: isTimeBased ? 110 : 84,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Stack(
          children: [
            // Left accent bar
            Positioned(
              left: 14,
              top: 16,
              child: Container(
                width: 3,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Icon Avatar
            Positioned(
              left: 24,
              top: 18,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2A2A2A),
                  border: Border.all(color: appGreen.withOpacity(0.1)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  getIcon(habit.iconName),
                  color: appGreen,
                  size: 22,
                ),
              ),
            ),

            // Title
            Positioned(
              left: 82,
              top: 15,
              child: Text(
                habit.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: strike ? TextDecoration.lineThrough : null,
                ),
              ),
            ),

            // Subtitle
            Positioned(
              left: 82,
              top: 34,
              child: Text(
                isTimeBased
                    ? "${(habit.targetMinutes! * dailyProgress).round()} / ${habit.targetMinutes} min"
                    : (habit.description.isNotEmpty
                        ? habit.description
                        : "${habit.repeatDays.length} days/week"),
                style: const TextStyle(
                  color: Color(0xFFC8EEC0),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Tags
            Positioned(
              left: 82,
              top: 54,
              child: Row(
                children: [
                  if (habit.targetMinutes != null) ...[
                    _Tag(text: "${habit.targetMinutes}min", width: 68),
                    const SizedBox(width: 8),
                  ],
                  _Tag(text: "🔥 $streak days", width: 66),
                ],
              ),
            ),

            // Action Indicator
            Positioned(
              right: 24,
              top: 26,
              child: isTimeBased
                  ? _ProgressCircle(progress: dailyProgress, color: accentColor)
                  : _DailyCheckmark(done: done, color: accentColor),
            ),

            // Bottom Progress Bar (for time-based)
            if (isTimeBased)
              Positioned(
                left: 29,
                top: 65, // Moved up more to 65
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    const double barWidth = 292;
                    double newProgress = (details.localPosition.dx / barWidth).clamp(0.0, 1.0);
                    context.read<HabitService>().add(UpdateHabitPercentage(
                      habit.id,
                      {'${now.year}-${now.month}-${now.day}': (newProgress * 100).round()},
                    ));
                  },
                  onTapDown: (details) {
                    const double barWidth = 292;
                    double newProgress = (details.localPosition.dx / barWidth).clamp(0.0, 1.0);
                    context.read<HabitService>().add(UpdateHabitPercentage(
                      habit.id,
                      {'${now.year}-${now.month}-${now.day}': (newProgress * 100).round()},
                    ));
                  },
                  child: Container(
                    width: 292,
                    height: 45, // Further increased hit area
                    color: Colors.transparent,
                    child: Center(
                      child: SizedBox(
                        width: 292,
                        height: 4,
                        child: CustomPaint(
                          painter: _BottomProgressPainter(
                            progress: dailyProgress,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressCircle({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 2,
            backgroundColor: Colors.white.withOpacity(0.06),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        Text(
          "${(progress * 100).round()}%",
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}




class _Tag extends StatelessWidget {
  final String text;
  final double width;
  const _Tag({required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        maxLines: 1,
        style: const TextStyle(
          color: Color(0xFFC8EEC0),
          fontSize: 9,
          fontWeight: FontWeight.w400,
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? color : Colors.white.withOpacity(0.06),
        border: Border.all(
          color: done ? color : color.withOpacity(0.65),
          width: 1.4,
        ),
      ),
      child: done
          ? const Icon(
              Icons.check,
              color: Colors.black,
              size: 18,
            )
          : null,
    );
  }
}

class _BottomProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _BottomProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double padding = 10.0;
    final double usableWidth = size.width - (padding * 2);
    final double progressX = padding + (usableWidth * progress);
    final double y = 10; // 85 (container top) + 10 = 95 (new bottom position)

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw track
    canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), trackPaint);
    
    // Draw progress line
    if (progress > 0) {
      canvas.drawLine(Offset(padding, y), Offset(progressX, y), progressPaint);

      // Restore original right-pointing arrow centered on the line
      final arrowPath = Path()
        ..moveTo(progressX + 10, y)
        ..lineTo(progressX - 2, y - 6)
        ..lineTo(progressX - 2, y + 6)
        ..close();

      canvas.drawPath(arrowPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BottomProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}