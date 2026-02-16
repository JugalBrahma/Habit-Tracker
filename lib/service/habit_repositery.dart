import 'package:hive/hive.dart';
import 'model/user_model.dart';

class HabitRepository {
  static const _boxName = 'Habits';
  final Box _box = Hive.box(_boxName);

  List<Habit> loadHabits() => _box.values.cast<Habit>().toList();

  Future<void> saveHabit(Habit habit) => _box.put(habit.id, habit);

  Future<void> deleteHabit(String id) => _box.delete(id);
}