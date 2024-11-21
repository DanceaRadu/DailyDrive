import 'package:daily_drive/models/goal_period.model.dart';

class RepeatingGoal {
  final String? goalId;
  final String userId;
  final String exerciseType;
  final String title;
  final String periodType;
  final num goal;
  final List<GoalPeriod> periods;

  RepeatingGoal({
    this.goalId,
    required this.userId,
    required this.exerciseType,
    required this.title,
    required this.goal,
    required this.periodType,
    required this.periods,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'exerciseType': exerciseType,
      'title': title,
      'goal': goal,
      'periodType': periodType,
      'periods': periods.map((period) => period.toMap()).toList(),
    };
  }

  factory RepeatingGoal.fromMap(Map<String, dynamic> map, String? docId) {
    return RepeatingGoal(
      goalId: docId,
      userId: map['userId'] ?? '',
      exerciseType: map['exerciseType'] ?? '',
      title: map['title'] ?? '',
      goal: map['goal'] ?? 0.0,
      periodType: map['periodType'] ?? '',
      periods: map['periods'] != null
          ? (map['periods'] as List)
          .map((item) => GoalPeriod.fromMap(item))
          .toList()
          : [],
    );
  }

  GoalPeriod? getLatestPeriod() {
    if (periods.isEmpty) return null;
    return periods.reduce((latest, current) =>
    current.periodStart.isAfter(latest.periodStart) ? current : latest);
  }
}
