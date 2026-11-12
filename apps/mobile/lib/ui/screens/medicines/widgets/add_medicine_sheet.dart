import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_strings.dart';
import '../../../../data/models/medicine.dart';
import '../../../../state/medicine_controllers.dart';
import '../../../../state/providers.dart';

/// Bottom sheet to add a medicine with its dose slots
/// (Blueprint Parts 6.2, 6.4).
Future<void> showAddMedicineSheet(BuildContext context, String profileId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddMedicineSheet(profileId: profileId),
  );
}

class _AddMedicineSheet extends ConsumerStatefulWidget {
  final String profileId;
  const _AddMedicineSheet({required this.profileId});

  @override
  ConsumerState<_AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends ConsumerState<_AddMedicineSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _strengthCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  final _slots = <DoseSlot>{DoseSlot.morning};

  @override
  void dispose() {
    _nameCtrl.dispose();
    _strengthCtrl.dispose();
    _instructionsCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_slots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one dose time')),
      );
      return;
    }

    final repo = ref.read(medicineRepositoryProvider);
    await repo.create(
      profileId: widget.profileId,
      name: _nameCtrl.text.trim(),
      strength:
          _strengthCtrl.text.trim().isEmpty ? null : _strengthCtrl.text.trim(),
      instructions: _instructionsCtrl.text.trim().isEmpty
          ? null
          : _instructionsCtrl.text.trim(),
      stock: int.tryParse(_stockCtrl.text.trim()),
      slots: _slots.toList()..sort((a, b) => a.index.compareTo(b.index)),
    );

    ref.invalidate(medicinesForProfileProvider(widget.profileId));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.addMedicine(locale),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l.medicineName(locale)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _strengthCtrl,
              decoration: InputDecoration(labelText: l.strength(locale)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _instructionsCtrl,
              decoration: const InputDecoration(
                  labelText: 'Instructions (e.g. after food)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Stock (tablets left, optional)'),
            ),
            const SizedBox(height: 16),
            Text(l.doseTimes(locale),
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final slot in DoseSlot.values)
                  FilterChip(
                    label: Text(_slotLabel(slot, locale)),
                    selected: _slots.contains(slot),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _slots.add(slot);
                      } else {
                        _slots.remove(slot);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _save, child: Text(l.save(locale))),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.cancel(locale)),
            ),
          ],
        ),
      ),
    );
  }

  String _slotLabel(DoseSlot slot, Locale locale) {
    final l = AppStrings;
    return switch (slot) {
      DoseSlot.morning => l.morning(locale),
      DoseSlot.afternoon => l.afternoon(locale),
      DoseSlot.evening => l.evening(locale),
      DoseSlot.night => l.night(locale),
    };
  }
}
