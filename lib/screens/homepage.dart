import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';
import 'package:habit_tracker/screens/create_routine.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:intl/intl.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_header.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_date_selector.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_progress_card.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_habit_tile.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_drawer.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';

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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final horizontalPadding = isTablet ? 40.0 : 20.0;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                HomeHeader(scaffoldKey: _scaffoldKey),
                SizedBox(height: isTablet ? 16.0 : 8.0),
                BlocBuilder<HabitService, HabitStates>(
                  builder: (context, state) {
                    if (state is HabitLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is HabitLoaded) {
                      final normalizedSelected = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      );
                      final weekdayLabel = DateFormat.E('en_US').format(
                        normalizedSelected,
                      );
                      final scheduledHabits = state.habits
                          .where(
                            (habit) => habit.repeatDays.contains(weekdayLabel),
                          )
                          .toList();
                      final totalToday = scheduledHabits.length;
                      final doneToday = scheduledHabits.isEmpty
                          ? 0.0
                          : scheduledHabits.fold(
                              0.0,
                              (sum, habit) =>
                                  sum +
                                  (habit.getCompletionPercentage(
                                          normalizedSelected) /
                                      100.0));

                      return Column(
                        children: [
                          HomeProgressCard(
                            done: doneToday,
                            total: totalToday,
                            selectedDate: _selectedDate,
                          ),
                          const SizedBox(height: 16),
                          HomeDateSelector(
                            startDate: startDate,
                            selectedDate: _selectedDate,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          // Category Filters (from Swift Spec)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                _buildFilterPill("All", isSelected: true),
                                _buildFilterPill("Morning"),
                                _buildFilterPill("Health"),
                                _buildFilterPill("Mind"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // "My Habits" Section (from Swift Spec)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "My Habits",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.tune_rounded, size: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (totalToday == 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No habits scheduled for this day",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 120),
                              itemCount: scheduledHabits.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height:
                                          0), // Spacing is in the tile margin
                              itemBuilder: (context, index) {
                                final habit = scheduledHabits[index];
                                final isDone = habit.getCompletionPercentage(
                                        normalizedSelected) ==
                                    100;
                                final streak =
                                    HabitStatisticsService.currentStreak(
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
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 110),
        child: FloatingActionButton(
          backgroundColor: AppColors.premiumGreenIndicator,
          onPressed: () {
            FirebaseAnalytics.instance.logEvent(name: 'create_habit_click');
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
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
    );
  }
  Widget _buildFilterPill(String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? AppColors.premiumGreenIndicator.withOpacity(0.4) 
          : const Color(0xFFE2E3D8).withOpacity(0.12), // Ivory tint from Swift Spec
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected ? AppColors.premiumGreenIndicator.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
