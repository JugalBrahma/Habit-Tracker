import 'package:flutter/material.dart';

class ProgressOverviewScreen extends StatelessWidget {
  const ProgressOverviewScreen({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color panel = Color(0xFF1E1E1E);
  static const Color panelBorder = Color(0xFF2A3326);
  static const Color accent = Color(0xFF95D878);
  static const Color accentDark = Color(0xFF3E7B27);
  static const Color textPrimary = Color(0xFFE5E2E1);
  static const Color textMuted = Color(0xFFC1C9B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Progress Overview',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your growth in the shadows.',
                      style: TextStyle(color: textMuted, fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    _ConsistencyCard(),
                    SizedBox(height: 12),
                    _StreakCard(),
                    SizedBox(height: 12),
                    _TrendCard(),
                    SizedBox(height: 12),
                    _VolumeCard(),
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
              Icon(Icons.park_outlined, color: ProgressOverviewScreen.accent, size: 18),
              SizedBox(width: 8),
              Text(
                'Habit Tracker',
                style: TextStyle(
                  color: ProgressOverviewScreen.accent,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
            child: const Icon(Icons.person_outline, color: ProgressOverviewScreen.textMuted, size: 16),
          ),
        ],
      ),
    );
  }
}

class _ShellCard extends StatelessWidget {
  final Widget child;
  final bool leftAccent;
  const _ShellCard({required this.child, this.leftAccent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProgressOverviewScreen.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProgressOverviewScreen.panelBorder),
      ),
      child: Stack(
        children: [
          if (leftAccent)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 2, color: ProgressOverviewScreen.accent),
            ),
          Padding(padding: const EdgeInsets.all(17), child: child),
        ],
      ),
    );
  }
}

class _ConsistencyCard extends StatelessWidget {
  const _ConsistencyCard();

  @override
  Widget build(BuildContext context) {
    return _ShellCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.query_stats, color: ProgressOverviewScreen.accent, size: 18),
            SizedBox(width: 8),
            Text('Consistency Score',
                style: TextStyle(color: ProgressOverviewScreen.textPrimary, fontSize: 24, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 192,
                  height: 192,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    value: .87,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor: const AlwaysStoppedAnimation(ProgressOverviewScreen.accent),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '87',
                            style: TextStyle(
                              color: ProgressOverviewScreen.textPrimary,
                              fontSize: 64,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '%',
                            style: TextStyle(
                              color: ProgressOverviewScreen.accent,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('EXCELLENT',
                        style: TextStyle(
                          color: ProgressOverviewScreen.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return _ShellCard(
      leftAccent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.local_fire_department_outlined, color: ProgressOverviewScreen.accent, size: 16),
            SizedBox(width: 8),
            Text('Current Streak',
                style: TextStyle(color: ProgressOverviewScreen.textPrimary, fontSize: 24, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 4),
          const Text("You're building solid momentum.",
              style: TextStyle(color: ProgressOverviewScreen.textMuted, fontSize: 14)),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(30, 51, 26, .3),
                border: Border.all(color: const Color.fromRGBO(149, 216, 120, .2)),
                boxShadow: [BoxShadow(color: ProgressOverviewScreen.accentDark.withOpacity(.45), blurRadius: 25)],
              ),
              child: const Center(
                child: Text('14',
                    style: TextStyle(color: ProgressOverviewScreen.textPrimary, fontSize: 80, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('DAYS IN A ROW',
                style: TextStyle(
                  color: ProgressOverviewScreen.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                )),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard();

  @override
  Widget build(BuildContext context) {
    final points = [0.15, 0.30, 0.25, 0.48, 0.67, 0.78];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return _ShellCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.trending_up, color: ProgressOverviewScreen.accent, size: 18),
            SizedBox(width: 8),
            Text('Performance Trend',
                style: TextStyle(color: ProgressOverviewScreen.textPrimary, fontSize: 24, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 24),
          Container(
            height: 192,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
            ),
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ...List.generate(
                        4,
                        (i) => Positioned(
                          left: 0,
                          right: 0,
                          top: i * 34.0,
                          child: Container(height: 1, color: const Color.fromRGBO(65, 73, 60, 0.2)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: points
                            .map((p) => Padding(
                                  padding: EdgeInsets.only(bottom: p * 110),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: ProgressOverviewScreen.accent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ProgressOverviewScreen.accentDark.withOpacity(.4),
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(labels.length, (i) {
                    final active = i == labels.length - 1;
                    return Text(
                      labels[i],
                      style: TextStyle(
                        color: active ? ProgressOverviewScreen.accent : ProgressOverviewScreen.textMuted,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeCard extends StatelessWidget {
  const _VolumeCard();

  @override
  Widget build(BuildContext context) {
    final bars = [48.0, 96.0, 80.0, 128.0, 64.0, 112.0, 144.0];
    final labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return _ShellCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.bar_chart, color: ProgressOverviewScreen.accent, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text('7-Day Completion\nVolume',
                  style: TextStyle(
                    color: ProgressOverviewScreen.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  )),
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (i) {
                final isToday = i == bars.length - 1;
                final mid = bars[i] >= 80 && !isToday;
                final color = isToday
                    ? ProgressOverviewScreen.accent
                    : (mid ? ProgressOverviewScreen.accentDark : const Color(0xFF1E331A));
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 32,
                      height: bars[i],
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        boxShadow: [
                          if (mid || isToday)
                            BoxShadow(
                              color: ProgressOverviewScreen.accentDark.withOpacity(isToday ? .5 : .35),
                              blurRadius: isToday ? 20 : 12,
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      style: TextStyle(
                        color: isToday ? ProgressOverviewScreen.accent : ProgressOverviewScreen.textMuted,
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
