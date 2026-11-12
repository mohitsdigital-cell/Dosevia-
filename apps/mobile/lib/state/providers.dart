import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/medicine_repository.dart';
import '../data/repositories/adherence_repository.dart';
import '../data/repositories/vitals_repository.dart';
import '../data/repositories/emergency_repository.dart';
import '../services/notification_service.dart';

/// Providers wired in main() with real instances;
/// tests override these (see test/).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in ProviderScope or tests');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('Override in ProviderScope or tests');
});

final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepository(ref.watch(appDatabaseProvider)));

final medicineRepositoryProvider = Provider<MedicineRepository>(
    (ref) => MedicineRepository(ref.watch(appDatabaseProvider)));

final adherenceRepositoryProvider = Provider<AdherenceRepository>(
    (ref) => AdherenceRepository(ref.watch(appDatabaseProvider)));

final vitalsRepositoryProvider = Provider<VitalsRepository>(
    (ref) => VitalsRepository(ref.watch(appDatabaseProvider)));

final emergencyRepositoryProvider = Provider<EmergencyRepository>(
    (ref) => EmergencyRepository(ref.watch(appDatabaseProvider)));

/// Locale + theme state used by MaterialApp in main.dart.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');
  void set(Locale locale) => state = locale;
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;
  void set(ThemeMode mode) => state = mode;
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
