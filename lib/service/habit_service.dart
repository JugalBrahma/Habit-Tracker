import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/bloc/habit_state.dart';
import 'package:habit_tracker/service/model/user_model.dart';

class HabitService extends Bloc<HabitEvents, HabitStates> {
  HabitService() : super(HabitLoading()) {
    on<LoadHabit>((event, emit) {
      // after loading, set initial list
      emit(HabitLoaded(habits: const []));
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
    final updated = (state as HabitLoaded).habits.map((habit) {
    if (habit.id == event.habitId) { 
      return habit.copyWith(isActive: !habit.isActive);
    }
    return habit;
   }).toList();
   emit(HabitLoaded(habits: updated));
});
  }
}
