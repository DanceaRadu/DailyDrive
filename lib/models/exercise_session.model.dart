import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseSession {
  final String? id;
  final String exerciseTypeId;
  final String userId;
  final num units;
  final int elapsedSeconds;
  final DateTime createdAt;

  ExerciseSession({
    this.id,
    required this.exerciseTypeId,
    required this.userId,
    required this.units,
    required this.elapsedSeconds,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseTypeId': exerciseTypeId,
      'userId': userId,
      'units': units,
      'elapsedSeconds': elapsedSeconds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ExerciseSession.fromMap(Map<String, dynamic> map, String? docId) {
    return ExerciseSession(
        id: docId,
        exerciseTypeId: map['exerciseTypeId'] ?? '',
        userId: map['userId'] ?? '',
        units: map['units'] ?? 0.0,
        elapsedSeconds: map['elapsedSeconds'] ?? 0,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}