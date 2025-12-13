import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:drivesense/features/reports_driver/trip_session_model.dart';

final reportingSessionProvider =
    StateNotifierProvider<ReportingSessionNotifier, ReportingSessionState>(
      (ref) => ReportingSessionNotifier(),
    );

class ReportingSessionState {
  final bool isActive;
  final DateTime? startTime;
  final DateTime? endTime;
  final int mistakesCount;

  const ReportingSessionState({
    this.isActive = false,
    this.startTime,
    this.endTime,
    this.mistakesCount = 0,
  });

  ReportingSessionState copyWith({
    bool? isActive,
    DateTime? startTime,
    DateTime? endTime,
    int? mistakesCount,
  }) {
    return ReportingSessionState(
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      mistakesCount: mistakesCount ?? this.mistakesCount,
    );
  }
}

class ReportingSessionNotifier extends StateNotifier<ReportingSessionState> {
  ReportingSessionNotifier() : super(const ReportingSessionState());

  void startSession() {
    state = state.copyWith(
      isActive: true,
      startTime: DateTime.now(),
      mistakesCount: 0,
      endTime: null,
    );
  }

  void addMistake() {
    if (!state.isActive) return;
    state = state.copyWith(mistakesCount: state.mistakesCount + 1);
  }

  Future<void> endSession(DatabaseReference db) async {
    if (!state.isActive) return;

    final endTime = DateTime.now();

    // Save to Firebase
    final session = TripSessionModel(
      date: DateTime.now(),
      startTime: state.startTime ?? DateTime.now(),
      endTime: endTime,
      mistakesCount: state.mistakesCount,
    );
    await TripSessionModel.add(db, session);

    // Reset state
    state = state.copyWith(isActive: false, endTime: endTime, mistakesCount: 0);
  }
}
