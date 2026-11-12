import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_strings.dart';
import '../../../../data/models/health.dart';
import '../../../../state/health_controllers.dart';
import '../../../../state/providers.dart';

/// Vitals section (Blueprint Part 8.1): record + history.
class VitalsSection extends ConsumerWidget {
  final String profileId;
  const VitalsSection({super.key, required this.profileId});

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final valueCtrl = TextEditingController();
    final secondaryCtrl = TextEditingController();
    var currentType = VitalType.bloodPressure;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.addVital(locale),
                      style: Theme.of(sheetContext).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<VitalType>(
                    value: currentType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: [
                      for (final t in VitalType.values)
                        DropdownMenuItem(value: t, child: Text(t.label)),
                    ],
                    onChanged: (v) =>
                        setSheetState(() => currentType = v ?? currentType),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: valueCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: currentType.hasSecondaryValue
                            ? 'Systolic'
                            : 'Value (${currentType.unit})'),
                  ),
                  if (currentType.hasSecondaryValue) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: secondaryCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Diastolic'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      final value = double.tryParse(valueCtrl.text.trim());
                      if (value == null) return;
                      final repo = ref.read(vitalsRepositoryProvider);
                      await repo.record(
                        profileId: profileId,
                        type: currentType,
                        value: value,
                        secondaryValue:
                            double.tryParse(secondaryCtrl.text.trim()),
                      );
                      ref.invalidate(vitalsForProfileProvider(profileId));
                      Navigator.of(sheetContext).pop();
                    },
                    child: Text(l.save(locale)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final vitalsAsync = ref.watch(vitalsForProfileProvider(profileId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(l.vitals(locale),
                        style: Theme.of(context).textTheme.titleMedium)),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.add(locale)),
                  onPressed: () => _showAddSheet(context, ref),
                ),
              ],
            ),
            vitalsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('$e'),
              data: (vitals) {
                if (vitals.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      locale.languageCode == 'hi'
                          ? 'अभी कोई वाइटल रिकॉर्ड नहीं।'
                          : 'No vitals recorded yet.',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final v in vitals.take(10))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.monitor_heart, size: 20),
                        title: Text(v.type.label),
                        subtitle: Text(
                          '${v.recordedAt.day}/${v.recordedAt.month}/${v.recordedAt.year}',
                        ),
                        trailing: Text(v.displayValue,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
