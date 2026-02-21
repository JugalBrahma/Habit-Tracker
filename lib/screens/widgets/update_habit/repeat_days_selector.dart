import 'package:flutter/material.dart';

class RepeatDaysSelector extends StatelessWidget {
  final List<String> weekdays;
  final Set<String> selectedRepeatDays;
  final int selectedColor;
  final Function(String) onDayToggled;

  const RepeatDaysSelector({
    super.key,
    required this.weekdays,
    required this.selectedRepeatDays,
    required this.selectedColor,
    required this.onDayToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final primaryColor = Color(selectedColor);
    final borderColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: weekdays.map((day) {
        final isSelected = selectedRepeatDays.contains(day);

        return GestureDetector(
          onTap: () => onDayToggled(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : (isDark ? colorScheme.surfaceContainer : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
