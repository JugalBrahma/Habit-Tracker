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
    const Color appGreen = Color(0xFF95D878);
    final primaryColor = Color(selectedColor);

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: const Icon(Icons.flag_rounded, color: appGreen, size: 20),
            ),
            const SizedBox(width: 14),
            const Text(
              'Goal days',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${targetDays.round()} days',
              style: const TextStyle(
                fontSize: 15,
                color: appGreen,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primaryColor,
            inactiveTrackColor: Colors.white.withOpacity(0.05),
            thumbColor: Colors.white,
            overlayColor: primaryColor.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            min: 7,
            max: 60,
            value: targetDays,
            onChanged: onGoalChanged,
          ),
        ),
      ],
    );
  }
}
