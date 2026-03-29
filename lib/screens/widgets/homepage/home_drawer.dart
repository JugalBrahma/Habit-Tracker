import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final avatarSize = isTablet ? 80.0 : size.width * 0.18;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkDrawer : Colors.grey[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(context, avatarSize, isDark),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildPremiumTile(
                    context,
                    icon: Icons.feedback_rounded,
                    title: 'Send Feedback',
                    gradient: const [AppColors.drawerGradient1Start, AppColors.drawerGradient1End],
                    onTap: () {
                      Navigator.pop(context);
                      _showFeedbackDialog(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumTile(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'App Guide',
                    gradient: const [AppColors.drawerGradient2Start, AppColors.drawerGradient2End],
                    onTap: () {
                      Navigator.pop(context);
                      _showGuideDialog(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumTile(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About App',
                    gradient: const [AppColors.drawerGradient3Start, AppColors.drawerGradient3End],
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            // Version Pill
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.source_rounded,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Version 1.0.2',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BUILD 4',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
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

  Widget _buildPremiumHeader(BuildContext context, double avatarSize, bool isDark) {
    final primary = Theme.of(context).colorScheme.primary;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [primary.withOpacity(0.3), primary.withOpacity(0.1)] 
            : [primary, Theme.of(context).colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? primary.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Give logo breathing room
                child: Image.asset(
                  'assets/app_logo/app_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habit Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Build your best self',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withOpacity(0.02) 
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.05) 
                : Colors.black.withOpacity(0.04),
          ),
          boxShadow: isDark ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showGuideDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Text(
                'How it Works',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _guideItem(
                context,
                'Tracking Habits',
                'Toggle habits by tapping the check box. Habits only appear on days they are scheduled for.',
                Icons.check_circle_outline,
              ),
              _guideItem(
                context,
                'Overall Score',
                'Your score shows your completion rate. If you finish 4 out of 5 habits today, your score is 80%.',
                Icons.pie_chart_outline,
              ),
              _guideItem(
                context,
                'Streaks',
                'Streaks count consecutive days of completion. Miss a day, and the streak resets to zero!',
                Icons.local_fire_department_outlined,
              ),
              _guideItem(
                context,
                'History Trends',
                'The charts visualize your discipline over 7, 30, or 90 days. High peaks mean high consistency.',
                Icons.trending_up,
              ),
              _guideItem(
                context,
                'Activity Heatmap',
                'The grid shows your long-term activity. Darker colors mean you completed more habits on that day!',
                Icons.grid_on_rounded,
              ),
              _guideItem(
                context,
                'Management',
                'Swipe a habit to the left on the homepage to permanently delete the routine and all its history.',
                Icons.delete_sweep_outlined,
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideItem(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        final feedbackController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        final FirebaseFirestore firebasestore = FirebaseFirestore.instance;

        Future<void> sendfeedback() async {
          try {
            await firebasestore.collection('feedback').add({
              'email': emailController.text,
              'feedback': feedbackController.text,
              'timestamp': FieldValue.serverTimestamp(),
            });

            if (!context.mounted) return;

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feedback sent! Thank you for your support.'),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Close dialog immediately
            if (!context.mounted) return;
            Navigator.pop(context);
          } catch (e, s) {
            // Ignore non-critical Google Play Services errors
            if (e.toString().contains('SecurityException') ||
                e.toString().contains('GoogleApiManager')) {
              debugPrint(
                'Non-critical GMS error (data may still be saved): $e',
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feedback sent! Thank you for your support.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );

              if (!context.mounted) return;
              Navigator.pop(context);
              return;
            }

            // Handle critical errors
            debugPrint('sendFeedback error: $e');
            debugPrint(s.toString());

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to send feedback: ${e.toString()}'),
              ),
            );
          }
        }

        return WillPopScope(
          onWillPop: () async {
            emailController.dispose();
            feedbackController.dispose();
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                  SizedBox(width: 16),
                  Text(
                    'Your Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Help us grow! Share your ideas, report bugs, or just say hello. Your input directly shapes the future of this app.',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Contact Email',
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required for follow-up';
                        }
                        if (!value.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        hintText: 'What\'s on your mind?',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Maybe Later'),
              ),
              TextButton(
                onPressed: () {
                  formKey.currentState!.reset();
                  emailController.clear();
                  feedbackController.clear();
                },
                child: const Text('Restart'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    sendfeedback();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Send Feedback'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('About the App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Habit Tracker',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('The path to discipline'),
            const SizedBox(height: 20),
            Text(
              'This application is designed to help you build lasting habits through consistency and visualization. Track your daily routines, monitor your streaks, and analyze your progress with precision.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Built for your focus',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
