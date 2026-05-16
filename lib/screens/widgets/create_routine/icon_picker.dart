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
    const Color appGreen = Color(0xFF95D878);
    final primaryColor = Color(selectedColor);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final iconData = icons[index];
        final name = iconData['name'] as String;
        final isSelected = name == selectedIconName;

        return GestureDetector(
          onTap: () => onIconSelected(name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withOpacity(0.15)
                  : Colors.white.withOpacity(0.03),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.white.withOpacity(0.08),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              iconData['icon'] as IconData,
              size: 22,
              color: isSelected ? appGreen : Colors.white.withOpacity(0.4),
            ),
          ),
        );
      },
    );
  }
}
