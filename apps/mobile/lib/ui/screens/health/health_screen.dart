import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_strings.dart';
import '../../../state/app_state.dart';
import 'widgets/vitals_section.dart';
import 'widgets/medical_id_card.dart';

/// Health tab: vitals, medical ID, emergency contacts
/// (Blueprint Parts 8.1, 7.6).
class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final profileId = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabHealth(locale))),
      body: profileId == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MedicalIdCard(profileId: profileId),
                const SizedBox(height: 16),
                VitalsSection(profileId: profileId),
              ],
            ),
    );
  }
}
