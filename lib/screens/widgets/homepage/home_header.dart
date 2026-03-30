import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:habit_tracker/screens/config/theme/theme_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeHeader({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              FirebaseAnalytics.instance.logEvent(
                name: 'theme_toggle',
                parameters: {
                  'from_theme': isDark ? 'dark' : 'light',
                  'to_theme': isDark ? 'light' : 'dark',
                },
              );
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
