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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final primaryColor = Color(selectedColor);
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
        : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.timer_rounded, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Time Goal',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    targetMinutes == null ? 'No time limit' : 'Target per session',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Switch(
                value: targetMinutes != null,
                activeColor: primaryColor,
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
            const SizedBox(height: 20),
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
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Max: 4h',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
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
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                              ),
                            ),
                          ),
                          // Loading Bar Fill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 14,
                            width: width * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          // Interative Thumb (Glassy)
                          Positioned(
                            left: (width * progress) - 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
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
      ),
    );
  }
}
