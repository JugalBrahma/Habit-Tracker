import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/homepage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/screens/gallery_screen.dart';
import 'package:habit_tracker/service/background_service.dart';
import 'package:habit_tracker/screens/widgets/glass_container.dart';

class Navigationpage extends StatefulWidget {
  const Navigationpage({super.key});

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  int _selectedindex = 0;
  final BackgroundService _backgroundService = BackgroundService();
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return ValueListenableBuilder<String>(
      valueListenable: _backgroundService,
      builder: (context, backgroundPath, _) {
        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  backgroundPath,
                  fit: BoxFit.cover,
                ),
              ),
              // Screens
              IndexedStack(
                index: _selectedindex,
                children: [
                  const Homepage(), 
                  const StatisticsScreen(), 
                  GalleryScreen(backgroundService: _backgroundService),
                ],
              ),
              // Glass Bottom Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 40.0 : 20.0, 
                    0, 
                    isTablet ? 40.0 : 20.0, 
                    isTablet ? 40.0 : 30.0
                  ),
                  child: SafeArea(
                    child: GlassContainer(
                      blur: 20,
                      opacity: 0.1,
                      borderRadius: 30,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, Icons.home_rounded, "Home"),
                          _buildNavItem(1, Icons.bar_chart_rounded, "Stats"),
                          _buildNavItem(2, Icons.photo_library_rounded, "Gallery"),
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
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedindex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          FirebaseAnalytics.instance.logEvent(name: 'stats_tab_click');
        } else if (index == 2) {
          FirebaseAnalytics.instance.logEvent(name: 'gallery_tab_click');
        }
        setState(() {
          _selectedindex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 28,
            ),
            if (isSelected)
              const SizedBox(height: 4),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
