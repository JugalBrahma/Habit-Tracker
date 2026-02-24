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

  // Smart error handler - shows user-friendly messages
  FlutterError.onError = (FlutterErrorDetails details) {
    final errorString = details.exception.toString();
    final stackTrace = details.stack.toString();

    // Ignore non-critical widget lifecycle errors
    if (errorString.contains('_dependents.isEmpty') ||
        errorString.contains('deactivated widget') ||
        errorString.contains('dirty widget') ||
        errorString.contains('was used after being disposed') ||
        errorString.contains('TextEditingController') ||
        errorString.contains('Tried to build dirty widget')) {
      debugPrint('⚠️ Non-critical widget error (ignored): $errorString');
      return;
    }

    // Check if it's a network error
    if (errorString.toLowerCase().contains('network') ||
        errorString.toLowerCase().contains('socket') ||
        errorString.toLowerCase().contains('connection') ||
        errorString.toLowerCase().contains('timeout') ||
        errorString.toLowerCase().contains('failed to connect')) {
      runApp(
        ErrorPage(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
          error: errorString,
        ),
      );
      return;
    }

    // Critical error - show error page
    debugPrint('🔴 Critical Error: $errorString');
    debugPrint('Stack: $stackTrace');
    runApp(
      ErrorPage(
        title: 'Something Went Wrong',
        message: 'An unexpected error occurred. Please restart the app.',
        error: errorString,
      ),
    );
  };

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox('Habits');
    await Hive.openBox('themePreferences');
  } catch (e) {
    debugPrint('Hive initialization error: $e');
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

class ErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final String error;

  const ErrorPage({
    super.key,
    required this.title,
    required this.message,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = title.contains('Internet');

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isNetworkError ? Icons.wifi_off : Icons.error_outline,
                  size: 64,
                  color: isNetworkError ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart App'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
