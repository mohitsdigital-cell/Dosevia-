/// Vitals model (Blueprint Part 8.1).
enum VitalType {
  bloodPressure('Blood pressure', 'mmHg'),
  fastingGlucose('Fasting glucose', 'mg/dL'),
  postMealGlucose('Post-meal glucose', 'mg/dL'),
  hba1c('HbA1c', '%'),
  weight('Weight', 'kg'),
  pulse('Pulse', 'bpm'),
  temperature('Temperature', '°C'),
  spo2('SpO2', '%');

  final String label;
  final String unit;
  const VitalType(this.label, this.unit);

  bool get hasSecondaryValue => this == bloodPressure;
}

class Vital {
  final String id;
  final String profileId;
  final VitalType type;
  final double value;
  final double? secondaryValue;
  final DateTime recordedAt;
  final String? note;

  const Vital({
    required this.id,
    required this.profileId,
    required this.type,
    required this.value,
    this.secondaryValue,
    required this.recordedAt,
    this.note,
  });

  String get displayValue =>
      type.hasSecondaryValue && secondaryValue != null
          ? '${value.round()}/${secondaryValue!.round()} ${type.unit}'
          : '$value ${type.unit}';

  Map<String, Object?> toMap() => {
        'id': id,
        'profile_id': profileId,
        'type': type.name,
        'value': value,
        'secondary_value': secondaryValue,
        'unit': type.unit,
        'recorded_at': recordedAt.toIso8601String(),
        'note': note,
      };

  factory Vital.fromMap(Map<String, Object?> map) => Vital(
        id: map['id'] as String,
        profileId: map['profile_id'] as String,
        type: VitalType.values.firstWhere((t) => t.name == (map['type'] as String)),
        value: (map['value'] as num).toDouble(),
        secondaryValue: (map['secondary_value'] as num?)?.toDouble(),
        recordedAt: DateTime.parse(map['recorded_at'] as String),
        note: map['note'] as String?,
      );
}

/// Emergency contact (Blueprint Part 7.6).
class EmergencyContact {
  final String id;
  final String profileId;
  final String name;
  final String phone;
  final String? relationship;

  const EmergencyContact({
    required this.id,
    required this.profileId,
    required this.name,
    required this.phone,
    this.relationship,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'profile_id': profileId,
        'name': name,
        'phone': phone,
        'relationship': relationship,
      };

  factory EmergencyContact.fromMap(Map<String, Object?> map) => EmergencyContact(
        id: map['id'] as String,
        profileId: map['profile_id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String,
        relationship: map['relationship'] as String?,
      );
}

/// Care Circle member link (Blueprint Parts 7.1-7.3).
class CareMember {
  final String id;
  final String profileId;
  final String name;
  final String? relationship;
  final String permissionLevel;
  final String status;

  const CareMember({
    required this.id,
    required this.profileId,
    required this.name,
    this.relationship,
    this.permissionLevel = 'view',
    this.status = 'active',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'profile_id': profileId,
        'member_name': name,
        'relationship': relationship,
        'permission_level': permissionLevel,
        'status': status,
        'invited_at': DateTime.now().toIso8601String(),
      };

  factory CareMember.fromMap(Map<String, Object?> map) => CareMember(
        id: map['id'] as String,
        profileId: map['profile_id'] as String,
        name: map['member_name'] as String,
        relationship: map['relationship'] as String?,
        permissionLevel: map['permission_level'] as String,
        status: map['status'] as String,
      );
}
