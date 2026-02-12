import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 19.0,
                          horizontal: 17,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall Score',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(flex: 2),
                            Text(
                              '16%',
                              style: TextStyle(
                                fontSize: 65,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Completion Rate',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 19.0,
                          horizontal: 17,
                        ),
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _chart(context, backgroundcolor),
                SizedBox(height: 20),
                _breakdown(context, backgroundcolor),
                SizedBox(height: 20),
                _streak(context, backgroundcolor),
                SizedBox(height: 20),
                _activitymap(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _chart(context, backgroundcolor) {
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
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 30),
                      FlSpot(2, 20),
                      FlSpot(3, 40),
                      FlSpot(4, 30),
                      FlSpot(5, 50),
                      FlSpot(6, 100),
                    ],

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

Widget _breakdown(context, backgroundcolor) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(70, 14, 70, 255),
                    ),
                    child: Icon(Icons.book),
                  ),
                  SizedBox(width: 10),
                  Text('test', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text('5%', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            minHeight: 6,
            borderRadius: BorderRadius.circular(19),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.2),
            value: 0.1,
          ),
        ],
      ),
    ),
  );
}

Widget _streak(context, backgroundcolor) {
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
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
                            padding: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: const Color.fromARGB(70, 216, 118, 38),
                            ),
                            child: Icon(Icons.bolt, color: Colors.deepOrange),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'test',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Best: 1 days',

                                style: TextStyle(
                                  color: const Color.fromARGB(73, 0, 0, 0),
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
                            '1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'Current',

                            style: TextStyle(
                              color: const Color.fromARGB(73, 0, 0, 0),
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

Widget _activitymap(context) {
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
            datasets: {
              DateTime(2026, 2, 6): 1,
              DateTime(2026, 2, 7): 2,
              DateTime(2026, 2, 8): 3,
              DateTime(2026, 2, 9): 4,
              DateTime(2026, 2, 13): 1,
            },
            colorsets: {
              1: const Color(0xFFFF9800).withOpacity(0.3),
              2: const Color(0xFFFF9800).withOpacity(0.5),
              3: const Color(0xFFFF9800).withOpacity(0.6),
              4: const Color(0xFFFF9800).withOpacity(0.9),
            },
            onClick: (value) {},
          ),
        ],
      ),
    ),
  );
}
