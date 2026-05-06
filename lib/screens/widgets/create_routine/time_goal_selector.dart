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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${targetMinutes} minutes',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor: primaryColor.withOpacity(0.1),
                thumbColor: Colors.white,
                overlayColor: primaryColor.withOpacity(0.2),
                trackHeight: 6,
              ),
              child: Slider(
                min: 5,
                max: 240,
                divisions: 47,
                value: targetMinutes!.toDouble(),
                onChanged: (val) => onTimeGoalChanged(val.round()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
