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
}