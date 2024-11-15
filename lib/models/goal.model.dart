import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? goalId;
  final String userId;
  final String title;
  final DateTime? deadline;
  final DateTime createdAt;
  final num goal;
  final num currentProgress;

  Goal({
    this.goalId,
    required this.userId,
    required this.title,
    required this.deadline,
    required this.createdAt,
    required this.goal,
    required this.currentProgress,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'createdAd': Timestamp.fromDate(createdAt),
      'goal': goal,
      'currentProgress': currentProgress,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map, String? docId) {
    return Goal(
      goalId: docId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      goal: map['goal'] ?? 0.0,
      currentProgress: map['currentProgress'] ?? 0.0,
    );
  }
}
