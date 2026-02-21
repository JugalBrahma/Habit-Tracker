import 'package:hive/hive.dart';
import 'model/user_model.dart';

class HabitRepository {
  static const _boxName = 'Habits';
  final Box? _box;

  HabitRepository([this._box]);

  Box get box => _box ?? Hive.box(_boxName);

  List<Habit> loadHabits() => box.values.cast<Habit>().toList();

  Future<void> saveHabit(Habit habit) => box.put(habit.id, habit);

  Future<void> deleteHabit(String id) => box.delete(id);
}
