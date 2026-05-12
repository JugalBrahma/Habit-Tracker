import 'package:flutter/material.dart';

class TodayHabitsScreen extends StatelessWidget {
  const TodayHabitsScreen({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color card = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A3326);
  static const Color muted = Color(0xFFC1C9B8);
  static const Color title = Color(0xFFE5E2E1);
  static const Color accent = Color(0xFF95D878);
  static const Color accentDark = Color(0xFF3E7B27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 108),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _GreetingSection(),
                    SizedBox(height: 16),
                    _DailyProgressCard(),
                    SizedBox(height: 12),
                    _CurrentStreakCard(),
                    SizedBox(height: 24),
                    Text(
                      "Today's Focus",
                      style: TextStyle(
                        color: title,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    _HabitTile(
                      name: "Morning Meditation",
                      subtitle: "15 minutes",
                      done: true,
                      strike: true,
                      highlighted: true,
                    ),
                    SizedBox(height: 12),
                    _HabitTile(
                      name: "Deep Work",
                      subtitle: "2 hours",
                      done: true,
                      strike: true,
                      highlighted: true,
                    ),
                    SizedBox(height: 12),
                    _HabitTile(
                      name: "Evening Run",
                      subtitle: "5 km",
                      done: false,
                      highlighted: true,
                    ),
                    SizedBox(height: 12),
                    _HabitTile(
                      name: "Read Fiction",
                      subtitle: "30 pages",
                      done: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(19, 19, 19, .8),
        border: Border(bottom: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                "park",
                style: TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Habit Tracker",
                style: TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF353534),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
            ),
            child: const Icon(Icons.person, color: TodayHabitsScreen.muted, size: 20),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Good morning, Alex.",
          style: TextStyle(
            color: TodayHabitsScreen.title,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Wednesday, October 25",
          style: TextStyle(
            color: TodayHabitsScreen.muted,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: TodayHabitsScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TodayHabitsScreen.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Progress",
                style: TextStyle(
                  color: TodayHabitsScreen.title,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "66%",
                style: TextStyle(
                  color: TodayHabitsScreen.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: .66,
              backgroundColor: const Color(0xFF1E331A),
              valueColor: const AlwaysStoppedAnimation(TodayHabitsScreen.accent),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "2 of 3 habits completed today.",
            style: TextStyle(color: TodayHabitsScreen.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CurrentStreakCard extends StatelessWidget {
  const _CurrentStreakCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 17),
      decoration: BoxDecoration(
        color: TodayHabitsScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TodayHabitsScreen.cardBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_fire_department_outlined, color: TodayHabitsScreen.accent, size: 30),
          SizedBox(height: 8),
          Text(
            "12 Days",
            style: TextStyle(
              color: TodayHabitsScreen.title,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "CURRENT STREAK",
            style: TextStyle(
              color: TodayHabitsScreen.muted,
              fontSize: 12,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool done;
  final bool strike;
  final bool highlighted;

  const _HabitTile({
    required this.name,
    required this.subtitle,
    required this.done,
    this.strike = false,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      decoration: BoxDecoration(
        color: TodayHabitsScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? TodayHabitsScreen.accent : TodayHabitsScreen.cardBorder,
          width: highlighted ? 1 : 1,
        ),
      ),
      child: Row(
        children: [
          done
              ? Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: TodayHabitsScreen.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: TodayHabitsScreen.accentDark.withOpacity(.35),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(Icons.check, size: 18, color: Color(0xFF1E331A)),
                )
              : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF41493C), width: 2),
                  ),
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: TodayHabitsScreen.title,
                    fontSize: 16,
                    decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: TodayHabitsScreen.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .6,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 18, color: TodayHabitsScreen.muted),
        ],
      ),
    );
  }
}