import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/repositery/statistics_service.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int date = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/image 1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: BlocBuilder<HabitService, HabitStates>(
              builder: (context, state) {
                if (state is! HabitLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ignore: unused_local_variable
                final stats = HabitStatisticsService.derive(
                  habits: state.habits,
                  rangeDays: date,
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: _buildGlassAction(Icons.arrow_back),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      
                      // Overall Score Header
                      _buildSectionHeader('Overall Score'),
                      const SizedBox(height: 12),
                      
                      // Hero Summary Card
                      _buildHeroCard(),
                      const SizedBox(height: 30),

                      // Performance Chart Card
                      _buildSectionHeader('Performance'),
                      const SizedBox(height: 12),
                      _buildPerformanceChart(),
                      
                      const SizedBox(height: 30),

                      // Streak Momentum Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('Streak momentum'),
                          Text(
                            'Calendar',
                            style: TextStyle(
                              color: const Color(0xFF1F5A25).withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStreakMomentumCard(),

                      const SizedBox(height: 30),
                      
                      // Goals & Progress Card
                      _buildSectionHeader('Goals & Progress'),
                      const SizedBox(height: 12),
                      _buildGoalsAndProgress(),
                      
                      const SizedBox(height: 30),
                      
                      // Monthly Growth Chart Card
                      _buildSectionHeader('Monthly Growth'),
                      const SizedBox(height: 12),
                      _buildGrowthChart(),
                      
                      const SizedBox(height: 30),
                      
                      // Heatmap Card (Last)
                      _buildSectionHeader('Consistency'),
                      const SizedBox(height: 12),
                      _buildHeatmapCalendar(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.9),
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildGlassAction(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, double? height, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          height: height,
          padding: padding ?? const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return _buildGlassCard(
      height: 260,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '87',
                    style: TextStyle(
                      color: Color(0xFF1F5A25),
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consistency score',
                    style: TextStyle(
                      color: const Color(0xFF1F5A25).withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '+12% from last week',
                    style: TextStyle(
                      color: Color(0xFF1F5A25),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: 0.87,
                      strokeWidth: 14,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7FD88B)),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const Text(
                    '87%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F5A25),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallPill('79%'),
              _buildSmallPill('82%'),
              _buildSmallPill('91%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallPill(String value) {
    return Container(
      width: 90,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1F5A25),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStreakMomentumCard() {
    return _buildGlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '18',
                    style: TextStyle(
                      color: Color(0xFF1F5A25),
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'day current streak',
                        style: TextStyle(
                          color: const Color(0xFF1F5A25).withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Longest 42 days',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5A25).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Best time',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                    Text(
                      '7:30 AM',
                      style: TextStyle(
                        color: Color(0xFF7FD88B),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayPill('M', true),
              _buildDayPill('T', true),
              _buildDayPill('W', true),
              _buildDayPill('T', true),
              _buildDayPill('F', true),
              _buildDayPill('S', false),
              _buildDayPill('S', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayPill(String day, bool isDone) {
    return Container(
      width: 42,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: const Color(0xFF1F5A25).withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFF1F5A25) : Colors.black12,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return _buildGlassCard(
      height: 280,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Activity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.figmaGreenLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'This Week',
                        style: TextStyle(
                          color: AppColors.figmaGreenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Average: 84%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 80,
            child: CustomPaint(
              painter: _ChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsAndProgress() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly progress rings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing('Focus', 0.82, AppColors.figmaCyan),
              _buildProgressRing('Health', 0.65, AppColors.figmaGreenLight),
              _buildProgressRing('Mind', 0.90, AppColors.figmaYellow),
            ],
          ),
          const SizedBox(height: 30),
          // Goals list
          _buildGoalItem('Hydration Goal', 0.85, '1.2L left', AppColors.figmaCyan),
          _buildGoalItem('Reading Session', 0.60, '15m left', AppColors.figmaYellow),
          _buildGoalItem('Daily Steps', 0.95, '200 left', AppColors.figmaGreenLight),
        ],
      ),
    );
  }

  Widget _buildProgressRing(String label, double progress, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(String title, double progress, String sub, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.5), color],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapCalendar() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'May 2024',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.5), size: 20),
                  const SizedBox(width: 15),
                  Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5), size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 10),
          // Heatmap grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 35, // Show 5 weeks
            itemBuilder: (context, index) {
              if (index < 3 || index > 33) { // Mock empty days at start/end
                return Container();
              }
              final intensity = (index * 13 % 10) / 10.0;
              return Container(
                decoration: BoxDecoration(
                  color: intensity < 0.2 
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.figmaGreenLight.withOpacity(0.1 + intensity * 0.7),
                  borderRadius: BorderRadius.circular(4),
                  border: intensity > 0.8 
                    ? Border.all(color: Colors.white.withOpacity(0.2), width: 1)
                    : null,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4))),
              const SizedBox(width: 6),
              ...List.generate(5, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.figmaGreenLight.withOpacity(0.1 + (i * 0.2)),
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(width: 6),
              Text('More', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthChart() {
    return _buildGlassCard(
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completion Trends',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildGrowthBar('Mar', 0.45, AppColors.figmaCyan),
                _buildGrowthBar('Apr', 0.72, AppColors.figmaYellow),
                _buildGrowthBar('May', 0.88, AppColors.figmaGreenLight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthBar(String label, double progress, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 120 * progress,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withOpacity(0.2)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.figmaGreenLight.withOpacity(0.8)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.figmaGreenLight.withOpacity(0.3),
          AppColors.figmaGreenLight.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (int i = 0; i < 5; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data points
    final List<double> values = [0.4, 0.7, 0.5, 0.8, 0.6, 0.9, 0.85];
    final List<Offset> points = [];

    double xStep = size.width / (values.length - 1);
    for (int i = 0; i < values.length; i++) {
      points.add(Offset(i * xStep, size.height * (1 - values[i])));
    }

    // Draw area under line
    final path = Path();
    path.moveTo(0, size.height);
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.lineTo(points[i].dx, points[i].dy);
      } else {
        // Smooth curve
        var prev = points[i - 1];
        var curr = points[i];
        path.cubicTo(
          prev.dx + xStep / 2, prev.dy,
          curr.dx - xStep / 2, curr.dy,
          curr.dx, curr.dy,
        );
      }
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, areaPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      var prev = points[i - 1];
      var curr = points[i];
      linePath.cubicTo(
        prev.dx + xStep / 2, prev.dy,
        curr.dx - xStep / 2, curr.dy,
        curr.dx, curr.dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 6, Paint()..color = AppColors.figmaGreenLight.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}