import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/health.dart';
import '../data/models/patient_profile.dart';
import 'providers.dart';

/// All active profiles.
final profilesProvider = FutureProvider<List<PatientProfile>>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final profiles = await repo.getAll();
  if (profiles.isEmpty) {
    await repo.ensureDefault();
    return repo.getAll();
  }
  return profiles;
});

/// Single profile by id.
final profileByIdProvider =
    FutureProvider.family<PatientProfile?, String>((ref, id) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getById(id);
});

/// Care Circle members for a profile.
final careMembersProvider =
    FutureProvider.family<List<CareMember>, String>((ref, profileId) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.members(profileId);
});
