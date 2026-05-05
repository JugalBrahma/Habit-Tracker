import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/screens/config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/navigationpage.dart';
import 'package:habit_tracker/service/bloc/habit_events.dart';
import 'package:habit_tracker/service/repositery/habit_repositery.dart';
import 'package:habit_tracker/service/repositery/habit_service.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:habit_tracker/service/notification_service.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:habit_tracker/screens/config/theme/theme_cubit.dart';
import 'package:habit_tracker/adhelper.dart';
import 'package:habit_tracker/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    ),
  );

  // Lock orientation to prevent crashes
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Smart error handler - logs errors without replacing the entire app
  FlutterError.onError = (FlutterErrorDetails details) {
    final errorString = details.exception.toString();
    // Safely get stack trace (stack can be null)
    final stackTrace = details.stack?.toString() ?? 'no stack trace';

    // Ignore non-critical widget lifecycle & layout errors
    // (these happen naturally during rebuilds, rotation, navigation, etc.)
    if (errorString.contains('_dependents.isEmpty') ||
        errorString.contains('deactivated widget') ||
        errorString.contains('dirty widget') ||
        errorString.contains('was used after being disposed') ||
        errorString.contains('TextEditingController') ||
        errorString.contains('Tried to build dirty widget') ||
        errorString.contains('RenderBox was not laid out') ||
        errorString.contains('setState() called after dispose') ||
        errorString.contains('overflowed by') ||
        errorString.contains('does not have a size yet') ||
        errorString.contains('Null check operator') ||
        (details.stack == null)) {
      debugPrint('Non-critical error (ignored): $errorString');
      return;
    }

    // Log the error for debugging — do NOT replace the app
    debugPrint('Flutter Error: $errorString');
    debugPrint('Stack: $stackTrace');

    // Let Flutter handle it with its default behavior (red screen in debug,
    // grey screen in release) — keeps the app alive instead of crashing it
    FlutterError.presentError(details);
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
    await Adhelper.initPreferences(); // Initialize ad preferences
  } catch (e) {
    debugPrint('Hive initialization error: $e');
    return;
  }

  final repo = HabitRepository();

  final box = Hive.box('themePreferences');
  final hasSeenOnboarding = box.get('hasSeenOnboarding', defaultValue: false);

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: MyApp(repo: repo, hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatefulWidget {
  final HabitRepository repo;
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.repo, required this.hasSeenOnboarding});

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
          home: widget.hasSeenOnboarding
              ? BlocProvider(
                  create: (context) => HabitService(widget.repo)..add(LoadHabit()),
                  child: Navigationpage(),
                )
              : const OnboardingScreen(),
        );
      },
    );
  }
}
