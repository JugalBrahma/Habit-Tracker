import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class StatsMomentumCard extends StatelessWidget {
  final HabitStreak? streak;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;

  const StatsMomentumCard({
    super.key,
    required this.streak,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
  });

  // Water palette
  static const _waterCyan = AppColors.waterCyan;
  static const _waterBlue = AppColors.waterBlue;
  static const _waterLight = AppColors.waterLight;
  static const _waterDeep = AppColors.waterDeep;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (streak == null) {
      return _buildEmptyState(isDark);
    }

    final currentStreak = streak!.current;
    final bestStreak = streak!.best;
    final displayStreak = currentStreak > 0 ? currentStreak : bestStreak;
    final isDisplayingBest = currentStreak == 0 && bestStreak > 0;
    final nextGoal = _calcNextGoal(displayStreak);
    final progress = nextGoal > 0 ? (displayStreak / nextGoal).clamp(0.0, 1.0) : 0.0;
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

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
                    colors: [_waterCyan.withOpacity(0.2), _waterBlue.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.waves_rounded, color: _waterBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'MOMENTUM',
                    style: TextStyle(
                      color: _waterBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _waterBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop_rounded, color: _waterBlue.withOpacity(0.7), size: 13),
                    const SizedBox(width: 4),
                    Text(
                      'Best: ${bestStreak}d',
                      style: const TextStyle(
                        color: _waterBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ─── STREAK NUMBER SECTION (Blue inner card) ───
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [_waterDeep, AppColors.waterDark1]
                    : [AppColors.waterDark2, _waterBlue],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _waterBlue.withOpacity(isDark ? 0.15 : 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  isDisplayingBest ? 'YOUR BEST STREAK' : 'YOUR CURRENT STREAK',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, _waterCyan],
                      ).createShader(bounds),
                      child: Text(
                        '$displayStreak',
                        style: const TextStyle(
                          fontSize: 68,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: _waterCyan.withOpacity(0.45),
                        size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar
                Row(
                  children: [
                    Text(
                      '$displayStreak DAYS LOGGED',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'NEXT GOAL: $nextGoal',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white.withOpacity(0.12),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: const LinearGradient(colors: [_waterLight, _waterCyan]),
                        boxShadow: [
                          BoxShadow(color: _waterCyan.withOpacity(0.5), blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ─── THIS WEEK DROPS ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : _waterBlue.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : _waterBlue.withOpacity(0.08),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'THIS WEEK',
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final isActive = index < displayStreak.clamp(0, 7);
                    return Column(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 38,
                          child: CustomPaint(
                            painter: _WaterDropPainter(
                              isActive: isActive,
                              isDark: isDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[index],
                          style: TextStyle(
                            color: isActive
                                ? textColor.withOpacity(0.8)
                                : textColor.withOpacity(0.25),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ─── BOTTOM INFO BAR ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : _waterBlue.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : _waterBlue.withOpacity(0.08),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  color: _waterBlue.withOpacity(0.5),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BEST STREAK',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _waterBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _waterBlue.withOpacity(0.15)),
                  ),
                  child: Text(
                    'BEST: $bestStreak',
                    style: const TextStyle(
                      color: _waterBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      blur: 15,
      opacity: 0.1,
      borderRadius: 24,
      child: Column(
        children: [
          Icon(Icons.water_drop_outlined, color: _waterBlue.withOpacity(0.25), size: 48),
          const SizedBox(height: 16),
          Text(
            'No momentum yet',
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete habits consistently to build your flow',
            style: TextStyle(
              color: textColor.withOpacity(0.3),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _calcNextGoal(int current) {
    const milestones = [7, 14, 21, 30, 50, 60, 75, 90, 100, 150, 200, 365];
    for (final m in milestones) {
      if (current < m) return m;
    }
    return ((current ~/ 100) + 1) * 100;
  }
}

// ─── Custom Water Drop Painter ───
class _WaterDropPainter extends CustomPainter {
  final bool isActive;
  final bool isDark;

  _WaterDropPainter({required this.isActive, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final tipY = size.height * 0.05;
    final bottomY = size.height * 0.82;
    final radius = size.width * 0.38;

    final path = Path()
      ..moveTo(cx, tipY)
      ..cubicTo(cx - radius * 1.8, bottomY - radius, cx - radius, bottomY, cx, bottomY)
      ..cubicTo(cx + radius, bottomY, cx + radius * 1.8, bottomY - radius, cx, tipY)
      ..close();

    if (isActive) {
      // Glow
      canvas.drawPath(path, Paint()
        ..color = StatsMomentumCard._waterCyan.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));

      // Gradient fill
      canvas.drawPath(path, Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.waterCyan, AppColors.waterGradientEnd],
          stops: [0.2, 1.0],
        ).createShader(Rect.fromLTWH(0, tipY, size.width, bottomY - tipY)));

      // Highlight
      final hx = cx - radius * 0.25;
      final hy = tipY + (bottomY - tipY) * 0.32;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(hx, hy), width: radius * 0.5, height: radius * 0.8),
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.0)],
          ).createShader(Rect.fromCenter(center: Offset(hx, hy), width: radius * 0.7, height: radius)),
      );

      // Ripple
      final rippleY = bottomY + 3;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, rippleY), width: radius * 2.0, height: 4),
        Paint()
          ..color = StatsMomentumCard._waterCyan.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    } else {
      // Inactive
      final inactiveColor = isDark ? Colors.white.withOpacity(0.07) : Colors.grey.withOpacity(0.12);
      canvas.drawPath(path, Paint()..color = inactiveColor);
      canvas.drawPath(path, Paint()
        ..color = (isDark ? Colors.white : Colors.grey).withOpacity(0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterDropPainter oldDelegate) =>
      isActive != oldDelegate.isActive || isDark != oldDelegate.isDark;
}
