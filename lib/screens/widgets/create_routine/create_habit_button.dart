import 'package:flutter/material.dart';

class CreateHabitButton extends StatelessWidget {
  final VoidCallback onTap;
  final int selectedColor;
  final String text;

  const CreateHabitButton({
    super.key,
    required this.onTap,
    required this.selectedColor,
    this.text = 'Create Habit',
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(selectedColor);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
