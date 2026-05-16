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
    final primaryColor = Color(selectedColor);
    const Color textColor = Colors.white;
    final Color secondaryTextColor = Colors.white.withOpacity(0.6);
    final Color inputBgColor = Colors.white.withOpacity(0.05);
    final Color borderColor = Colors.white.withOpacity(0.1);

    return Column(
      children: [
        TextFormField(
          controller: habitname,
          style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: 'Routine Name',
            labelStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
            hintText: 'e.g., Morning Yoga',
            hintStyle: TextStyle(color: textColor.withOpacity(0.2)),
            prefixIcon: Icon(Icons.edit_note, color: primaryColor, size: 22),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          maxLines: 3,
          controller: description,
          style: const TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'Description (optional)',
            labelStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
            hintText: 'Small steps every day...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.2)),
            prefixIcon: Icon(Icons.description_outlined, color: primaryColor, size: 22),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
