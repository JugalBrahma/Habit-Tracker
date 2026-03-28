import 'package:flutter/material.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';

class StatsStreakCard extends StatelessWidget {
  final HabitStreak? streak;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;

  const StatsStreakCard({
    super.key,
    required this.streak,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
  });

  // Fire palette
  static const _fireOrange = Color(0xFFFF6D00);
  static const _fireAmber = Color(0xFFFFAB00);
  static const _fireRed = Color(0xFFFF3D00);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: _fireOrange.withOpacity(isDark ? 0.05 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── HEADER ───
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_fireOrange.withOpacity(0.15), _fireAmber.withOpacity(0.15)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: _fireOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Streaks',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              if (streak != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _fireOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, color: _fireAmber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Best: ${streak!.best}d',
                        style: const TextStyle(
                          color: _fireOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          if (streak == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.local_fire_department_outlined,
                        color: textColor.withOpacity(0.2), size: 44),
                    const SizedBox(height: 12),
                    Text(
                      'No streak data yet. Keep going!',
                      style: TextStyle(
                        color: textColor.withOpacity(0.4),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                // ─── MAIN STREAK DISPLAY ───
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _fireOrange.withOpacity(isDark ? 0.12 : 0.06),
                        _fireAmber.withOpacity(isDark ? 0.06 : 0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _fireOrange.withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      // Fire streak number
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_fireAmber, _fireOrange, _fireRed],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: _fireOrange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${streak!.current}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              streak!.name,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${streak!.current} day streak',
                              style: TextStyle(
                                color: textColor.withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Flame indicator
                      Column(
                        children: List.generate(3, (i) {
                          final isLit = streak!.current > i * 3;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              size: 20,
                              color: isLit
                                  ? [_fireAmber, _fireOrange, _fireRed][i]
                                  : textColor.withOpacity(0.1),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ─── WEEKLY FIRE DOTS ───
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : _fireOrange.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : _fireOrange.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final isActive = index < streak!.current.clamp(0, 7);
                      final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      return Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isActive
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [_fireAmber, _fireOrange],
                                    )
                                  : null,
                              color: isActive
                                  ? null
                                  : (isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.grey.withOpacity(0.1)),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: _fireOrange.withOpacity(0.35),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: isActive
                                  ? const Icon(
                                      Icons.local_fire_department_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: textColor.withOpacity(0.15),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dayLabels[index],
                            style: TextStyle(
                              color: isActive
                                  ? textColor.withOpacity(0.8)
                                  : textColor.withOpacity(0.3),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
