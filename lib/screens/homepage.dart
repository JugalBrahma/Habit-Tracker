import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';

import 'package:intl/intl.dart';
import 'package:habit_tracker/screens/widgets/homepage/home_drawer.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';

extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) {
    final hour = this.hour;
    final minute = this.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/image 1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Status bar and time
                  _buildStatusBar(),
                  // Header with app title and user profile
                  _buildHeader(),
                  const SizedBox(height: 20),
                  // Daily Overview Card
                  _buildDailyOverviewCard(),
                  const SizedBox(height: 20),
                  // Date selector pills
                  _buildDateSelector(),
                  const SizedBox(height: 16),
                  // My Habits section
                  _buildMyHabitsSection(),
                  const SizedBox(height: 16),
                  // Habit cards
                  _buildHabitCards(),
                  const SizedBox(height: 100), // Bottom padding for FAB
                ],
              ),
            ),
          ),
          // Floating Add Button
          Positioned(
            right: 16,
            top: 328,
            child: _buildAddButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:54',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const Text(
            '●●●  WiFi  ▮',
            style: TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 10,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'HabitFlow.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          Row(
            children: [
              // User avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'JB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Notification bell
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    '🔔',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyOverviewCard() {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMM d').format(now).toUpperCase();
    
    return BlocBuilder<HabitService, HabitStates>(
      builder: (context, state) {
        int totalHabits = 0;
        int completedHabits = 0;
        
        if (state is HabitLoaded) {
          final weekdayLabel = DateFormat.E('en_US').format(now);
          final scheduledHabits = state.habits
              .where((habit) => habit.repeatDays.contains(weekdayLabel))
              .toList();
          totalHabits = scheduledHabits.length;
          completedHabits = scheduledHabits.where((habit) => 
            habit.getCompletionPercentage(now) == 100).length;
        }
        
        final progressPercentage = totalHabits > 0 ? (completedHabits / totalHabits * 100).round() : 0;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 11),
          height: 157,
          decoration: BoxDecoration(
            color: const Color(0x61094A13),
            borderRadius: BorderRadius.circular(30.8),
          ),
          child: Stack(
            children: [
              // Main content
              Positioned(
                left: 22,
                top: 26,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your Daily',
                      style: TextStyle(
                        color: Color(0xFF1A1C16),
                        fontSize: 22,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Color(0xFF1A1C16),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              // Progress circle
              Positioned(
                right: 47,
                top: 22,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color(0x7384E600),
                      width: 9,
                    ),
                    borderRadius: BorderRadius.circular(119.34),
                  ),
                  child: Center(
                    child: Text(
                      '$progressPercentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              // Progress bar section
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 252,
                  height: 63,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(27),
                      bottomRight: Radius.circular(27),
                      topRight: Radius.circular(27),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Progress",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              '$completedHabits / $totalHabits done',
                              style: const TextStyle(
                                color: Color(0xFFA8D5A0),
                                fontSize: 10,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        Container(
                          width: 213,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: totalHabits > 0 ? completedHabits / totalHabits : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF7FD88B),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Habit icons
                        Row(
                          children: [
                            Container(
                              width: 17,
                              height: 17,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('💧', style: TextStyle(fontSize: 10)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 17,
                              height: 17,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('🧘', style: TextStyle(fontSize: 10)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 17,
                              height: 17,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('📚', style: TextStyle(fontSize: 10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final startDate = now.subtract(Duration(days: now.weekday % 7));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(7, (index) {
          final date = startDate.add(Duration(days: index));
          final isSelected = date.day == now.day;
          final dayName = days[date.weekday % 7];
          final dayNumber = date.day.toString();
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 31,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0x6F2D82EA) 
                    : const Color(0x1FE2E3D8),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dayNumber,
                      style: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMyHabitsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Habits',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCards() {
    return BlocBuilder<HabitService, HabitStates>(
      builder: (context, state) {
        if (state is HabitLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is HabitLoaded) {
          final now = DateTime.now();
          final weekdayLabel = DateFormat.E('en_US').format(now);
          final scheduledHabits = state.habits
              .where((habit) => habit.repeatDays.contains(weekdayLabel))
              .toList();
          
          if (scheduledHabits.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No habits scheduled for today',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
          
          return Column(
            children: scheduledHabits.asMap().entries.map((entry) {
              final index = entry.key;
              final habit = entry.value;
              final isDone = habit.getCompletionPercentage(now) == 100;
              final streak = HabitStatisticsService.currentStreak(habit, now);
              
              return _buildHabitCard(
                habit: habit,
                isDone: isDone,
                streak: streak,
                showProgress: index == 1, // Show progress bar for second card
              );
            }).toList(),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHabitCard({
    required dynamic habit,
    required bool isDone,
    required int streak,
    bool showProgress = false,
  }) {
    // Dynamic icon mapping with better visual variety
    final iconData = _getIconData(habit.iconName);
    final icon = iconData['icon'];
    final color = iconData['color'];
    final backgroundColor = iconData['backgroundColor'];
    
    return Container(
      margin: const EdgeInsets.only(left: 11, right: 11, bottom: 12),
      height: showProgress ? 98 : 84,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            left: 14,
            top: 16,
            bottom: showProgress ? 30 : 16,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Icon circle with dynamic background
          Positioned(
            left: 24,
            top: 18,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
          // Habit details
          Positioned(
            left: 82,
            top: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${habit.reminderTime?.format(context) ?? 'No time'} · ${habit.targetMinutes != null ? '${habit.targetMinutes}min' : 'No duration'}',
                  style: const TextStyle(
                    color: Color(0xFFC8EEC0),
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Duration and streak badges
          Positioned(
            left: 82,
            top: 54,
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      habit.targetMinutes != null ? '${habit.targetMinutes}min' : 'No duration',
                      style: const TextStyle(
                        color: Color(0xFFC8EEC0),
                        fontSize: 9,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 56,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '🔥$streak days',
                      style: const TextStyle(
                        color: Color(0xFFC8EEC0),
                        fontSize: 9,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Progress indicator (for second card)
          if (showProgress) ...[
            // Progress line
            Positioned(
              left: 29,
              top: 88,
              child: Container(
                width: 292,
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            // Progress arrow
            Positioned(
              left: 224,
              top: 82,
              child: Container(
                width: 19,
                height: 12,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
            // Progress percentage
            Positioned(
              right: 30,
              top: 37,
              child: const Text(
                '75%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
          // Checkbox
          Positioned(
            right: 30,
            top: 26,
            child: GestureDetector(
              onTap: () {
                // Toggle habit completion
                // TODO: Implement habit completion logic
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Center(
        child: Text(
          '+',
          style: TextStyle(
            color: Color(0xFF7FD88B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // Dynamic icon data provider
  Map<String, dynamic> _getIconData(String iconName) {
    final iconMap = {
      'sunny': {
        'icon': '☀️',
        'color': const Color(0xFFFFB300), // Bright yellow
        'backgroundColor': const Color(0xFFFFF3E0), // Light yellow
      },
      'book': {
        'icon': '📚',
        'color': const Color(0xFF1976D2), // Blue
        'backgroundColor': const Color(0xFFE3F2FD), // Light blue
      },
      'run': {
        'icon': '🏃',
        'color': const Color(0xFFFF5722), // Orange
        'backgroundColor': const Color(0xFFFBE9E7), // Light orange
      },
      'water': {
        'icon': '💧',
        'color': const Color(0xFF03A9F4), // Light blue
        'backgroundColor': const Color(0xFFE1F5FE), // Very light blue
      },
      'meditation': {
        'icon': '🧘',
        'color': const Color(0xFF9C27B0), // Purple
        'backgroundColor': const Color(0xFFF3E5F5), // Light purple
      },
      'workout': {
        'icon': '💪',
        'color': const Color(0xFFE91E63), // Pink
        'backgroundColor': const Color(0xFFFCE4EC), // Light pink
      },
      'study': {
        'icon': '📖',
        'color': const Color(0xFF009688), // Teal
        'backgroundColor': const Color(0xFFE0F2F1), // Light teal
      },
      'sleep': {
        'icon': '😴',
        'color': const Color(0xFF3F51B5), // Indigo
        'backgroundColor': const Color(0xFFE8EAF6), // Light indigo
      },
      'eat': {
        'icon': '🥗',
        'color': const Color(0xFF4CAF50), // Green
        'backgroundColor': const Color(0xFFE8F5E8), // Light green
      },
      'code': {
        'icon': '💻',
        'color': const Color(0xFF607D8B), // Blue grey
        'backgroundColor': const Color(0xFFECEFF1), // Light blue grey
      },
    };
    
    return iconMap[iconName] ?? {
      'icon': '📌',
      'color': const Color(0xFF757575), // Grey
      'backgroundColor': const Color(0xFFFAFAFA), // Light grey
    };
  }
}
