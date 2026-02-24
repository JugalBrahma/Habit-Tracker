import 'package:flutter/material.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/navigationpage.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/habit_repositery.dart';
import 'package:habit_tracker/service/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:habit_tracker/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for offline functionality
  }

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox('Habits');
    await Hive.openBox('themePreferences');
    print('Hive initialized successfully');
  } catch (e) {
    print('Hive initialization error: $e');
    // Exit if local storage fails
    return;
  }

  final repo = HabitRepository();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: MyApp(repo: repo),
    ),
  );
}

class MyApp extends StatefulWidget {
  final HabitRepository repo;
  const MyApp({super.key, required this.repo});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: BlocProvider(
            create: (context) => HabitService(widget.repo)..add(LoadHabit()),
            child: Navigationpage(),
          ),
        );
      },
    );
  }
}
