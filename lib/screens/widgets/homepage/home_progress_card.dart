import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class HomeProgressCard extends StatelessWidget {
  final double done;
  final int total;
  final DateTime selectedDate;

  const HomeProgressCard({
    super.key,
    required this.done,
    required this.total,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? done / total : 0;
    int doneCount = done.toInt();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.81),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(9, 73, 19, 0.38),
                  borderRadius: BorderRadius.circular(30.81),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE , MMM d')
                                    .format(selectedDate)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Your Daily",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                "Overview",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.premiumGreenIndicator),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Progress",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$doneCount / $total done",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          children: [
                            Container(
                              height: 36,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress.clamp(0.0, 1.0),
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.premiumGreenIndicator
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: Row(
                                children: [
                                  _buildHabitIcon(Icons.water_drop,
                                      const Color(0xFF4FC3F7), true),
                                  _buildHabitIcon(Icons.self_improvement,
                                      Colors.orangeAccent, true),
                                  _buildHabitIcon(
                                      Icons.eco, Colors.greenAccent, true),
                                  _buildHabitIcon(
                                      Icons.menu_book, Colors.redAccent, false),
                                  _buildHabitIcon(
                                      Icons.person, Colors.amberAccent, false),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _buildHabitIcon(IconData icon, Color color, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDone ? color : Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 14,
        color: isDone ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    );
  }
}
