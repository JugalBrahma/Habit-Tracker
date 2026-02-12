import 'package:flutter/material.dart';
import 'package:habit_tracker/homepage.dart';
import 'package:habit_tracker/statistics_screen.dart';

class Navigationpage extends StatefulWidget {
  const Navigationpage({super.key});

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  int _selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedindex,
        elevation: 8,
        onDestinationSelected: (value) {
          setState(() {
            _selectedindex = value;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),
      body: IndexedStack(
        index: _selectedindex,
        children: [Homepage(), StatisticsScreen()],
      ),
    );
  }
}
