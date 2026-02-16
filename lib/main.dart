import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/navigationpage.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/habit_repositery.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   Hive.registerAdapter(HabitAdapter());
  await Hive.openBox('Habits');
  final repo = HabitRepository();

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final HabitRepository repo;
  const MyApp({super.key, required this.repo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => HabitService(repo)..add(LoadHabit()),
        child: Navigationpage(),
      ),
    );
  }
}
