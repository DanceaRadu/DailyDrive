import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_drive/models/exercise_session.model.dart';

class ExerciseSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSession(ExerciseSession session) async {
    try {
      await _firestore
          .collection('exercise_sessions')
          .add(session.toMap());
    } catch (e) {
      throw Exception('Failed to add goal: $e');
    }
  }

  Future<List<ExerciseSession>> getSessionsForToday(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final snapshot = await _firestore
          .collection('exercise_sessions')
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .get();

      return snapshot.docs
          .map((doc) => ExerciseSession.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sessions: $e');
    }
  }
}