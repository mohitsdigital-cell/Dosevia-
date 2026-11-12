import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_strings.dart';
import '../../../../core/theme.dart';
import '../../../../data/models/health.dart';
import '../../../../state/health_controllers.dart';
import '../../../../state/providers.dart';

/// Medical ID card (Blueprint Part 7.6): allergies, conditions,
/// emergency contacts.
class MedicalIdCard extends ConsumerWidget {
  final String profileId;
  const MedicalIdCard({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final profileAsync = ref.watch(profileByIdProvider(profileId));
    final contactsAsync = ref.watch(contactsForProfileProvider(profileId));

    return profileAsync.when(
      loading: () => const Card(child: SizedBox(height: 100)),
      error: (e, _) => Card(
          child: Padding(
              padding: const EdgeInsets.all(16), child: Text('$e'))),
      data: (profile) => Card(
        color: DoseviaColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.medical_services,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(l.medicalId(locale),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(profile?.name ?? '',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 12),
              if (profile?.allergies?.isNotEmpty ?? false)
                _line('Allergies', profile!.allergies!),
              if (profile?.conditions?.isNotEmpty ?? false)
                _line('Conditions', profile!.conditions!),
              if (profile?.emergencyNotes?.isNotEmpty ?? false)
                _line('Notes', profile!.emergencyNotes!),
              const SizedBox(height: 12),
              Text(l.emergencyContacts(locale),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              contactsAsync.maybeWhen(
                data: (contacts) => contacts.isEmpty
                    ? const Text('None added yet',
                        style: TextStyle(color: Colors.white70))
                    : Column(
                        children: [
                          for (final c in contacts) _contactRow(context, c),
                        ],
                      ),
                orElse: () => const SizedBox(height: 8),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: DoseviaColors.critical),
                  icon: const Icon(Icons.emergency, size: 18),
                  label: Text(l.emergencyCall112(locale)),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emergency: 112')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w600)),
              TextSpan(
                  text: value, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

  Widget _contactRow(BuildContext context, EmergencyContact c) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text('${c.name} - ${c.phone}',
            style: const TextStyle(color: Colors.white)),
      );
}
