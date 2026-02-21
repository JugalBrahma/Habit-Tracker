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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedindex,
            children: [Homepage(), StatisticsScreen()],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: NavigationBar(
                      backgroundColor: Colors.transparent,
                      indicatorColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      selectedIndex: _selectedindex,
                      elevation: 0,
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      height: size.height * 0.08,
                      onDestinationSelected: (value) {
                        setState(() {
                          _selectedindex = value;
                        });
                      },
                      destinations: [
                        NavigationDestination(
                          icon: Icon(Icons.home_rounded),
                          label: "Home",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.bar_chart_rounded),
                          label: "Stats",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
