import 'package:cloud_firestore/cloud_firestore.dart';

class GoalPeriod {
  final DateTime periodStart;
  final DateTime periodEnd;
  final num progress;

  GoalPeriod({
    required this.periodStart,
    required this.periodEnd,
    required this.progress,
  });

  Map<String, dynamic> toMap() {
    return {
      'progress': progress,
      'periodStart': Timestamp.fromDate(periodStart),
      'periodEnd': Timestamp.fromDate(periodEnd),
    };
  }

  factory GoalPeriod.fromMap(Map<String, dynamic> map) {
    return GoalPeriod(
      periodStart: (map['periodStart'] as Timestamp).toDate(),
      periodEnd: (map['periodEnd'] as Timestamp).toDate(),
      progress: map['progress'] ?? 0.0,
    );
  }


}