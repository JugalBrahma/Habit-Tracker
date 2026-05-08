import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';

class HomeHabitTile extends StatefulWidget {
  final Habit habit;
  final bool isDone;
  final int streak;
  final DateTime date;

  static const Map<String, IconData> _kHabitIcons = {
    'Fitness': Icons.fitness_center,
    'Run': Icons.directions_run,
    'Meditate': Icons.self_improvement,
    'Read': Icons.menu_book,
    'Water': Icons.water_drop,
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

  void _toggleSimpleHabit() {
    final newPercent = _currentPercentage == 100 ? 0 : 100;
    setState(() {
      _currentPercentage = newPercent;
      _dragPosition = newPercent / 100.0;
    });
    context.read<HabitService>().add(
          UpdateHabitPercentage(
            widget.habit.id,
            {
              '${widget.date.year}-${widget.date.month}-${widget.date.day}':
                  newPercent
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(widget.habit.color);
    final isTimed = widget.habit.targetMinutes != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 98, // Fixed height from your spec
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // 18px radius from your spec
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12), // Exact background from your spec
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(_currentPercentage == 100 ? 0.25 : 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildIconRing(badgeColor),
                    const SizedBox(width: 18),
                    _buildHabitDetails(isTimed),
                    _buildCheckAction(isTimed),
                  ],
                ),
                if (isTimed) _buildTimeSlider(badgeColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconRing(Color badgeColor) {
    final icon = HomeHabitTile._kHabitIcons[widget.habit.iconName] ?? Icons.circle;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: _currentPercentage / 100,
            strokeWidth: 3.5,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(
              _currentPercentage == 100 ? AppColors.premiumGreenIndicator : badgeColor
            ),
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  Widget _buildHabitDetails(bool isTimed) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.habit.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildPremiumPill(
                "🔥 ${widget.streak}", 
                Colors.orange.withOpacity(0.15),
                textColor: Colors.orangeAccent
              ),
              const SizedBox(width: 6),
              _buildPremiumPill(
                isTimed ? "${widget.habit.targetMinutes}m goal" : "Daily",
                Colors.white.withOpacity(0.08),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckAction(bool isTimed) {
    return GestureDetector(
      onTap: isTimed ? null : _toggleSimpleHabit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _currentPercentage == 100 
              ? AppColors.premiumGreenIndicator 
              : Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: _currentPercentage == 100 
                ? Colors.white.withOpacity(0.5) 
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.check_rounded, 
          color: _currentPercentage == 100 ? Colors.black : Colors.white.withOpacity(0.2),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTimeSlider(Color badgeColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.only(top: 4), // Reduced from 24 to fit 98px height
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _dragPosition = (_dragPosition + details.delta.dx / trackWidth).clamp(0.0, 1.0);
                _currentPercentage = (_dragPosition * 100).round();
              });
            },
            onHorizontalDragEnd: (_) {
              context.read<HabitService>().add(UpdateHabitPercentage(
                widget.habit.id, 
                {'${widget.date.year}-${widget.date.month}-${widget.date.day}': _currentPercentage}
              ));
            },
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                // Track
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                ),
                // Fill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 10,
                  width: trackWidth * _dragPosition,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [badgeColor.withOpacity(0.8), badgeColor.withOpacity(0.4)],
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 6)],
                  ),
                ),
                // Handle
                Positioned(
                  left: (trackWidth * _dragPosition) - 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(Icons.play_arrow, color: badgeColor, size: 14),
                  ),
                ),
                // Time Text
                Positioned(
                  right: 0,
                  top: -22,
                  child: Text(
                    "${(_dragPosition * widget.habit.targetMinutes!).round()}m",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumPill(String text, Color bgColor, {Color? textColor, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: textColor ?? Colors.white60),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
