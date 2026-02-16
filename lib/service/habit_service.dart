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

    on<AddHabit>((event, emit) {
      if (state is! HabitLoaded) return; // prevent crash

      final currentState = state as HabitLoaded;

      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.title,
       isActive: false, color: event.color, iconName: event.iconName,
        createdAt: DateTime.now(), repeatDays: event.repeatDays,
      );

      final updated = [...currentState.habits, newHabit];

      emit(HabitLoaded(habits: updated));
    });

    on<ToggleHabit>((event, emit) {
   if (state is! HabitLoaded) return;
   final day = DateTime(event.date.year, event.date.month, event.date.day);
   
    final updated = (state as HabitLoaded).habits.map((habit) {
    if (habit.id == event.habitId) { 
      final dates = {...habit.completedDates};
      dates.contains(day) ? dates.remove(day) : dates.add(day);
      return habit.copyWith(completedDates: dates);
    }
    return habit;

   }).toList();

   emit(HabitLoaded(habits: updated));
});
  }
}
