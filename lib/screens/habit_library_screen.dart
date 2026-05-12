import 'package:flutter/material.dart';

class HabitLibraryScreen extends StatelessWidget {
  const HabitLibraryScreen({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color card = Color(0xFF1C1B1B);
  static const Color border = Color.fromRGBO(65, 73, 60, 0.30);
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
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PageHeader(),
                        SizedBox(height: 30),
                        HabitSection(
                          title: "Health",
                          icon: Icons.favorite_outline,
                          habits: [
                            HabitData("Morning Hydration", "Daily", "14 Days", .80, true),
                            HabitData("Evening Walk", "4x / Week", "3 Days", .30, false),
                          ],
                        ),
                        SizedBox(height: 24),
                        HabitSection(
                          title: "Mind",
                          icon: Icons.psychology_outlined,
                          habits: [
                            HabitData("10 Min Meditation", "Daily", "42 Days", .95, true),
                            HabitData("Reading", "3x / Week", "0 Days", 0.0, false),
                          ],
                        ),
                        SizedBox(height: 24),
                        HabitSection(
                          title: "Productivity",
                          icon: Icons.bolt_outlined,
                          habits: [
                            HabitData("Deep Work Session", "Weekdays", "5 Days", .40, false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 24,
              bottom: 84,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentDark,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: accentDark.withOpacity(.4), blurRadius: 12)],
                ),
                child: const Icon(Icons.add, color: accent, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: HabitLibraryScreen.bg.withOpacity(.9),
        border: const Border(bottom: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.park_outlined, color: HabitLibraryScreen.accent, size: 18),
              SizedBox(width: 8),
              Text("Habit Tracker",
                  style: TextStyle(
                      color: HabitLibraryScreen.accent,
                      fontSize: 32,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
            ),
            child: const Icon(Icons.person_outline, size: 16, color: HabitLibraryScreen.muted),
          )
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Habit Library",
            style: TextStyle(
                color: HabitLibraryScreen.title, fontSize: 44, fontWeight: FontWeight.w700)),
        SizedBox(height: 4),
        Text("Manage your active routines and routines.",
            style: TextStyle(color: HabitLibraryScreen.muted, fontSize: 14)),
      ],
    );
  }
}

class HabitData {
  final String name;
  final String frequency;
  final String streak;
  final double progress;
  final bool highlight;
  const HabitData(this.name, this.frequency, this.streak, this.progress, this.highlight);
}

class HabitSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<HabitData> habits;

  const HabitSection({super.key, required this.title, required this.icon, required this.habits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: HabitLibraryScreen.accent),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  color: HabitLibraryScreen.title, fontSize: 34, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        const Divider(color: Color.fromRGBO(65, 73, 60, 0.2), height: 1),
        const SizedBox(height: 16),
        ...habits.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HabitCard(data: h),
            )),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitData data;
  const _HabitCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HabitLibraryScreen.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HabitLibraryScreen.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data.name,
                    style: const TextStyle(
                        color: HabitLibraryScreen.title, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.event_note_outlined, size: 14, color: HabitLibraryScreen.muted),
                  const SizedBox(width: 4),
                  Text(data.frequency,
                      style: const TextStyle(color: HabitLibraryScreen.muted, fontSize: 14)),
                ]),
              ]),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
              ),
              child: const Icon(Icons.spa_outlined, size: 16, color: HabitLibraryScreen.accent),
            ),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Current Streak",
                style: TextStyle(
                    color: HabitLibraryScreen.muted, fontSize: 12, fontWeight: FontWeight.w600)),
            Text(data.streak,
                style: TextStyle(
                    color: data.highlight ? HabitLibraryScreen.accent : HabitLibraryScreen.muted,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: data.progress,
              backgroundColor: const Color(0xFF353534),
              valueColor: const AlwaysStoppedAnimation(HabitLibraryScreen.accent),
            ),
          ),
        ],
      ),
    );
  }
}
