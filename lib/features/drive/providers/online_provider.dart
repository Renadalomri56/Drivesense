import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

final onlineStatusProvider = StateNotifierProvider<OnlineStatusNotifier, bool>(
      (ref) => OnlineStatusNotifier(),
);

class OnlineStatusNotifier extends StateNotifier<bool> {
  final _dbRef = FirebaseDatabase.instance.ref('raspi/status/online');
  Timer? _timer;

  OnlineStatusNotifier() : super(false) {
    // Start periodic check
    _startPeriodicUpdate();
    _listenFromFirebase();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(seconds: 15), (_) async {
      await _dbRef.set(false);
      state = false;
    });
  }

  void _listenFromFirebase() {
    _dbRef.onValue.listen((event) {
      final value = event.snapshot.value as bool?;
      if (value != null && value != state) {
        state = value; // Update state when Raspberry Pi sets it to true
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}