import 'package:flutter/material.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';

class StatsOverallCard extends StatelessWidget {
  final StatisticsSnapshot snapshot;
  final int dateRange;

  const StatsOverallCard({
    super.key,
    required this.snapshot,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassContainer(
      width: double.infinity,
      height: 200,
      blur: 20,
      opacity: 0.15,
      borderRadius: 24,
      color: theme.colorScheme.primary,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: -15,
              child: AnimatedTreeBg(score: snapshot.completionRate.toDouble()),
            ),
            Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Score',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${snapshot.completionRate}%',
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Completion rate based on your activity',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Last $dateRange Days',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${snapshot.completed}',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class AnimatedTreeBg extends StatefulWidget {
  final double score;

  const AnimatedTreeBg({super.key, required this.score});

  @override
  State<AnimatedTreeBg> createState() => _AnimatedTreeBgState();
}

class _AnimatedTreeBgState extends State<AnimatedTreeBg> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Score determines base size (min 80, max 220)
    final double targetSize = 80.0 + (widget.score.clamp(0.0, 100.0) * 1.4);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Gentle sway from -0.04 to 0.04 radians
        final angle = (_controller.value - 0.5) * 0.08;
        // Subtle breathing (1.0 to 1.05)
        final scale = 1.0 + (_controller.value * 0.05);

        return Transform.rotate(
          angle: angle,
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.park_rounded,
              size: targetSize,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
        );
      },
    );
  }
}
