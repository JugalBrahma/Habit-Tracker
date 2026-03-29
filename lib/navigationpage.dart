import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/homepage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';

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
    final isLandscape = size.width > size.height;
    final isTablet = size.width > 600;
    // Fixed heights to avoid layout constraint violations in landscape mode
    final navBarHeight = isTablet ? 80.0 : (isLandscape ? 60.0 : 68.0);
    
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
              padding: EdgeInsets.fromLTRB(
                isTablet ? 40.0 : 20.0, 
                0, 
                isTablet ? 40.0 : 20.0, 
                isTablet ? 40.0 : 20.0
              ),
              child: SafeArea(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: navBarHeight,
                    minHeight: 60.0,
                  ),
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
                      height: navBarHeight,
                      onDestinationSelected: (value) {
                        if (value == 1) {
                          FirebaseAnalytics.instance.logEvent(name: 'stats_tab_click');
                        }
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
