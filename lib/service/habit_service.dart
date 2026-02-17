import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/habit_repositery.dart';

class HabitService extends Bloc<HabitEvents, HabitStates> {
  final HabitRepository _repository;
  HabitService(this._repository) : super(HabitLoading()) {
    on<LoadHabit>((event, emit) {
      // after loading, set initial list
      emit(HabitLoaded(habits: _repository.loadHabits()));
    });

    on<AddHabit>((event, emit) async {
  if (state is! HabitLoaded) return;
  final current = state as HabitLoaded;

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

  emit(HabitLoaded(habits: [...current.habits, newHabit]));
});

  on<ToggleHabit>((event, emit) async {
  if (state is! HabitLoaded) return;
  final current = state as HabitLoaded;
  final day = DateTime(event.date.year, event.date.month, event.date.day);

  final updatedHabits = current.habits.map((habit) {
    if (habit.id != event.habitId) return habit;
    final dates = habit.completedDateSet;
    dates.contains(day) ? dates.remove(day) : dates.add(day);
    final updatedHabit = habit.copyWith(completedDates: dates);
    _repository.saveHabit(updatedHabit);
    return updatedHabit;
  }).toList();

  emit(HabitLoaded(habits: updatedHabits));
});
  }
}
