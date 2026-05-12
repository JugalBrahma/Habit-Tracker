import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/homepage.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/screens/habit_library_screen.dart';
import 'package:habit_tracker/screens/profile_screen.dart';

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
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/image 1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          // Screens
          IndexedStack(
            index: _selectedindex,
            children: const [
              TodayHabitsScreen(),
              HabitLibraryScreen(),
              ProgressOverviewScreen(),
              ProfileScreenNature(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    Widget navItem(IconData icon, String label, bool active) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedindex = [Icons.today_outlined, Icons.tune, Icons.show_chart, Icons.person].indexOf(icon);
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: active ? const Color(0xFF95D878) : const Color(0xFFC1C9B8)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xFF95D878) : const Color(0xFFC1C9B8),
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 82,
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF201F1F),
        border: const Border(top: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.2))),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: [BoxShadow(color: const Color(0xFF3E7B27).withOpacity(.2), blurRadius: 14)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.today_outlined, 'Today', _selectedindex == 0),
          navItem(Icons.tune, 'Habits', _selectedindex == 1),
          navItem(Icons.show_chart, 'Progress', _selectedindex == 2),
          navItem(Icons.person, 'Profile', _selectedindex == 3),
        ],
      ),
    );
  }
}

