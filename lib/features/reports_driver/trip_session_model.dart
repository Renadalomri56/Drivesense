import 'package:firebase_database/firebase_database.dart';

class TripSessionModel {
  final String? id;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int mistakesCount;

  TripSessionModel({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.mistakesCount,
  });

  TripSessionModel copyWith({
    String? id,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    int? mistakesCount,
  }) {
    return TripSessionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      mistakesCount: mistakesCount ?? this.mistakesCount,
    );
  }

  Duration get duration => endTime.difference(startTime);

  factory TripSessionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TripSessionModel(
      id: id,
      date: DateTime.parse(json['date']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      mistakesCount: json['mistakesCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'mistakesCount': mistakesCount,
    };
  }

  /// Fetch all sessions from a database reference
  static Future<List<TripSessionModel>> fetchAll(DatabaseReference ref) async {
    final snapshot = await ref.get();
    if (!snapshot.exists) return [];

    final data = snapshot.value as Map<dynamic, dynamic>;
    final sessions = data.entries.map((entry) {
      return TripSessionModel.fromJson(
        Map<String, dynamic>.from(entry.value),
        id: entry.key,
      );
    }).toList();

    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    return sessions;
  }

  /// Add a new session to the database
  static Future<void> add(
    DatabaseReference ref,
    TripSessionModel session,
  ) async {
    final newRef = ref.push();
    await newRef.set(session.toJson());
  }

  /// Delete a session from the database
  static Future<void> delete(DatabaseReference ref, TripSessionModel session) async {
    await ref.child(session.id!).remove();
  }
}
