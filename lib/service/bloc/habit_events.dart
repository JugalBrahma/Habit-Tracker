abstract class HabitEvents {}

class LoadHabit extends HabitEvents {}

class AddHabit extends HabitEvents {
  final String title;
  AddHabit({required this.title});
}
