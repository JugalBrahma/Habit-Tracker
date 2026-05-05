import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/repositery/habit_repositery.dart';
import 'package:habit_tracker/service/notification_service.dart';

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
      final current = state as HabitLoaded;
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      final dateKey = '${day.year}-${day.month}-${day.day}';

      final updatedHabits = current.habits.map((habit) {
        if (habit.id != event.habitId) return habit;
        final dates = habit.completedDateSet;
        final isComplete = dates.contains(day);
        dates.contains(day) ? dates.remove(day) : dates.add(day);
        
        final updatedPercentages = Map<String, int>.from(habit.completionPercentage);
        updatedPercentages[dateKey] = isComplete ? 0 : 100;
        
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

      final updatedHabits = current.habits.map((habit) {
        if (habit.id != event.habitId) return habit;

        final dates = habit.completedDateSet;
        for (final entry in event.completionPercentage.entries) {
          final parts = entry.key.split('-');
          final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          if (entry.value == 100) {
            dates.add(date);
          } else {
            dates.remove(date);
          }
        }

        final updatedHabit = habit.copyWith(
          completionPercentage: event.completionPercentage,
          completedDates: dates,
        );

        _repository.saveHabit(updatedHabit);
        return updatedHabit;
      }).toList();

      emit(HabitLoaded(habits: updatedHabits));
    });
  }
}
