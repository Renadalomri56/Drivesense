import 'package:drivesense/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/admin_home.dart';
import '../../features/admin/profile_view_screen.dart';
import '../../features/alert/alert_screen.dart';
import '../../features/auth2/login/forget_password.dart';
import '../../features/auth2/login/login_screen.dart';
import '../../features/auth2/login/signin_error_screen.dart';
import '../../features/auth2/signup/sign_up_screen.dart';
import '../../features/home/homeScreen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../wrapper/app_wrapper.dart';

final _rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final GlobalKey<NavigatorState> rootKey = ref.watch(
    _rootNavigatorKeyProvider,
  );

  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppWrapper(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/reset-password',
            builder: (context, state) => const ResetPasswordScreen(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: '/error',
            builder: (context, state) => const SignInErrorScreen(),
          ),
          GoRoute(
            path: '/alert',
            builder: (context, state) => const AlertScreen(),
          ),
          GoRoute(
            path: '/admin',
            builder: (context, state) {
              return AdminHome();
            },
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              return Homescreen();
            },
          ),
          GoRoute(
            path: '/view-profile',
            builder: (context, state) {
              final extras = state.extra as Map<String, dynamic>;
              final profile = extras['profile'];
              final myProfile = extras['myProfile'];
              return ProfileViewScreen(profile: profile, myProfile: myProfile);
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsPage(),
          ),
        ],
      ),

      // other routes...
    ],
  );
});
