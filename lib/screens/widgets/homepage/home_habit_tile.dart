import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/screens/update_habit.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';

class HomeHabitTile extends StatelessWidget {
  final Habit habit;
  final bool isDone;
  final int streak;
  final DateTime date;

  static const Map<String, IconData> _kHabitIcons = {
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

  const HomeHabitTile({
    super.key,
    required this.habit,
    required this.isDone,
    required this.streak,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _kHabitIcons[habit.iconName] ?? Icons.circle;
    final badgeColor = Color(habit.color);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text('Delete Habit?'),
            content: Text(
              'This will permanently delete "${habit.name}" and all of its progress history. This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<HabitService>().add(DeleteHabit(habit.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${habit.name}" deleted'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
      ),
      child: Material(
        color: Colors.transparent,
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
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<HabitService>(),
                          child: UpdateHabitPage(habit: habit),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
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
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: theme.colorScheme.onSurface,
                                decorationThickness: 2.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$streak Day Streak',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<HabitService>().add(ToggleHabit(habit.id, date));
                },
                child: AnimatedContainer(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
