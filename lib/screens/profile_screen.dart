import 'package:flutter/material.dart';

class ProfileScreenNature extends StatelessWidget {
  const ProfileScreenNature({super.key});

  static const Color bg = Color(0xFF131313);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color border = Color(0xFF2A3326);
  static const Color muted = Color(0xFFC1C9B8);
  static const Color text = Color(0xFFE5E2E1);
  static const Color accent = Color(0xFF95D878);
  static const Color accentDark = Color(0xFF3E7B27);

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
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ProfileHeaderCard(),
                    SizedBox(height: 16),
                    _ForestStatusCard(),
                    SizedBox(height: 32),
                    Text("Badges",
                        style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.w600)),
                    SizedBox(height: 16),
                    _BadgeGrid(),
                    SizedBox(height: 32),
                    Text("Settings",
                        style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.w600)),
                    SizedBox(height: 16),
                    _SettingsCard(),
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
        color: Color.fromRGBO(19, 19, 19, 0.8),
        border: Border(bottom: BorderSide(color: Color.fromRGBO(65, 73, 60, 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.park_outlined, color: ProfileScreenNature.accent, size: 18),
              SizedBox(width: 8),
              Text("Habit Tracker",
                  style: TextStyle(
                      color: ProfileScreenNature.accent,
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
            child: const Icon(Icons.person_outline, size: 16, color: ProfileScreenNature.muted),
          )
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: ProfileScreenNature.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProfileScreenNature.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [ProfileScreenNature.accentDark, Color(0xFF2A2A2A)]),
                  border: Border.all(color: const Color(0xFF131313), width: 4),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2A2A2A),
                    border: Border.all(color: const Color.fromRGBO(65, 73, 60, 0.3)),
                  ),
                  child: const Icon(Icons.person_outline, size: 18, color: ProfileScreenNature.muted),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ProfileScreenNature.accent,
                    border: Border.all(color: const Color(0xFF131313), width: 2),
                    boxShadow: [
                      BoxShadow(color: ProfileScreenNature.accentDark.withOpacity(.35), blurRadius: 10),
                    ],
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Color(0xFF1E331A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Alex Rivers",
              style: TextStyle(color: ProfileScreenNature.text, fontSize: 32, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('"Growth in the shadows, light in the\nprogress."',
              textAlign: TextAlign.center,
              style: TextStyle(color: ProfileScreenNature.muted, fontSize: 16, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pill("1,240 Trees Planted", true),
              const SizedBox(width: 8),
              _pill("42 Day Streak", false),
            ],
          )
        ],
      ),
    );
  }

  Widget _pill(String text, bool primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF201F1F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primary ? const Color.fromRGBO(62, 123, 39, 0.3) : const Color.fromRGBO(57, 79, 51, 0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primary ? ProfileScreenNature.accent : const Color(0xFFB4CEAA),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: .6,
        ),
      ),
    );
  }
}

class _ForestStatusCard extends StatelessWidget {
  const _ForestStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: ProfileScreenNature.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProfileScreenNature.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Forest Status",
              style: TextStyle(color: ProfileScreenNature.text, fontSize: 24, fontWeight: FontWeight.w600)),
          SizedBox(height: 16),
          _ProgressRow("Current Canopy", "Level 8", .75, true),
          SizedBox(height: 16),
          _ProgressRow("Next Milestone", "260 to go", .40, false),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String left;
  final String right;
  final double value;
  final bool bright;
  const _ProgressRow(this.left, this.right, this.value, this.bright);

  @override
  Widget build(BuildContext context) {
    final barColor = bright ? ProfileScreenNature.accent : const Color(0xFFB4CEAA);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(left,
              style: const TextStyle(
                  color: ProfileScreenNature.muted, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: .6)),
          Text(right,
              style: TextStyle(
                  color: barColor, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: .6)),
        ]),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFF2A2A2A),
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        )
      ],
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        _BadgeItem("Early Bird", Icons.star, true),
        _BadgeItem("Hydration Pro", Icons.water_drop, true),
        _BadgeItem("Focus Master", Icons.lock_outline, false),
        _BadgeItem("Iron Will", Icons.lock_outline, false),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  const _BadgeItem(this.label, this.icon, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: ProfileScreenNature.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProfileScreenNature.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? const Color.fromRGBO(62, 123, 39, 0.2) : const Color(0xFF2A2A2A),
            ),
            child: Icon(icon, color: active ? ProfileScreenNature.accent : ProfileScreenNature.muted),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                color: active ? ProfileScreenNature.text : ProfileScreenNature.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: .6,
              ))
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String title, String subtitle, {Widget? trailing, Color? titleColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF201F1F),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ProfileScreenNature.muted, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: titleColor ?? ProfileScreenNature.text, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: ProfileScreenNature.muted, fontSize: 14)),
              ]),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: ProfileScreenNature.muted, size: 16),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ProfileScreenNature.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProfileScreenNature.border),
      ),
      child: Column(
        children: [
          row(Icons.notifications_none, "Notifications", "Reminders and updates"),
          const Divider(height: 1, color: Color.fromRGBO(65, 73, 60, .2)),
          row(
            Icons.palette_outlined,
            "Appearance",
            "Theme and display",
            trailing: Container(
              width: 44,
              height: 24,
              padding: const EdgeInsets.fromLTRB(24, 4, 4, 4),
              decoration: BoxDecoration(
                color: ProfileScreenNature.accentDark,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [BoxShadow(color: ProfileScreenNature.accentDark.withOpacity(.35), blurRadius: 10)],
              ),
              child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFCBFFB1))),
            ),
          ),
          const Divider(height: 1, color: Color.fromRGBO(65, 73, 60, .2)),
          row(Icons.person_outline, "Account", "Security and data"),
          const Divider(height: 1, color: Color.fromRGBO(65, 73, 60, .2)),
          row(Icons.logout, "Log Out", "", trailing: const SizedBox.shrink(), titleColor: const Color(0xFFFFB4AB)),
        ],
      ),
    );
  }
}
