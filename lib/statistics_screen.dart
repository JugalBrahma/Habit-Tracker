import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/statistics_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int date = 7;

  @override
  Widget build(BuildContext context) {
    Color backgroundcolor = Theme.of(context).colorScheme.surfaceContainer;
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(15),
              value: date,
              elevation: 8,
              isDense: true,
              underline: SizedBox(),
              items: [
                DropdownMenuItem(value: 7, child: Text('7 days')),
                DropdownMenuItem(value: 30, child: Text('30 days')),
                DropdownMenuItem(value: 90, child: Text('90 days')),
              ],
              onChanged: (value) {
                setState(() {
                  date = value!;
                });
              },
              icon: Icon(Icons.arrow_drop_down_rounded),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HabitService, HabitStates>(
        builder: (context, state) {
          if (state is! HabitLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = HabitStatisticsService.derive(
            habits: state.habits,
            rangeDays: date,
          );

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _overallCard(context, stats),
                    const SizedBox(height: 20),
                    _chart(context, backgroundcolor, stats.trendSpots),
                    const SizedBox(height: 20),
                    _breakdown(context, backgroundcolor, stats.breakdown),
                    const SizedBox(height: 20),
                    _streak(context, backgroundcolor, stats.topStreak),
                    const SizedBox(height: 20),
                    _activitymap(context, stats.heatmapData),
                    const SizedBox(height: 100), // Space for floating nav bar
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _overallCard(BuildContext context, StatisticsSnapshot snapshot) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
                ]
              : [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overall Score',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(flex: 2),
                Text(
                  '${snapshot.completionRate}%',
                  style: const TextStyle(
                    fontSize: 65,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Completion Rate',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: 95,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(31, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Last $date days',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Text(
                  '${snapshot.completed}',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Done',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chart(
    BuildContext context,
    Color backgroundcolor,
    List<FlSpot> spots,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      color: backgroundcolor,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded),
              SizedBox(width: 10),
              Text('Trend'),
            ],
          ),
          SizedBox(height: 50),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 19.0,
                vertical: 9,
              ),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots.isEmpty ? [FlSpot(0, 0)] : spots,

                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
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
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdown(
    BuildContext context,
    Color backgroundcolor,
    List<HabitBreakdown> breakdowns,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart_rounded),
                SizedBox(width: 10),
                Text(
                  'Breakdown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                ...breakdowns.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${item.percent.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(19),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          value: item.percent / 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _streak(
    BuildContext context,
    Color backgroundcolor,
    HabitStreak? streak,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_fire_department_rounded),
                SizedBox(width: 10),
                Text('Streaks', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 30),
            if (streak == null)
              const Text('No streak data yet')
            else
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface, // Adaptive surface
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer, // Adaptive container
                                ),
                                child: Icon(
                                  Icons.bolt,
                                  color: Theme.of(context).colorScheme.primary,
                                ), // Adaptive icon
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    streak.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Best: ${streak.best} day${streak.best == 1 ? '' : 's'}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant, // Adaptive text
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${streak.current}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary, // Adaptive text
                                ),
                              ),
                              Text(
                                'Current',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant, // Adaptive text
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _activitymap(BuildContext context, Map<DateTime, int> data) {
    return Card(
      elevation: 0, // Removed elevation to match style
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainer, // Adaptive background
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 10),
                Text(
                  'Activity Map',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20), // Added spacing
            HeatMapCalendar(
              textColor: Theme.of(
                context,
              ).colorScheme.onSurface, // Adaptive text
              defaultColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest, // Adaptive empty cells
              flexible: true,
              colorMode: ColorMode.color,
              datasets: data,
              colorsets: {
                1: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                2: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                3: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                4: Theme.of(
                  context,
                ).colorScheme.primary, // Use primary theme color
              },
              onClick: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
