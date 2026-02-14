import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int date = 7;

  DateTime _normalize(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

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

          final stats = _deriveStats(state.habits);

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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _StatisticsSnapshot _deriveStats(List<Habit> habits) {
    final formatter = DateFormat.E();
    final today = _normalize(DateTime.now());
    final start = today.subtract(Duration(days: date - 1));
    final days = List.generate(
      date,
      (index) => _normalize(start.add(Duration(days: index))),
    );

    int scheduled = 0;
    int completed = 0;
    final List<FlSpot> spots = [];
    final Map<DateTime, int> heatmap = {};
    final List<_HabitBreakdown> breakdown = [];
    _HabitStreak? bestStreak;

    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final weekday = formatter.format(day);
      final todaysHabits =
          habits.where((habit) => habit.repeatDays.contains(weekday)).toList();
      scheduled += todaysHabits.length;
      var doneToday = 0;
      for (final habit in todaysHabits) {
        if (habit.completedDates.contains(day)) {
          doneToday += 1;
        }
      }
      completed += doneToday;
      final percent = todaysHabits.isEmpty
          ? 0.0
          : (doneToday / todaysHabits.length * 100)
              .clamp(0, 100)
              .toDouble();
      spots.add(FlSpot(i.toDouble(), percent));
    }

    for (final habit in habits) {
      final scheduledDays = days
          .where((day) => habit.repeatDays.contains(formatter.format(day)))
          .length;
      final completedDays = habit.completedDates.where((dateTime) {
        final normalized = _normalize(dateTime);
        return !normalized.isBefore(start) && !normalized.isAfter(today);
      }).length;

      breakdown.add(
        _HabitBreakdown(
          name: habit.name,
          percent: scheduledDays == 0
              ? 0
              : (completedDays / scheduledDays * 100)
                  .clamp(0, 100)
                  .toDouble(),
        ),
      );

      for (final date in habit.completedDates) {
        final normalized = _normalize(date);
        if (normalized.isBefore(start) || normalized.isAfter(today)) continue;
        heatmap[normalized] = (heatmap[normalized] ?? 0) + 1;
      }

      final current = _currentStreak(habit, today);
      final best = _bestStreak(habit);
      final existingCurrent = bestStreak?.current ?? -1;
      if (current > existingCurrent) {
        bestStreak = _HabitStreak(habit.name, current, best);
      }
    }

    final completionRate = scheduled == 0
        ? 0
        : ((completed / scheduled) * 100).round();

    return _StatisticsSnapshot(
      completionRate: completionRate,
      completed: completed,
      scheduled: scheduled,
      trendSpots: spots,
      breakdown: breakdown,
      topStreak: bestStreak,
      heatmapData: heatmap,
    );
  }

  Widget _overallCard(BuildContext context, _StatisticsSnapshot snapshot) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 9),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isEmpty
                        ? [FlSpot(0, 0)]
                        : spots,

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
    List<_HabitBreakdown> breakdowns,
  ) {
  return Container(
    height: 180,
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
              Text('Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 30),
          ...breakdowns.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${item.percent.toStringAsFixed(0)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(19),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    value: item.percent / 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _streak(
    BuildContext context,
    Color backgroundcolor,
    _HabitStreak? streak,
  ) {
  return Container(
    height: 180,
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
              Icon(Icons.local_fire_department_rounded),
              SizedBox(width: 10),
              Text('Streaks', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 30),
          if (streak == null)
            const Text('No streak data yet')
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                color: const Color.fromARGB(70, 216, 118, 38),
                              ),
                              child:
                                  const Icon(Icons.bolt, color: Colors.deepOrange),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  streak.name,
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Best: ${streak.best} day${streak.best == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(73, 0, 0, 0),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const Text(
                              'Current',
                              style: TextStyle(
                                color: Color.fromARGB(73, 0, 0, 0),
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
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  Widget _activitymap(BuildContext context, Map<DateTime, int> data) {
  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 10),
              Text('Activity Map'),
            ],
          ),
          HeatMapCalendar(
            textColor: Colors.black54,
            defaultColor: Colors.white,
            flexible: true,
            colorMode: ColorMode.color,
            datasets: data,
            colorsets: {
              1: const Color(0xFFFF9800).withOpacity(0.3),
              2: const Color(0xFFFF9800).withOpacity(0.5),
              3: const Color(0xFFFF9800).withOpacity(0.6),
              4: const Color(0xFFFF9800).withOpacity(0.9),
            },
            onClick: (_) {},
          ),
        ],
      ),
    ),
  );
}

  int _bestStreak(Habit habit) {
    final sorted = habit.completedDates.map(_normalize).toList()
      ..sort((a, b) => a.compareTo(b));
    int best = 0;
    int current = 0;
    DateTime? previous;
    for (final date in sorted) {
      final prev = previous;
      if (prev == null) {
        current = 1;
      } else {
        final diff = date.difference(prev).inDays;
        if (diff == 1) {
          current += 1;
        } else if (diff == 0) {
          continue;
        } else {
          current = 1;
        }
      }
      if (current > best) best = current;
      previous = date;
    }
    return best;
  }

  int _currentStreak(Habit habit, DateTime referenceDate) {
    int streak = 0;
    DateTime cursor = referenceDate;

    while (habit.completedDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

class _StatisticsSnapshot {
  final int completionRate;
  final int completed;
  final int scheduled;
  final List<FlSpot> trendSpots;
  final List<_HabitBreakdown> breakdown;
  final _HabitStreak? topStreak;
  final Map<DateTime, int> heatmapData;

  const _StatisticsSnapshot({
    required this.completionRate,
    required this.completed,
    required this.scheduled,
    required this.trendSpots,
    required this.breakdown,
    required this.topStreak,
    required this.heatmapData,
  });
}

class _HabitBreakdown {
  final String name;
  final double percent;

  const _HabitBreakdown({required this.name, required this.percent});
}

class _HabitStreak {
  final String name;
  final int current;
  final int best;

  const _HabitStreak(this.name, this.current, this.best);
}
