import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/medicine.dart';
import 'providers.dart';

/// Medicine list per profile.
final medicinesForProfileProvider =
    FutureProvider.family<List<Medicine>, String>((ref, profileId) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getForProfile(profileId);
});

/// Dose history per profile.
final doseHistoryProvider =
    FutureProvider.family<List<DoseEvent>, String>((ref, profileId) async {
  final repo = ref.watch(adherenceRepositoryProvider);
  return repo.history(profileId);
});

/// Today's dose events for the given profile.
final todaysEventsProvider =
    FutureProvider.family<List<DoseEvent>, String>((ref, profileId) async {
  final repo = ref.watch(adherenceRepositoryProvider);
  return repo.eventsForDay(profileId, DateTime.now());
});
