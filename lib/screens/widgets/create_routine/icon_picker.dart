import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final List<Map<String, dynamic>> icons;
  final String selectedIconName;
  final int selectedColor;
  final Function(String) onIconSelected;

  const IconPicker({
    super.key,
    required this.icons,
    required this.selectedIconName,
    required this.selectedColor,
    required this.onIconSelected,
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
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            final iconData = icons[index];
            final name = iconData['name'] as String;
            final isSelected = name == selectedIconName;

            return GestureDetector(
              onTap: () => onIconSelected(name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withOpacity(0.1)
                      : (isDark
                            ? colorScheme.surface
                            : Colors.grey[50]!.withOpacity(0.5)),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  iconData['icon'] as IconData,
                  size: 24,
                  color: isSelected
                      ? primaryColor
                      : colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
