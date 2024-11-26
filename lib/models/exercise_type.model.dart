class ExerciseType {
  final String? exerciseTypeId;
  final String name;
  final String namePlural;
  final String suffix;
  final String color;
  final num caloriesPerUnit;
  final String icon;

  ExerciseType({
    this.exerciseTypeId,
    required this.name,
    required this.namePlural,
    required this.suffix,
    required this.color,
    required this.caloriesPerUnit,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'namePlural': namePlural,
      'suffix': suffix,
      'color': color,
      'caloriesPerUnit': caloriesPerUnit,
      'icon': icon,
    };
  }

  factory ExerciseType.fromMap(Map<String, dynamic> map, String? docId) {
    return ExerciseType(
      exerciseTypeId: docId,
      name: map['name'] ?? '',
      namePlural: map['namePlural'] ?? '',
      suffix: map['suffix'] ?? '',
      color: map['color'] ?? '',
      caloriesPerUnit: map['caloriesPerUnit'] ?? 0.0,
      icon: map['icon'] ?? '',
    );
  }
}