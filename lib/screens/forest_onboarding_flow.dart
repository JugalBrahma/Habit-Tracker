import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ForestOnboardingFlow extends StatefulWidget {
  final VoidCallback? onComplete;
  const ForestOnboardingFlow({super.key, this.onComplete});

  @override
  State<ForestOnboardingFlow> createState() => _ForestOnboardingFlowState();
}

class _ForestOnboardingFlowState extends State<ForestOnboardingFlow> {
  final _controller = PageController();
  int _index = 0;

  static const _bg = Color(0xFF131313);
  static const _muted = Color(0xFFC1C9B8);
  static const _text = Color(0xFFE5E2E1);
  static const _accent = Color(0xFF95D878);
  static const _accentDark = Color(0xFF3E7B27);

  void _next() {
    if (_index < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    }
  }

  void _goToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (_index > 0) {
                _controller.previousPage(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                );
              }
            },
            child: const Icon(Icons.arrow_back, color: _accent, size: 20),
          ),
          GestureDetector(
            onTap: () {
              if (widget.onComplete != null) {
                widget.onComplete!();
              }
            },
            child: const Text("Skip", style: TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _dots() {
    return SmoothPageIndicator(
      controller: _controller,
      count: 3,
      effect: JumpingDotEffect(
        spacing: 12,
        radius: 4,
        dotWidth: 8,
        dotHeight: 8,
        paintStyle: PaintingStyle.fill,
        strokeWidth: 1,
        dotColor: const Color(0xFF353534),
        activeDotColor: _accent,
        jumpScale: 1.0,
        verticalOffset: 0,
      ),
      onDotClicked: _goToPage,
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: const Color(0xFF0D3900),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
    );
  }

  
  Widget _screen2() {
    return Column(
      children: [
        _header(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0x08FFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x2695D878)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("CONSISTENCY SCORE",
                    style: TextStyle(color: Color(0xB395D878), fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Text("94.2%", style: TextStyle(color: _accent, fontSize: 52, fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
                  Chip(
                    label: Text("+12%", style: TextStyle(color: _accent, fontSize: 16)),
                    backgroundColor: Color(0x333E7B27),
                    side: BorderSide.none,
                  )
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.asset("assets/onboarding_images/Abstract Growth Chart.png", fit: BoxFit.cover),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _StatTile("Current Streak", "18 Days")),
                    SizedBox(width: 8),
                    Expanded(child: _StatTile("Focus Time", "42.5h")),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text("Deep Growth Insights", style: TextStyle(color: _text, fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            "Analyze your performance with surgical precision. Stay motivated with streaks and consistency scores.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
          ),
        ),
        const Spacer(),
        _dots(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _primaryButton("Continue Journey", _next),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _screen3() {
    return Column(
      children: [
        _header(),
        const SizedBox(height: 60),
        Container(
          width: 256,
          height: 256,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x3395D878), width: 2),
            boxShadow: [BoxShadow(color: _accent.withOpacity(.25), blurRadius: 42)],
          ),
          child: ClipOval(
            child: Image.network(
              "https://www.figma.com/api/mcp/asset/10dcf8d1-28e8-473b-b48a-9e5de955282e",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 48),
        const Text("Plant Your Habits", style: TextStyle(color: _text, fontSize: 44, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Text(
            "Start small, grow tall. Track your daily routines and watch your personal forest flourish.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 16, height: 1.6),
          ),
        ),
        const Spacer(),
        _dots(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _primaryButton("Next ›", _next),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _screen4() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            "https://www.figma.com/api/mcp/asset/684ea8e3-abaa-4ece-9c73-a65b35d6f3fc",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(.55),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.1,
                colors: [Color(0x263E7B27), Color(0xF5131313)],
              ),
            ),
          ),
        ),
        Column(
          children: [
            _header(),
            const SizedBox(height: 84),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _accentDark,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _accent.withOpacity(.25), blurRadius: 24)],
              ),
              child: const Icon(Icons.eco, color: _accent, size: 36),
            ),
            const SizedBox(height: 24),
            const Text("Ready to Grow?", style: TextStyle(color: _text, fontSize: 48, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Join 100,000+ users building better lives in the shadows.",
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _FeatureTile(icon: Icons.bolt, title: "Momentum", subtitle: "Deep progress, minimal noise."),
                  SizedBox(height: 16),
                  _FeatureTile(icon: Icons.query_stats, title: "Precision", subtitle: "Quantified journey visualized."),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _primaryButton("Get Started", () {
                if (widget.onComplete != null) {
                  widget.onComplete!();
                }
              }),
            ),
            const SizedBox(height: 14),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // TODO: Navigate to signup
                      print('Navigate to signup');
                    },
                    child: const Text("Sign up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // TODO: Navigate to login
                      print('Navigate to login');
                    },
                    child: const Text("Log in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _dots(),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          children: [_screen2(), _screen3(), _screen4()],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        border: Border.all(color: const Color(0x1AFFFFFF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Color(0xFFC1C9B8), fontSize: 16)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Color(0xFFE5E2E1), fontSize: 30)),
      ]),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0x08FFFFFF),
        border: Border.all(color: const Color(0x14FFFFFF)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: const Color(0x1A95D878), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF95D878), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Color(0xFFE5E2E1), fontSize: 16, fontWeight: FontWeight.w600)),
            Text(subtitle, style: const TextStyle(color: Color(0xFFC1C9B8), fontSize: 14)),
          ]),
        )
      ]),
    );
  }
}
