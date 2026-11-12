import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/health.dart';
import 'providers.dart';

/// Vitals history for a profile.
final vitalsForProfileProvider =
    FutureProvider.family<List<Vital>, String>((ref, profileId) async {
  final repo = ref.watch(vitalsRepositoryProvider);
  return repo.forProfile(profileId);
});

/// Emergency contacts for a profile.
final contactsForProfileProvider =
    FutureProvider.family<List<EmergencyContact>, String>(
        (ref, profileId) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.contacts(profileId);
});
