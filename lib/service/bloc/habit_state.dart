import 'package:habit_tracker/service/model/user_model.dart';

abstract class HabitStates {}

class HabitLoading extends HabitStates {}

class HabitLoaded extends HabitStates {
  final List<Habit> habits;
  HabitLoaded({required this.habits});
}
