import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/repositery/habit_repositery.dart';
import 'package:habit_tracker/service/notification_service.dart';
import 'package:intl/intl.dart';

class HabitService extends Bloc<HabitEvents, HabitStates> {
  final HabitRepository _repository;
  HabitService(this._repository) : super(HabitLoading()) {
    on<LoadHabit>((event, emit) {
      final habits = _repository.loadHabits();
      NotificationService.updateHabitNotification(habits);
      emit(HabitLoaded(habits: habits));
    });

    on<AddHabit>((event, emit) async {
      if (state is! HabitLoaded) return;
      final current = state as HabitLoaded;

      try {
        final newHabit = Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.title,
          color: event.color,
          iconName: event.iconName,
          createdAt: DateTime.now(),
          repeatDays: event.repeatDays,
          description: event.description,
          reminderTime: event.reminderTime,
          targetDays: event.targetDays,
          targetMinutes: event.targetMinutes,
        );

        await _repository.saveHabit(newHabit);
        final updatedHabits = [...current.habits, newHabit];
        NotificationService.updateHabitNotification(updatedHabits);
        emit(HabitLoaded(habits: updatedHabits));
      } catch (e) {
        print('Error adding habit: $e');
      }
    });

    on<ToggleHabit>((event, emit) async {
      if (state is! HabitLoaded) return;
      final currentState = state as HabitLoaded;
      final day = DateTime(event.date.year, event.date.month, event.date.day);

      final updatedHabits = currentState.habits.map((habit) {
        if (habit.id != event.habitId) return habit;

        // Create a new set from the existing completed dates
        final Set<DateTime> dates = Set<DateTime>.from(habit.completedDateSet);
        final isComplete = dates.contains(day);

        // Only toggle the specific clicked date
        if (isComplete) {
          dates.remove(day);
        } else {
          dates.add(day);
        }

        // Update completion percentages for the affected date
        final updatedPercentages =
            Map<String, int>.from(habit.completionPercentage);
        
        final key = '${day.year}-${day.month}-${day.day}';
        if (isComplete) {
          updatedPercentages.remove(key);
        } else {
          updatedPercentages[key] = 100;
        }

        final updatedHabit = habit.copyWith(
          completedDates: dates,
          completionPercentage: updatedPercentages,
        );
        _repository.saveHabit(updatedHabit);
        return updatedHabit;
      }).toList();

      NotificationService.updateHabitNotification(updatedHabits);
      emit(HabitLoaded(habits: updatedHabits));
    });

    on<DeleteHabit>((event, emit) async {
      if (state is! HabitLoaded) return;
      final current = state as HabitLoaded;

      await _repository.deleteHabit(event.habitId);

      final updatedHabits =
          current.habits.where((habit) => habit.id != event.habitId).toList();

      NotificationService.updateHabitNotification(updatedHabits);
      emit(HabitLoaded(habits: updatedHabits));
    });

    on<UpdateHabit>((event, emit) async {
      if (state is! HabitLoaded) return;
      final current = state as HabitLoaded;

      final updatedHabits = current.habits.map((habit) {
        if (habit.id != event.id) return habit;

        final updatedHabit = habit.copyWith(
          name: event.title,
          description: event.description,
          color: event.color,
          iconName: event.iconName,
          repeatDays: event.repeatDays,
          reminderTime: event.reminderTime,
          targetDays: event.targetDays,
          targetMinutes: event.targetMinutes,
        );

        _repository.saveHabit(updatedHabit);
        return updatedHabit;
      }).toList();

      NotificationService.updateHabitNotification(updatedHabits);
      emit(HabitLoaded(habits: updatedHabits));
    });

    on<UpdateHabitPercentage>((event, emit) async {
      if (state is! HabitLoaded) return;
      final current = state as HabitLoaded;

      print(
          'DEBUG: UpdateHabitPercentage called with completionPercentage: ${event.completionPercentage}');

      final updatedHabits = current.habits.map((habit) {
        if (habit.id != event.habitId) return habit;

        print('DEBUG: Processing habit ${habit.name}');
        print('DEBUG: Existing completedDates: ${habit.completedDateSet}');
        print(
            'DEBUG: Existing completionPercentage: ${habit.completionPercentage}');

        // Merge the new update with existing completion percentages
        final updatedPercentages =
            Map<String, int>.from(habit.completionPercentage);
        updatedPercentages.addAll(event.completionPercentage);

        // Create a new set from existing completed dates
        final Set<DateTime> dates = Set<DateTime>.from(habit.completedDateSet);

        // Process only the entries being updated
        for (final entry in event.completionPercentage.entries) {
          final parts = entry.key.split('-');
          final date = DateTime(
              int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          print('DEBUG: Processing date $date with percentage ${entry.value}');
          if (entry.value == 100) {
            dates.add(date);
            print('DEBUG: Added date to completedDates');
          } else {
            dates.remove(date);
            print('DEBUG: Removed date from completedDates');
          }
        }

        print('DEBUG: Final completedDates: $dates');
        print('DEBUG: Final completionPercentage: $updatedPercentages');

        final updatedHabit = habit.copyWith(
          completionPercentage: updatedPercentages,
          completedDates: dates,
        );

        _repository.saveHabit(updatedHabit);
        return updatedHabit;
      }).toList();

      emit(HabitLoaded(habits: updatedHabits));
    });
  }

  /// Normalize a DateTime to midnight (00:00:00) for consistent date comparisons
  static DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
