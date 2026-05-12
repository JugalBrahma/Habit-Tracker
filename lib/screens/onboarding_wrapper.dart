import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/forest_onboarding_flow.dart';
import 'package:habit_tracker/navigationpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
    
    if (hasCompletedOnboarding) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Navigationpage()),
        );
      }
    }
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Navigationpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ForestOnboardingFlow(
      onComplete: _completeOnboarding,
    );
  }
}
