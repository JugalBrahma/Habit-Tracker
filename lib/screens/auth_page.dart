import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.park_outlined, color: Color(0xFF95D878), size: 48),
              const SizedBox(height: 32),
              const Text(
                "Welcome to the Forest",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Continue your journey by creating an account or logging in.",
                style: TextStyle(
                  color: Color(0xFFC1C9B8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 64),
              
              // Placeholder for Auth UI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2A3326)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.lock_person_outlined, color: Color(0xFF95D878), size: 48),
                    SizedBox(height: 16),
                    Text(
                      "Auth Flow coming soon",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Firebase Auth will be integrated here.",
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Onboarding",
                    style: TextStyle(color: Color(0xFF95D878), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
