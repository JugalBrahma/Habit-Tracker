import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeProgressCard extends StatelessWidget {
  final int done;
  final int total;
  final DateTime selectedDate;

  const HomeProgressCard({
    super.key,
    required this.done,
    required this.total,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? done / total : 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark 
              ? theme.colorScheme.surfaceContainerHighest 
              : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: isDark 
              ? Border.all(color: Colors.white.withOpacity(0.05), width: 1.5) 
              : Border.all(color: Colors.transparent, width: 1.5),
          boxShadow: isDark 
              ? [] 
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(selectedDate).toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your Daily\nOverview",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "$done of $total habits completed",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
