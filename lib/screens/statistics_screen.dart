import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_overall_card.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_activity_trend.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_habit_breakdown.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_streak_card.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_momentum_card.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_activity_map.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int date = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<HabitService, HabitStates>(
          builder: (context, state) {
            if (state is! HabitLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final stats = HabitStatisticsService.derive(
              habits: state.habits,
              rangeDays: date,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Statistics',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: DropdownButton<int>(
                          value: date,
                          underline: const SizedBox(),
                          dropdownColor: const Color(0xFF0D1B1E),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          items: const [
                            DropdownMenuItem(value: 7, child: Text('7d')),
                            DropdownMenuItem(value: 30, child: Text('30d')),
                            DropdownMenuItem(value: 90, child: Text('90d')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => date = value);
                          },
                          icon: const Icon(Icons.expand_more,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  StatsOverallCard(snapshot: stats, dateRange: date),
                  const SizedBox(height: 24),
                  StatsActivityTrend(
                    spots: stats.trendSpots,
                    range: date,
                    cardBg: Colors.white.withOpacity(0.05),
                    borderColor: Colors.white.withOpacity(0.1),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  StatsHabitBreakdown(
                    breakdowns: stats.breakdown,
                    cardBg: Colors.white.withOpacity(0.05),
                    borderColor: Colors.white.withOpacity(0.1),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  StatsStreakCard(
                    streaks: stats.topStreaks,
                    cardBg: Colors.white.withOpacity(0.05),
                    borderColor: Colors.white.withOpacity(0.1),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  StatsMomentumCard(
                    streak: stats.topStreak,
                    cardBg: Colors.white.withOpacity(0.05),
                    borderColor: Colors.white.withOpacity(0.1),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
