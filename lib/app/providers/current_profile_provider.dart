// Current User Profile Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_controller.dart';
import '../models/auth_state.dart';
import '../models/user_profile.dart';

final currentUserProfileProvider = Provider<UserProfile?>((ref) {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    return authState.profile;
  }
  return null;
});
