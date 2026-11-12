/// Patient profile model - Care Circle foundation (Blueprint Part 7.1).
class PatientProfile {
  final String id;
  final String name;
  final String relationship;
  final String? dateOfBirth;
  final String? allergies;
  final String? conditions;
  final String? bloodGroup;
  final String? emergencyNotes;
  final bool isArchived;

  const PatientProfile({
    required this.id,
    required this.name,
    required this.relationship,
    this.dateOfBirth,
    this.allergies,
    this.conditions,
    this.bloodGroup,
    this.emergencyNotes,
    this.isArchived = false,
  });

  PatientProfile copyWith({
    String? name,
    String? relationship,
    String? dateOfBirth,
    String? allergies,
    String? conditions,
    String? bloodGroup,
    String? emergencyNotes,
    bool? isArchived,
  }) =>
      PatientProfile(
        id: id,
        name: name ?? this.name,
        relationship: relationship ?? this.relationship,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        allergies: allergies ?? this.allergies,
        conditions: conditions ?? this.conditions,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        emergencyNotes: emergencyNotes ?? this.emergencyNotes,
        isArchived: isArchived ?? this.isArchived,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'relationship': relationship,
        'date_of_birth': dateOfBirth,
        'allergies': allergies,
        'conditions': conditions,
        'blood_group': bloodGroup,
        'emergency_notes': emergencyNotes,
        'is_archived': isArchived ? 1 : 0,
      };

  factory PatientProfile.fromMap(Map<String, Object?> map) => PatientProfile(
        id: map['id'] as String,
        name: map['name'] as String,
        relationship: map['relationship'] as String,
        dateOfBirth: map['date_of_birth'] as String?,
        allergies: map['allergies'] as String?,
        conditions: map['conditions'] as String?,
        bloodGroup: map['blood_group'] as String?,
        emergencyNotes: map['emergency_notes'] as String?,
        isArchived: (map['is_archived'] as int) == 1,
      );

  @override
  String toString() => 'PatientProfile($id, $name, $relationship)';
}
