/// Medicine model (Blueprint Part 6.2).
class Medicine {
  final String id;
  final String profileId;
  final String name;
  final String? brandName;
  final String? strength;
  final String? dosageForm;
  final String? doseQuantity;
  final String? instructions;
  final String? notes;
  final int? stock;
  final bool isActive;

  const Medicine({
    required this.id,
    required this.profileId,
    required this.name,
    this.brandName,
    this.strength,
    this.dosageForm,
    this.doseQuantity,
    this.instructions,
    this.notes,
    this.stock,
    this.isActive = true,
  });

  Medicine copyWith({
    String? name,
    String? brandName,
    String? strength,
    String? dosageForm,
    String? doseQuantity,
    String? instructions,
    String? notes,
    int? stock,
    bool? isActive,
  }) =>
      Medicine(
        id: id,
        profileId: profileId,
        name: name ?? this.name,
        brandName: brandName ?? this.brandName,
        strength: strength ?? this.strength,
        dosageForm: dosageForm ?? this.dosageForm,
        doseQuantity: doseQuantity ?? this.doseQuantity,
        instructions: instructions ?? this.instructions,
        notes: notes ?? this.notes,
        stock: stock ?? this.stock,
        isActive: isActive ?? this.isActive,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'profile_id': profileId,
        'name': name,
        'brand_name': brandName,
        'strength': strength,
        'dosage_form': dosageForm,
        'dose_quantity': doseQuantity,
        'instructions': instructions,
        'notes': notes,
        'stock': stock,
        'is_active': isActive ? 1 : 0,
      };

  factory Medicine.fromMap(Map<String, Object?> map) => Medicine(
        id: map['id'] as String,
        profileId: map['profile_id'] as String,
        name: map['name'] as String,
        brandName: map['brand_name'] as String?,
        strength: map['strength'] as String?,
        dosageForm: map['dosage_form'] as String?,
        doseQuantity: map['dose_quantity'] as String?,
        instructions: map['instructions'] as String?,
        notes: map['notes'] as String?,
        stock: map['stock'] as int?,
        isActive: (map['is_active'] as int) == 1,
      );
}

/// The four standard dose slots (Blueprint Part 6.1).
enum DoseSlot { morning, afternoon, evening, night }

extension DoseSlotX on DoseSlot {
  String get label => switch (this) {
        DoseSlot.morning => 'Morning',
        DoseSlot.afternoon => 'Afternoon',
        DoseSlot.evening => 'Evening',
        DoseSlot.night => 'Night',
      };

  int get defaultHour => switch (this) {
        DoseSlot.morning => 8,
        DoseSlot.afternoon => 13,
        DoseSlot.evening => 18,
        DoseSlot.night => 22,
      };
}

/// Every dose action (Blueprint Part 6.5).
enum DoseAction { taken, skipped, snoozed, unavailable }

extension DoseActionX on DoseAction {
  String get label => switch (this) {
        DoseAction.taken => 'Taken',
        DoseAction.skipped => 'Skipped',
        DoseAction.snoozed => 'Snoozed',
        DoseAction.unavailable => 'Unavailable',
      };
}

/// A recorded dose event - immutable history (Blueprint Parts 6.5 and 11).
class DoseEvent {
  final String id;
  final String medicineId;
  final String profileId;
  final DateTime scheduledAt;
  final DoseAction action;
  final DateTime recordedAt;
  final String? note;

  const DoseEvent({
    required this.id,
    required this.medicineId,
    required this.profileId,
    required this.scheduledAt,
    required this.action,
    required this.recordedAt,
    this.note,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'medicine_id': medicineId,
        'profile_id': profileId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'action': action.name,
        'recorded_at': recordedAt.toIso8601String(),
        'note': note,
      };

  factory DoseEvent.fromMap(Map<String, Object?> map) => DoseEvent(
        id: map['id'] as String,
        medicineId: map['medicine_id'] as String,
        profileId: map['profile_id'] as String,
        scheduledAt: DateTime.parse(map['scheduled_at'] as String),
        action: DoseAction.values.firstWhere((a) => a.name == (map['action'] as String)),
        recordedAt: DateTime.parse(map['recorded_at'] as String),
        note: map['note'] as String?,
      );
}
