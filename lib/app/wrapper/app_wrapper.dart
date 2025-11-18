import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/reports_driver/session_provider.dart';
import '../../services/auth_controller.dart';
import '../models/auth_state.dart';
import '../models/user_profile.dart';
import '../providers/all_app_provider.dart';
import '../providers/current_profile_provider.dart';
import '../routes/app_router.dart';
import '../services/firebase_realtime_db.dart';

final isAlertOpenProvider = StateProvider<bool>((ref) => false);

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key, required this.child});

  final Widget child;

  @override
  AppWrapperState createState() => AppWrapperState();
}

class AppWrapperState extends ConsumerState<AppWrapper> {
  bool _listenerSet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // We ensure this listener is added only once
    if (_listenerSet) return;
    _listenerSet = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalContainer.listen<AuthState>(authControllerProvider, (
        previous,
        next,
      ) {
        final router = GoRouter.of(context);
        final currentLocation = router.state.uri.toString();
        String? targetRoute;

        switch (next) {
          case AuthInitial():
          case AuthLoading():
            targetRoute = '/';
            break;

          case AuthAuthenticated():
            final profile = next.profile;
            if (profile.role == UserRole.admin) {
              targetRoute = '/admin';
            } else if (profile.role == UserRole.driver) {
              targetRoute = '/home';
            }
            break;

          case AuthUnauthenticated():
            targetRoute = '/login';
            break;

          case AuthError():
            targetRoute = '/error';
            break;
        }

        if (targetRoute != null && currentLocation != targetRoute) {
          router.go(targetRoute);
        }
      });
    });
  }

  FirebaseDatabaseHelper dbHelper = FirebaseDatabaseHelper.instance;

  onChange(isDetected) {
    final reporter = ref.read(reportingSessionProvider.notifier);

    if (isDetected) {
      openAlert(context, ref);
      reporter.addMistake();
    } else {
      if (ref.read(isAlertOpenProvider)) {
        ref.read(isAlertOpenProvider.notifier).state = false;
        context.pop();
      }
    }
  }

  void openAlert(BuildContext context, WidgetRef ref) {
    final isOpen = ref.read(isAlertOpenProvider);

    if (!isOpen) {
      ref.read(isAlertOpenProvider.notifier).state = true;

      context.push('/alert').then((_) {
        ref.read(isAlertOpenProvider.notifier).state = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dbHelper.setAlertOff();
    dbHelper.listen('live/detected', onChange);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final router = ref.read(appRouterProvider);
        return widget.child;
      },
    );
  }
}
