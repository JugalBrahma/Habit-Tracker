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
    const Color appGreen = Color(0xFF95D878);
    const Color appGreenDark = Color(0xFF3E7B27);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [appGreen, appGreenDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: appGreen.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
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
