import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goal.model.dart';

class GoalsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Goal>> getGoals(String userId) {
    return _firestore
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Goal.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addGoal(Goal goal) async {
    try {
      await _firestore
          .collection('goals')
          .add(goal.toMap());
    } catch (e) {
      throw Exception('Failed to add goal: $e');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestore
          .collection('goals')
          .doc(goalId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }
}