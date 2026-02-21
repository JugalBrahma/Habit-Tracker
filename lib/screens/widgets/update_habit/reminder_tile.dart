import 'package:flutter/material.dart';

class ReminderTile extends StatelessWidget {
  final TimeOfDay? reminderTime;
  final int selectedColor;
  final Function(TimeOfDay?) onReminderChanged;

  const ReminderTile({
    super.key,
    required this.reminderTime,
    required this.selectedColor,
    required this.onReminderChanged,
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

    final reminderText = reminderTime != null
        ? reminderTime!.format(context)
        : 'Set a daily reminder';

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: reminderTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          onReminderChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.alarm, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminder",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reminderText,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurface.withOpacity(0.1),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
