import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/navigationpage.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_repositery.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final AnimationController _floatController;
  final HabitRepository _repo = HabitRepository();

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Build Better Habits',
      subtitle:
          'Transform your daily routines into lasting habits with personalized tracking and insights.',
      quote: '"The secret of your future is hidden in your daily routine."',
      icon: Icons.auto_graph,
      iconColor: AppColors.primarySeed,
      gradientColors: [AppColors.drawerGradient1Start, AppColors.drawerGradient1End],
    ),
    _OnboardingPageData(
      title: 'Track Your Streaks',
      subtitle:
          'Visualize your progress with beautiful heatmaps and keep your motivation burning strong.',
      quote: '"Success is the sum of small efforts, repeated day in and day out."',
      icon: Icons.local_fire_department,
      iconColor: AppColors.fireOrange,
      gradientColors: [AppColors.fireOrange, AppColors.fireAmber],
    ),
    _OnboardingPageData(
      title: 'Stay Consistent',
      subtitle:
          'Smart reminders and milestone celebrations to help you stay on track every single day.',
      quote: '"Small steps every day lead to big results."',
      icon: Icons.notifications_active,
      iconColor: AppColors.waterCyan,
      gradientColors: [AppColors.waterBlue, AppColors.waterCyan],
    ),
    _OnboardingPageData(
      title: 'Stay Motivated',
      subtitle:
          'Your potential is endless. Go do what you were created to do.',
      quote: '"Don\'t stop until you\'re proud."',
      icon: Icons.rocket_launch,
      iconColor: AppColors.primarySeedDark,
      gradientColors: [AppColors.drawerGradient1Start, AppColors.primarySeedDark],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final box = Hive.box('themePreferences');
    await box.put('hasSeenOnboarding', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HabitService(_repo)..add(LoadHabit()),
            child: const Navigationpage(),
          ),
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated background blobs
            _BackgroundBlobs(floatController: _floatController, isDark: isDark),

            // Overlay for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ]
                      : [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.3),
                        ],
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? Colors.white70 : Colors.black54,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView with glass cards
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _PageContent(
                          data: _pages[index],
                          floatController: _floatController,
                          isDark: isDark,
                        );
                      },
                    ),
                  ),

                  // Bottom section: dots + button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              width: _currentPage == index ? 32 : 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _currentPage == index
                                    ? (isDark ? Colors.white : AppColors.primarySeed)
                                    : (isDark
                                        ? Colors.white.withOpacity(0.3)
                                        : AppColors.primarySeed.withOpacity(0.3)),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),

                        // Glass get started / next button
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: GestureDetector(
                              onTap: _nextPage,
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [
                                            Colors.white.withOpacity(0.25),
                                            Colors.white.withOpacity(0.1),
                                          ]
                                        : [
                                            AppColors.primarySeed.withOpacity(0.9),
                                            AppColors.primarySeed.withOpacity(0.7),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.3)
                                        : AppColors.primarySeed.withOpacity(0.5),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withOpacity(0.15)
                                          : AppColors.primarySeed.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currentPage == _pages.length - 1
                                            ? 'Get Started'
                                            : 'Next',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        _currentPage == _pages.length - 1
                                            ? Icons.arrow_forward
                                            : Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 20,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final String quote;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;

  _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
  });
}

class _PageContent extends StatelessWidget {
  final _OnboardingPageData data;
  final AnimationController floatController;
  final bool isDark;

  const _PageContent({
    required this.data,
    required this.floatController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass card with icon
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final value = floatController.value;
              final translateY = value * 12 - 6;
              return Transform.translate(
                offset: Offset(0, translateY),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.05),
                            ]
                          : [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.7),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.3)
                          : data.iconColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.iconColor.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow behind icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              data.iconColor.withOpacity(0.4),
                              data.iconColor.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        data.icon,
                        size: 80,
                        color: isDark ? Colors.white.withOpacity(0.95) : data.iconColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Glass text card
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withOpacity(0.18),
                            Colors.white.withOpacity(0.06),
                          ]
                        : [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.85),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.25)
                        : data.iconColor.withOpacity(0.2),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.75)
                            : Colors.black54,
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Motivational Quote
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: data.iconColor.withOpacity(isDark ? 0.1 : 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: data.iconColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        data.quote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white : data.iconColor,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundBlobs extends StatelessWidget {
  final AnimationController floatController;
  final bool isDark;

  const _BackgroundBlobs({required this.floatController, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  AppColors.darkDrawer,
                  AppColors.darkCard,
                ]
              : [
                  AppColors.lightBackground,
                  Colors.white,
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: Stack(
        children: [
          // Blob 1 - top left theme green
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final v = floatController.value;
              return Positioned(
                top: -80 + v * 40,
                left: -60 + v * 30,
                child: _Blob(
                  size: 300,
                  color: AppColors.primarySeed.withOpacity(isDark ? 0.4 : 0.2),
                  blur: 80,
                ),
              );
            },
          ),
          // Blob 2 - top right soft green/lime
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final v = floatController.value;
              return Positioned(
                top: 40 - v * 30,
                right: -80 + v * 20,
                child: _Blob(
                  size: 260,
                  color: AppColors.habitBreakdownSoft.withOpacity(isDark ? 0.3 : 0.15),
                  blur: 70,
                ),
              );
            },
          ),
          // Blob 3 - center theme green deep
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final v = floatController.value;
              return Positioned(
                top: size.height * 0.35 + v * 30,
                left: size.width * 0.25 - v * 20,
                child: _Blob(
                  size: 220,
                  color: AppColors.drawerGradient1Start.withOpacity(isDark ? 0.25 : 0.1),
                  blur: 90,
                ),
              );
            },
          ),
          // Blob 4 - bottom right soft green
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final v = floatController.value;
              return Positioned(
                bottom: -60 + v * 30,
                right: -40 - v * 20,
                child: _Blob(
                  size: 280,
                  color: AppColors.primarySeedDark.withOpacity(isDark ? 0.35 : 0.15),
                  blur: 80,
                ),
              );
            },
          ),
          // Blob 5 - bottom left subtle green
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final v = floatController.value;
              return Positioned(
                bottom: 100 - v * 20,
                left: -50 + v * 30,
                child: _Blob(
                  size: 200,
                  color: AppColors.primarySeed.withOpacity(isDark ? 0.2 : 0.1),
                  blur: 70,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _Blob({
    required this.size,
    required this.color,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: blur * 0.3,
          ),
        ],
      ),
    );
  }
}
