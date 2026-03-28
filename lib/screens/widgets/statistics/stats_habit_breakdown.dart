import 'package:flutter/material.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'dart:math' as math;

class StatsHabitBreakdown extends StatelessWidget {
  final List<HabitBreakdown> breakdowns;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;

  const StatsHabitBreakdown({
    super.key,
    required this.breakdowns,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
  });

  static const Map<String, IconData> _kHabitIcons = {
    'Fitness': Icons.fitness_center,
    'Run': Icons.directions_run,
    'Meditate': Icons.self_improvement,
    'Read': Icons.book,
    'Water': Icons.water,
    'Sleep': Icons.bedtime,
    'Medicine': Icons.medication,
    'Food': Icons.restaurant,
    'Code': Icons.code,
    'Write': Icons.create,
    'Music': Icons.music_note,
    'Save': Icons.savings,
    'Nature': Icons.eco,
    'Art': Icons.brush,
    'Computer': Icons.computer,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort by percentage descending
    final sorted = List<HabitBreakdown>.from(breakdowns)
      ..sort((a, b) => b.percent.compareTo(a.percent));

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
          // ─── HEADER ───
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6C63FF).withOpacity(0.15),
                      const Color(0xFFB388FF).withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.donut_large_rounded,
                  color: Color(0xFF6C63FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habit Breakdown',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${sorted.length} habits tracked',
                      style: TextStyle(
                        color: textColor.withOpacity(0.4),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Average badge
              if (sorted.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFF6C63FF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'AVG ${_average(sorted).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF6C63FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── HABIT ROWS ───
          if (sorted.isEmpty)
            Center(
              child: Text(
                'No habits to show yet.',
                style: TextStyle(
                  color: textColor.withOpacity(0.4),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...sorted.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final badgeColor = Color(item.color);
              final colors = [badgeColor, badgeColor.withAlpha(0xB3)]; // B3 is 70% opacity for a subtle gradient effect
              final icon = _kHabitIcons[item.iconName] ?? Icons.circle;
              final pct = item.percent;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < sorted.length - 1 ? 12 : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : colors[0].withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : colors[0].withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank / Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: colors,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colors[0].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),

                      // Name + progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Gradient progress bar
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : colors[0].withOpacity(0.1),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (pct / 100).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    gradient: LinearGradient(colors: colors),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors[0].withOpacity(0.4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Circular percentage ring
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: CustomPaint(
                                painter: _RingPainter(
                                  progress: pct / 100,
                                  gradientColors: colors,
                                  bgOpacity: isDark ? 0.08 : 0.12,
                                ),
                              ),
                            ),
                            Text(
                              '${pct.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  double _average(List<HabitBreakdown> items) {
    if (items.isEmpty) return 0;
    return items.map((e) => e.percent).reduce((a, b) => a + b) / items.length;
  }
}

// ─── Custom Ring Painter ───
class _RingPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double bgOpacity;

  _RingPainter({
    required this.progress,
    required this.gradientColors,
    required this.bgOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    const strokeWidth = 4.0;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    // Background ring
    final bgPaint = Paint()
      ..color = gradientColors[0].withOpacity(bgOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0) return;

    // Gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: gradientColors,
    );
    final arcPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
