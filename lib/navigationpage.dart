import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/homepage.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/screens/gallery_screen.dart';

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
              Homepage(), 
              StatisticsScreen(),
              GalleryScreen(),
            ],
          ),
          // Bottom Navigation Bar (exact from Figma)
          Positioned(
            left: 11,
            right: 11,
            bottom: 30,
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0x1F1F5A25),
                borderRadius: BorderRadius.circular(39),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(39),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, '🏠', 'Home'),
                      _buildNavItem(1, '📊', 'Stats'),
                      _buildNavItem(2, '🖼️', 'Gallery'),
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

  Widget _buildNavItem(int index, String emoji, String label) {
    final isSelected = _selectedindex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedindex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF7FD88B) : const Color(0xFFA8D5A0),
                fontSize: 9,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

