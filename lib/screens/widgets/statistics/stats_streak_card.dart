import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';
import 'dart:math' as math;
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class StatsStreakCard extends StatelessWidget {
  final List<HabitStreak> streaks;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;

  const StatsStreakCard({
    super.key,
    required this.streaks,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
  });

  static const _fireOrange = AppColors.fireOrange;
  static const _fireAmber = AppColors.fireAmber;
  static const _fireRed = AppColors.fireRed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      blur: 15,
      opacity: 0.1,
      borderRadius: 24,
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
              if (streaks.isNotEmpty)
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
                        'Best: ${streaks.map((s) => s.best).reduce(math.max)}d',
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

          if (streaks.isEmpty)
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
              children: List.generate(streaks.length, (i) {
                final streak = streaks[i];
                final isTop = i == 0;
                final rankLabels = ['🥇', '🥈', '🥉'];
                final rankColors = [_fireOrange, _fireAmber, textColor.withOpacity(0.5)];
                final flameSize = isTop ? 40.0 : (i == 1 ? 30.0 : 24.0);
                final daysFontSize = isTop ? 30.0 : (i == 1 ? 22.0 : 17.0);
                final nameFontSize = isTop ? 14.0 : (i == 1 ? 13.0 : 12.0);
                final rowOpacity = isTop ? 1.0 : (i == 1 ? 0.75 : 0.5);

                return Opacity(
                  opacity: rowOpacity,
                  child: Container(
                    margin: EdgeInsets.only(bottom: isTop ? 16 : (i == 1 ? 12 : 0)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isTop ? 16 : (i == 1 ? 12 : 10),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          _fireOrange.withOpacity(isTop ? 0.18 : (i == 1 ? 0.1 : 0.05)),
                          _fireRed.withOpacity(isTop ? 0.06 : 0.02),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isTop ? 20 : 16),
                      border: Border.all(
                        color: _fireOrange.withOpacity(isTop ? 0.25 : 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(rankLabels[i], style: TextStyle(fontSize: isTop ? 22 : (i == 1 ? 18 : 15))),
                        const SizedBox(width: 10),
                        Container(
                          width: flameSize + 12,
                          height: flameSize + 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [_fireAmber, _fireOrange, _fireRed],
                            ),
                            boxShadow: isTop ? [BoxShadow(color: _fireOrange.withOpacity(0.45), blurRadius: 14, offset: const Offset(0, 4))] : [],
                          ),
                          child: Center(child: Icon(Icons.local_fire_department_rounded, color: Colors.white, size: flameSize)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                streak.current > 0 ? 'ON FIRE' : 'BEST',
                                style: TextStyle(color: rankColors[i], fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 9),
                              ),
                              const SizedBox(height: 2),
                              Text(streak.name, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: nameFontSize), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Text(
                          streak.current > 0 ? '${streak.current}d' : '${streak.best}d',
                          style: TextStyle(color: rankColors[i], fontWeight: FontWeight.w900, fontSize: daysFontSize, letterSpacing: -0.5),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
