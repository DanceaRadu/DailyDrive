import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_drive/models/exercise_type.model.dart';

class ExerciseTypesService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ExerciseType>> getExerciseTypes() {
    return _firestore
        .collection('exercise_types')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ExerciseType.fromMap(doc.data(), doc.id))
        .toList());
  }
}