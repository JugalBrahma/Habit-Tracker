import 'package:flutter/material.dart';
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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
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
              1: theme.colorScheme.primary.withOpacity(0.2),
              2: theme.colorScheme.primary.withOpacity(0.4),
              3: theme.colorScheme.primary.withOpacity(0.6),
              4: theme.colorScheme.primary.withOpacity(0.8),
              5: theme.colorScheme.primary,
            },
            onClick: (_) {},
          ),
        ],
      ),
    );
  }
}
