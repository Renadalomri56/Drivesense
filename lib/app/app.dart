import 'package:drivesense/app/routes/app_router.dart';
import 'package:drivesense/app/theme/app_theme.dart';
import 'package:drivesense/app/theme/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'helpers/scafold_message.dart';

class App extends ConsumerWidget {
  App({super.key});

  final DateTime expiryDate = DateTime(2026, 12, 29);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    final themeMode = ref.watch(themeModeProvider);
    final GoRouter router = ref.watch(appRouterProvider);

    if (now.isAfter(expiryDate)) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 100),
                Text(
                  "Sorry",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "This app is no longer available.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Drive Sense',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

