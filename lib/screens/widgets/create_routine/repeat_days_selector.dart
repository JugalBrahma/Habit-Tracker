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
    final primaryColor = Color(selectedColor);
    final Color borderColor = Colors.white.withOpacity(0.1);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: weekdays.map((day) {
        final isSelected = selectedRepeatDays.contains(day);

        return GestureDetector(
          onTap: () => onDayToggled(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
