import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';

class ActivityMap extends StatelessWidget {
  final Habit habit;
  final Color selectedColor;

  const ActivityMap({
    super.key,
    required this.habit,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Calculate last 35 days (5 weeks)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final List<DateTime> days = List.generate(35, (index) {
      return today.subtract(Duration(days: 34 - index));
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Activity History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Last 35 Days",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isToday = date.isAtSameMomentAs(today);
              final isCompleted = habit.completedDateSet.any((d) => 
                  d.year == date.year && d.month == date.month && d.day == date.day);
              
              return _buildDayCell(context, date, isToday, isCompleted);
            },
          ),
          const SizedBox(height: 16),
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date, bool isToday, bool isCompleted) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.read<HabitService>().add(ToggleHabit(habit.id, date));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted 
              ? selectedColor 
              : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(8),
          border: isToday 
              ? Border.all(color: selectedColor, width: 2) 
              : null,
          boxShadow: isCompleted ? [
            BoxShadow(
              color: selectedColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isToday || isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted 
                  ? Colors.white 
                  : (isToday ? selectedColor : theme.colorScheme.onSurface.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("Completed", selectedColor),
        const SizedBox(width: 16),
        _legendItem("Missed", theme.brightness == Brightness.dark 
            ? Colors.white.withOpacity(0.1) 
            : Colors.grey[200]!),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
