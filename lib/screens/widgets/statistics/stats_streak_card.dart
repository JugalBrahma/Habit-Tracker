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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _fireOrange.withOpacity(isDark ? 0.15 : 0.08),
                    _fireRed.withOpacity(isDark ? 0.05 : 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _fireOrange.withOpacity(isDark ? 0.2 : 0.1),
                ),
              ),
              child: Row(
                children: [
                  // Giant glowing flame
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_fireAmber, _fireOrange, _fireRed],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _fireOrange.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ON FIRE',
                          style: TextStyle(
                            color: _fireOrange,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${streak!.current} Days',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          streak!.name,
                          style: TextStyle(
                            color: textColor.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Best Streak Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      ),
                      boxShadow: isDark ? [] : [
                        BoxShadow(
                          color: _fireOrange.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: _fireAmber,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BEST',
                          style: TextStyle(
                            color: textColor.withOpacity(0.4),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${streak!.best}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
