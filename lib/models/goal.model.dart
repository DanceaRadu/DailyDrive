import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? goalId;
  final String userId;
  final String exerciseType;
  final String title;
  final DateTime createdAt;
  final num goal;
  final num currentProgress;

  Goal({
    this.goalId,
    required this.userId,
    required this.exerciseType,
    required this.title,
    required this.createdAt,
    required this.goal,
    required this.currentProgress,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'exerciseType': exerciseType,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'goal': goal,
      'currentProgress': currentProgress,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map, String? docId) {
    return Goal(
      goalId: docId,
      userId: map['userId'] ?? '',
      exerciseType: map['exerciseType'] ?? '',
      title: map['title'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      goal: map['goal'] ?? 0.0,
      currentProgress: map['currentProgress'] ?? 0.0,
    );
  }
}
