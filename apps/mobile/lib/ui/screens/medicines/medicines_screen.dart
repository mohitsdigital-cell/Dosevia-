import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_strings.dart';
import '../../../state/app_state.dart';
import '../../../state/medicine_controllers.dart';
import 'widgets/add_medicine_sheet.dart';
import 'widgets/medicine_tile.dart';

/// Medicines tab: list, add, dose actions (Blueprint Parts 6.2-6.5).
class MedicinesScreen extends ConsumerWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final profileId = ref.watch(activeProfileProvider);
    final medicinesAsync =
        ref.watch(medicinesForProfileProvider(profileId ?? ''));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabMedicines(locale))),
      floatingActionButton: profileId == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: Text(l.addMedicine(locale)),
              onPressed: () => showAddMedicineSheet(context, profileId),
            ),
      body: medicinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (medicines) {
          if (medicines.isEmpty) {
            return Center(child: Text(l.noMedicines(locale)));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(medicinesForProfileProvider(profileId!)),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: medicines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  MedicineTile(medicine: medicines[i]),
            ),
          );
        },
      ),
    );
  }
}
