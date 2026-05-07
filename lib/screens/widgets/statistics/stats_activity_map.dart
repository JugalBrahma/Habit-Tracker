import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatsActivityMap extends StatelessWidget {
  final Map<DateTime, int> data;
  final Color cardBg;
  final Color borderColor;

  const StatsActivityMap({
    super.key,
    required this.data,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Transparent faint → bright vivid Nvidia green (more ticks = brighter)
    final heatMapColors = [
      const Color(0xFF76B900).withOpacity(0.12),
      const Color(0xFF76B900).withOpacity(0.30),
      const Color(0xFF76B900).withOpacity(0.55),
      const Color(0xFF76B900).withOpacity(0.80),
      const Color(0xFF76B900),                   // full bright Nvidia green
    ];

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      blur: 15,
      opacity: 0.1,
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Activity Map',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          HeatMapCalendar(
            textColor: theme.colorScheme.onSurface.withOpacity(0.6),
            defaultColor: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey[100],
            fontSize: 12,
            monthFontSize: 14,
            weekFontSize: 10,
            flexible: true,
            colorMode: ColorMode.color,
            datasets: data,
            colorsets: {
              1: heatMapColors[0],
              2: heatMapColors[1],
              3: heatMapColors[2],
              4: heatMapColors[3],
              5: heatMapColors[4],
            },
            onClick: (_) {},
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: heatMapColors[index],
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(
                'More',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
