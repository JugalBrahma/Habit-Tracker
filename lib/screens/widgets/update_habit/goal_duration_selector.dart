import 'package:flutter/material.dart';

class GoalDurationSelector extends StatelessWidget {
  final double targetDays;
  final int selectedColor;
  final Function(double) onGoalChanged;

  const GoalDurationSelector({
    super.key,
    required this.targetDays,
    required this.selectedColor,
    required this.onGoalChanged,
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
                child: Icon(Icons.flag_rounded, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                'Goal days',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${targetDays.round()} days',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryColor,
              inactiveTrackColor: primaryColor.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: primaryColor.withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              min: 7,
              max: 60,
              value: targetDays,
              onChanged: onGoalChanged,
            ),
          ),
        ],
      ),
    );
  }
}
