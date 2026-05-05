import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/screens/update_habit.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/screens/widgets/common/premium_snackbar.dart';

class HomeHabitTile extends StatefulWidget {
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
    'Swim': Icons.pool,
    'Drive': Icons.directions_car,
    'Bike': Icons.directions_bike,
    'Protein': Icons.blender,
    'Rest': Icons.airline_seat_individual_suite,
  };

  const HomeHabitTile({
    super.key,
    required this.habit,
    required this.isDone,
    required this.streak,
    required this.date,
  });

  @override
  State<HomeHabitTile> createState() => _HomeHabitTileState();
}

class _HomeHabitTileState extends State<HomeHabitTile> {
  double _dragPosition = 0.0;
  int _currentPercentage = 0;

  @override
  void initState() {
    super.initState();
    _currentPercentage = widget.habit.getCompletionPercentage(widget.date);
    _dragPosition = _currentPercentage / 100.0;
  }

  @override
  Widget build(BuildContext context) {
    final icon = HomeHabitTile._kHabitIcons[widget.habit.iconName] ?? Icons.circle;
    final badgeColor = Color(widget.habit.color);
    final theme = Theme.of(context);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFuture = widget.date.isAfter(today);

    return Dismissible(
      key: Key(widget.habit.id),
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
              'This will permanently delete "${widget.habit.name}" and all of its progress history. This cannot be undone.',
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
        context.read<HabitService>().add(DeleteHabit(widget.habit.id));
        PremiumSnackBar.show(
          context,
          title: 'Habit Deleted',
          message: '"${widget.habit.name}" has been removed.',
          icon: Icons.delete_sweep_rounded,
          backgroundColor: theme.colorScheme.error,
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.6),
              width: 2.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<HabitService>(),
                              child: UpdateHabitPage(habit: widget.habit),
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
                                  widget.habit.name,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: widget.isDone
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
                                      '${widget.streak} Day Streak',
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
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        CircularProgressIndicator(
                          value: _dragPosition,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _currentPercentage == 100
                                ? const Color(0xFF556B2F)
                                : badgeColor,
                          ),
                        ),
                        Text(
                          '$_currentPercentage%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _currentPercentage == 100
                                ? const Color(0xFF556B2F)
                                : badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  const barHeight = 4.0;
                  final trackWidth = constraints.maxWidth;
                  final handlePosition = _dragPosition * trackWidth;

                  return GestureDetector(
                    onHorizontalDragStart: (_) {
                      if (isFuture) return;
                    },
                    onHorizontalDragUpdate: (details) {
                      if (isFuture) return;
                      setState(() {
                        _dragPosition += details.delta.dx / trackWidth;
                        _dragPosition = _dragPosition.clamp(0.0, 1.0);
                        _currentPercentage = (_dragPosition * 100).round();
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (isFuture) return;
                      final dateKey = '${widget.date.year}-${widget.date.month}-${widget.date.day}';
                      final updatedPercentages = Map<String, int>.from(widget.habit.completionPercentage);
                      updatedPercentages[dateKey] = _currentPercentage;
                      
                      context.read<HabitService>().add(
                        UpdateHabitPercentage(
                          widget.habit.id,
                          updatedPercentages,
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 24,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          // Track background
                          Container(
                            height: barHeight,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(barHeight / 2),
                            ),
                          ),
                          
                          // Progress fill
                          Container(
                            width: handlePosition.clamp(0.0, trackWidth),
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: _currentPercentage == 100
                                  ? const Color(0xFF556B2F)
                                  : badgeColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(barHeight / 2),
                            ),
                          ),
                          
                          // Blue triangle handle
                          Positioned(
                            left: (handlePosition - 8).clamp(-4.0, trackWidth - 12),
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: CustomPaint(
                                size: const Size(20, 20),
                                painter: _SwipeIndicatorPainter(
                                  color: _currentPercentage == 100
                                      ? const Color(0xFF556B2F)
                                      : badgeColor,
                                  progress: _dragPosition,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeIndicatorPainter extends CustomPainter {
  final Color color;
  final double progress;

  _SwipeIndicatorPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final arrowWidth = 16.0;
    final arrowHeight = 12.0;
    
    // Draw a chevron/arrow shape pointing right
    final centerY = size.height / 2;
    final startX = 4.0;
    
    path.moveTo(startX, centerY - arrowHeight / 2);
    path.lineTo(startX + arrowWidth, centerY);
    path.lineTo(startX, centerY + arrowHeight / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SwipeIndicatorPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.progress != progress;
  }
}
