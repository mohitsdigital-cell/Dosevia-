import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_strings.dart';
import '../../../core/theme.dart';
import '../../../data/models/medicine.dart';
import '../../../state/app_state.dart';
import '../../../state/medicine_controllers.dart';
import '../../../state/providers.dart';

/// Home dashboard (Blueprint Part 6.1): greeting, today's doses,
/// adherence ring, quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    if (hour < 12) return l.greetingMorning(locale);
    if (hour < 17) return l.greetingAfternoon(locale);
    if (hour < 21) return l.greetingEvening(locale);
    return l.greetingNight(locale);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final profileId = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.appName)),
      body: profileId == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_greeting(context),
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(l.todaySchedule(locale),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: DoseviaColors.textSecondary)),
                const SizedBox(height: 16),
                _TodayDosesCard(profileId: profileId),
                const SizedBox(height: 16),
                _AdherenceCard(profileId: profileId),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Text(
                  l.aiDisclaimer(locale),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: DoseviaColors.textSecondary),
                ),
              ],
            ),
    );
  }
}

class _TodayDosesCard extends ConsumerWidget {
  final String profileId;
  const _TodayDosesCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final medicinesAsync = ref.watch(medicinesForProfileProvider(profileId));

    return medicinesAsync.when(
      loading: () => const Card(child: SizedBox(height: 80)),
      error: (e, _) => Card(
        child: Padding(padding: const EdgeInsets.all(16), child: Text('$e')),
      ),
      data: (medicines) {
        if (medicines.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.medication_outlined,
                      size: 36, color: DoseviaColors.teal),
                  const SizedBox(height: 8),
                  Text(l.noMedicines(locale)),
                ],
              ),
            ),
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final m in medicines) ...[
                  Row(
                    children: [
                      const Icon(Icons.pill, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(m.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                      Text(m.strength ?? '',
                          style: TextStyle(
                              color: DoseviaColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AdherenceCard extends ConsumerWidget {
  final String profileId;
  const _AdherenceCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final repo = ref.watch(adherenceRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<double>(
          future: repo.adherenceForDay(profileId, DateTime.now()),
          builder: (context, snap) {
            final value = snap.data ?? 0;
            return Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    value: value,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: DoseviaColors.teal,
                    strokeWidth: 6,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${l.adherence(locale)}: ${(value * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
