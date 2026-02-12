class Habit {
  final String id;
  final String title;
  final bool completed;

  Habit({required this.id, required this.title, this.completed = false});

  Habit copyWith({bool? completed}) {
    return Habit(id: id, title: title, completed: completed ?? this.completed);
  }
}
