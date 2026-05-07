import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';

class StatsActivityTrend extends StatelessWidget {
  final List<FlSpot> spots;
  final int range;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;

  const StatsActivityTrend({
    super.key,
    required this.spots,
    required this.range,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {

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
                  color: AppColors.trendPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.trendPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Activity Trend',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                clipData: const FlClipData.all(),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                    isCurved: false,
                    color: AppColors.trendPrimary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.trendPrimary,
                          strokeWidth: 1.5,
                          strokeColor: AppColors.trendStroke,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.trendPrimary.withOpacity(0.25),
                          AppColors.trendPrimary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value == 50 || value == 100) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                color: textColor.withOpacity(0.3),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 35,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: textColor.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                minX: 0,
                maxX: (range - 1).toDouble(),
                minY: 0,
                maxY: 105,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
