import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/homepage.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

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
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D1B1E), // Very dark teal
                    Color(0xFF132A25), // Forest dark
                    Color(0xFF0F201C), // Deepest green
                  ],
                ),
              ),
            ),
          ),
          // Screens
          IndexedStack(
            index: _selectedindex,
            children: const [
              Homepage(), 
              StatisticsScreen(), 
            ],
          ),
          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, Icons.grid_view_rounded),
                      _buildNavItem(1, Icons.bar_chart_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedindex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedindex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.premiumGreenIndicator : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white.withOpacity(0.4),
          size: 28,
        ),
      ),
    );
  }
}
