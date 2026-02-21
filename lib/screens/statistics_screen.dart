import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/statistics_service.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_overall_card.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_activity_trend.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_habit_breakdown.dart';
import 'package:habit_tracker/screens/widgets/statistics/stats_streak_card.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final scaffoldBg = isDark ? colorScheme.surface : Colors.grey[50];
    final cardBg =
        theme.cardTheme.color ??
        (isDark ? colorScheme.surfaceContainerHighest : Colors.white);
    final borderColor = isDark ? Colors.white10 : Colors.grey[200]!;
    final textColor = colorScheme.onSurface;
    final primaryColor = colorScheme.primary;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainer : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButton<int>(
              borderRadius: BorderRadius.circular(15),
              value: date,
              elevation: 4,
              isDense: true,
              underline: const SizedBox(),
              dropdownColor: theme.cardTheme.color,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              items: const [
                DropdownMenuItem(value: 7, child: Text('7 days')),
                DropdownMenuItem(value: 30, child: Text('30 days')),
                DropdownMenuItem(value: 90, child: Text('90 days')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    date = value;
                  });
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HabitService, HabitStates>(
        builder: (context, state) {
          if (state is! HabitLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = HabitStatisticsService.derive(
            habits: state.habits,
            rangeDays: date,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsOverallCard(snapshot: stats, dateRange: date),
                  const SizedBox(height: 24),
                  StatsActivityTrend(
                    spots: stats.trendSpots,
                    range: date,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                  StatsHabitBreakdown(
                    breakdowns: stats.breakdown,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                  StatsStreakCard(
                    streak: stats.topStreak,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                  StatsActivityMap(
                    data: stats.heatmapData,
                    cardBg: cardBg,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
