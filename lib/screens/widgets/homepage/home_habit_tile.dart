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
  void didUpdateWidget(HomeHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habit != widget.habit || oldWidget.date != widget.date) {
      _currentPercentage = widget.habit.getCompletionPercentage(widget.date);
      _dragPosition = _currentPercentage / 100.0;
    }
  }

  void _toggleSimpleHabit(bool isFuture) {
    if (isFuture) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("\u{1F512} Can't edit future habits"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final newPercent = _currentPercentage == 100 ? 0 : 100;
    setState(() {
      _currentPercentage = newPercent;
      _dragPosition = newPercent / 100.0;
    });
    context.read<HabitService>().add(
      UpdateHabitPercentage(
        widget.habit.id,
        {'${widget.date.year}-${widget.date.month}-${widget.date.day}': newPercent},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = HomeHabitTile._kHabitIcons[widget.habit.iconName] ?? Icons.circle;
    final badgeColor = Color(widget.habit.color);
    final theme = Theme.of(context);
    final isTimed = widget.habit.targetMinutes != null;

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Delete Habit?'),
            content: Text('This will permanently delete "${widget.habit.name}".'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (direction) => context.read<HabitService>().add(DeleteHabit(widget.habit.id)),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isFuture ? theme.colorScheme.onSurface.withOpacity(0.15) : theme.colorScheme.primary.withOpacity(0.6),
              width: 2.5,
            ),
          ),
          foregroundDecoration: isFuture ? BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.35), borderRadius: BorderRadius.circular(24)) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<HabitService>(), child: UpdateHabitPage(habit: widget.habit))));
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), shape: BoxShape.circle),
                            child: Icon(icon, color: badgeColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.habit.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, decoration: widget.isDone ? TextDecoration.lineThrough : null)),
                                Text('${widget.streak} Day Streak', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                                if (isTimed) ...[
                                  const SizedBox(height: 2),
                                  Text('Goal: ${widget.habit.targetMinutes}m', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56, height: 56,
                    child: InkWell(
                      onTap: isTimed ? null : () => _toggleSimpleHabit(isFuture),
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFuture 
                                  ? Colors.grey.shade100 
                                  : Colors.white,
                            ),
                          ),
                          CircularProgressIndicator(
                            value: isFuture ? 0 : _dragPosition,
                            strokeWidth: 6,
                            backgroundColor: isFuture ? Colors.grey.shade200 : badgeColor.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(isFuture ? Colors.grey.shade300 : badgeColor),
                          ),
                          if (isFuture) const Icon(Icons.lock_outline_rounded, size: 20, color: Colors.grey)
                          else if (isTimed) Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${(widget.habit.targetMinutes! * _currentPercentage / 100).round()}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: badgeColor)),
                              Text('min', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          )
                          else if (_currentPercentage == 100) const Icon(Icons.check_rounded, color: Color(0xFF556B2F), size: 24)
                          else const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isTimed) ...[
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const barHeight = 4.0;
                    final trackWidth = constraints.maxWidth;
                    final handlePosition = _dragPosition * trackWidth;

                    return GestureDetector(
                      onHorizontalDragStart: (_) {
                        if (isFuture) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("\u{1F512} Can't edit future habits"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        if (isFuture) return;
                        setState(() {
                          _dragPosition = (_dragPosition + details.delta.dx / trackWidth).clamp(0.0, 1.0);
                          _currentPercentage = (_dragPosition * 100).round();
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        if (isFuture) return;
                        context.read<HabitService>().add(UpdateHabitPercentage(widget.habit.id, {'${widget.date.year}-${widget.date.month}-${widget.date.day}': _currentPercentage}));
                      },
                      child: SizedBox(
                        height: 24,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: barHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(barHeight / 2)),
                            ),
                            Container(
                              width: handlePosition.clamp(0.0, trackWidth),
                              height: barHeight,
                              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(barHeight / 2)),
                            ),
                            Positioned(
                              left: (handlePosition - 8).clamp(-4.0, trackWidth - 12),
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: CustomPaint(
                                  size: const Size(20, 20),
                                  painter: _SwipeIndicatorPainter(color: badgeColor, progress: _dragPosition),
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
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final centerY = size.height / 2;
    path.moveTo(4.0, centerY - 6);
    path.lineTo(4.0 + 16, centerY);
    path.lineTo(4.0, centerY + 6);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SwipeIndicatorPainter oldDelegate) => oldDelegate.color != color || oldDelegate.progress != progress;
}
