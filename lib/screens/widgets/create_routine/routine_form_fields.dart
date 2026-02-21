import 'package:flutter/material.dart';

class RoutineFormFields extends StatelessWidget {
  final TextEditingController habitname;
  final TextEditingController description;
  final int selectedColor;

  const RoutineFormFields({
    super.key,
    required this.habitname,
    required this.description,
    required this.selectedColor,
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
    final textColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurface.withOpacity(0.6);

    return Column(
      children: [
        TextFormField(
          controller: habitname,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: 'Routine Name',
            labelStyle: TextStyle(color: secondaryTextColor),
            hintText: 'e.g., Morning Yoga',
            hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
            prefixIcon: Icon(Icons.edit_note, color: primaryColor),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          maxLines: 3,
          controller: description,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: 'Description (optional)',
            labelStyle: TextStyle(color: secondaryTextColor),
            hintText: 'Small steps every day...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
            prefixIcon: Icon(Icons.description_outlined, color: primaryColor),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
