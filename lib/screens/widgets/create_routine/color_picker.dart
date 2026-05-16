import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Map<String, dynamic>> colors;
  final int selectedColor;
  final Function(int) onColorSelected;

  const ColorPicker({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final value = color['color'] as int;
        final isSelected = value == selectedColor;
        return GestureDetector(
          onTap: () => onColorSelected(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Color(value),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Color(value).withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                width: isSelected ? 3 : 1.5,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
