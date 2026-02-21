import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/create_routine.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = TextEditingController();
  final kHabitIcons = {
    'Fitness': Icons.fitness_center,
    'Run': Icons.directions_run,
    'Meditate': Icons.self_improvement,
    'Read': Icons.book,
    'Water': Icons.water,
    'Sleep': Icons.bedtime,
    'Medicine': Icons.medication,
    'Food': Icons.restaurant,
    'Code': Icons.code,
    'Write': Icons.create,
    'Music': Icons.music_note,
    'Save': Icons.savings,
    'Nature': Icons.eco,
    'Art': Icons.brush,
    'Computer': Icons.computer,
  };
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(const Duration(days: 3));

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDateSelector(startDate),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<HabitService, HabitStates>(
                builder: (context, state) {
                  if (state is HabitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HabitLoaded) {
                    final normalizedSelected = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    final weekdayLabel = DateFormat.E().format(
                      normalizedSelected,
                    );
                    final scheduledHabits = state.habits
                        .where(
                          (habit) => habit.repeatDays.contains(weekdayLabel),
                        )
                        .toList();
                    final totalToday = scheduledHabits.length;
                    final doneToday = scheduledHabits
                        .where(
                          (habit) =>
                              habit.completedDates.contains(normalizedSelected),
                        )
                        .length;

                    if (totalToday == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No routines scheduled today",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildProgressCard(doneToday, totalToday),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 100,
                            ),
                            itemCount: scheduledHabits.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final habit = scheduledHabits[index];
                              final isDone = habit.completedDates.contains(
                                normalizedSelected,
                              );
                              final streak = _currentStreak(
                                habit,
                                normalizedSelected,
                              );
                              return _buildHabitTile(
                                habit,
                                isDone,
                                streak,
                                normalizedSelected,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            controller.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HabitService>(),
                  child: const CreateRoutine(),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          IconButton(
            // THEME TOGGLE
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(DateTime startDate) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final isSelected =
              date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 55,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(int done, int total) {
    double progress = total > 0 ? done / total : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
                  ]
                : [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your daily goals",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$done of $total completed",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitTile(Habit habit, bool isDone, int streak, DateTime date) {
    final icon = kHabitIcons[habit.iconName] ?? Icons.circle;
    final badgeColor = Color(habit.color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<HabitService>().add(ToggleHabit(habit.id, date));
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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
                  color: badgeColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: badgeColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '$streak Day Streak',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: isDone ? badgeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isDone
                      ? null
                      : Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _currentStreak(Habit habit, DateTime referenceDate) {
    int streak = 0;
    DateTime cursor = referenceDate;

    while (habit.completedDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 72,
                        height: 72,
                        color: Colors.white.withOpacity(0.2),
                        child: Transform.scale(
                          scale: 1,
                          child: Image.asset(
                            'assets/app_logo/app_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Habit Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Statistics',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.feedback_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Send Feedback',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
              _showFeedbackDialog();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'About',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  // Future<void> _sendEmail(String userEmail, String feedback) async {
  //   final String subject = Uri.encodeComponent('Habit Tracker Feedback');
  //   final String body = Uri.encodeComponent(
  //     'From: $userEmail\n\nFeedback:\n$feedback',
  //   );
  //   final Uri mailUri = Uri.parse(
  //     'mailto:support@habittracker.com?subject=$subject&body=$body',
  //   );

  //   try {
  //     if (await canLaunchUrl(mailUri)) {
  //       await launchUrl(mailUri);
  //     } else {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Could not launch email app')),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error: $e')));
  //     }
  //   }
  // }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        final feedbackController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        final FirebaseFirestore firebasestore = FirebaseFirestore.instance;

        void sendfeedback() {
          try {
            firebasestore.collection('feedback').add({
              'email': emailController.text,
              'feedback': feedbackController.text,
            });
          } catch (e) {
            debugPrint(e.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to send feedback')),
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback sent successfully')),
          );

          emailController.clear();
          feedbackController.clear();

          Navigator.pop(context);
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.feedback_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 16),
                    Text(
                      'Send Feedback',
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
                        'We\'d love to hear your thoughts!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Your Email',
                          hintText: 'Enter your email for replies',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: feedbackController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Feedback Details',
                          hintText:
                              'Share your suggestions or report issues...',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 80),
                            child: Icon(Icons.description_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please share your feedback';
                          }
                          if (value.length < 10) {
                            return 'Feedback is too short';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () {
                    emailController.dispose();
                    feedbackController.dispose();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      sendfeedback();
                      emailController.dispose();
                      feedbackController.dispose();
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Habit Tracker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A simple and beautiful habit tracking app to help you build better habits.',
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 Habit Tracker',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
