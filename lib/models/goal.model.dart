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

  String getEncouragementText() {
    String encouragementText = "";
    if(currentProgress == 0) {
      encouragementText = "You haven't started yet. No worries, you can do it!";
    } else if(currentProgress / goal < 0.25) {
      encouragementText = "You're off to a good start! Let's see if you can keep it going!";
    } else if(currentProgress / goal < 0.5) {
      encouragementText = "You're almost halfway there! Keep it up!";
    } else if(currentProgress / goal < 0.75) {
      encouragementText = "You're almost there! Just a bit more";
    } else if(currentProgress / goal < 1) {
      encouragementText = "You're so close!";
    } else if(currentProgress == goal) {
      encouragementText = "Congratulations! You've reached your goal!";
    }
    return encouragementText;
  }
}
