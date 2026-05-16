import 'package:flutter/material.dart';

class TimeGoalSelector extends StatelessWidget {
  final int? targetMinutes;
  final int selectedColor;
  final Function(int?) onTimeGoalChanged;

  const TimeGoalSelector({
    super.key,
    required this.targetMinutes,
    required this.selectedColor,
    required this.onTimeGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color appGreen = Color(0xFF95D878);
    final primaryColor = Color(selectedColor);

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: const Icon(Icons.timer_rounded, color: appGreen, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Time Goal',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  targetMinutes == null ? 'No time limit' : 'Target per session',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Switch(
              value: targetMinutes != null,
              activeColor: appGreen,
              activeTrackColor: appGreen.withOpacity(0.3),
              inactiveThumbColor: Colors.white.withOpacity(0.2),
              inactiveTrackColor: Colors.white.withOpacity(0.05),
              onChanged: (val) {
                if (val) {
                  onTimeGoalChanged(30); // Default 30 mins
                } else {
                  onTimeGoalChanged(null);
                }
              },
            ),
          ],
        ),
        if (targetMinutes != null) ...[
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final progress = (targetMinutes! - 5) / (240 - 5);
              
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Target: ${targetMinutes}m',
                        style: const TextStyle(
                          fontSize: 14,
                          color: appGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Max: 4h',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final localPos = details.localPosition.dx;
                      final newProgress = (localPos / width).clamp(0.0, 1.0);
                      final newMinutes = (5 + newProgress * (240 - 5)).round();
                      onTimeGoalChanged(newMinutes);
                    },
                    onTapDown: (details) {
                      final localPos = details.localPosition.dx;
                      final newProgress = (localPos / width).clamp(0.0, 1.0);
                      final newMinutes = (5 + newProgress * (240 - 5)).round();
                      onTimeGoalChanged(newMinutes);
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.none,
                      children: [
                        // Background "Track"
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Loading Bar Fill
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          height: 8,
                          width: width * progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        // Interactive Thumb
                        Positioned(
                          left: (width * progress) - 9,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
