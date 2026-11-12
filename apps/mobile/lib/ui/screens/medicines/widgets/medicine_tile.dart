import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_strings.dart';
import '../../../../core/theme.dart';
import '../../../../data/models/medicine.dart';
import '../../../../state/medicine_controllers.dart';
import '../../../../state/providers.dart';

/// Medicine list tile with Take / Skip / Snooze actions
/// (Blueprint Part 6.5).
class MedicineTile extends ConsumerWidget {
  final Medicine medicine;
  const MedicineTile({super.key, required this.medicine});

  Future<void> _recordAction(
      BuildContext context, WidgetRef ref, DoseAction action) async {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final repo = ref.read(adherenceRepositoryProvider);

    final recorded = await repo.recordDose(
      medicine: medicine,
      slot: DoseSlot.morning,
      action: action,
    );

    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    if (action == DoseAction.taken && recorded == null) {
      messenger.showSnackBar(const SnackBar(
          content:
              Text('This dose was already recorded as taken today.')));
    } else {
      messenger.showSnackBar(
          SnackBar(content: Text('${action.label} recorded')));
    }

    ref.invalidate(todaysEventsProvider(medicine.profileId));
    ref.invalidate(doseHistoryProvider(medicine.profileId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medication, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    medicine.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                if (medicine.stock != null && medicine.stock! <= 5)
                  const Icon(Icons.warning_amber,
                      size: 18, color: DoseviaColors.warning),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              [
                if (medicine.strength?.isNotEmpty ?? false) medicine.strength!,
                if (medicine.instructions?.isNotEmpty ?? false)
                  medicine.instructions!,
                if (medicine.stock != null) 'Stock: ${medicine.stock}',
              ].join(' . '),
              style: const TextStyle(color: DoseviaColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l.taken(locale)),
                    onPressed: () =>
                        _recordAction(context, ref, DoseAction.taken),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: l.skip(locale),
                  icon: const Icon(Icons.skip_next),
                  onPressed: () =>
                      _recordAction(context, ref, DoseAction.skipped),
                ),
                IconButton(
                  tooltip: l.snooze(locale),
                  icon: const Icon(Icons.snooze),
                  onPressed: () =>
                      _recordAction(context, ref, DoseAction.snoozed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
