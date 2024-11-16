class ExerciseType {
  final String? exerciseTypeId;
  final String name;
  final String namePlural;
  final String suffix;

  ExerciseType({
    this.exerciseTypeId,
    required this.name,
    required this.namePlural,
    required this.suffix
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'namePlural': namePlural,
      'suffix': suffix
    };
  }

  factory ExerciseType.fromMap(Map<String, dynamic> map, String? docId) {
    return ExerciseType(
      exerciseTypeId: docId,
      name: map['name'] ?? '',
      namePlural: map['namePlural'] ?? '',
      suffix: map['suffix'] ?? ''
    );
  }
}