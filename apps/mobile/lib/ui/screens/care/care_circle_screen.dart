import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_strings.dart';
import '../../../state/app_state.dart';
import '../../../state/profile_controllers.dart';
import '../../../state/providers.dart';

/// Care Circle tab (Blueprint Part 7): family profiles and switching.
class CareCircleScreen extends ConsumerWidget {
  const CareCircleScreen({super.key});

  Future<void> _addMember(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final relationshipCtrl = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
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
            const Text('Add family member',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: relationshipCtrl,
              decoration: const InputDecoration(
                  labelText: 'Relationship (e.g. mother, son)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final repo = ref.read(profileRepositoryProvider);
                final profile = await repo.create(
                  name: name,
                  relationship: relationshipCtrl.text.trim().isEmpty
                      ? 'family'
                      : relationshipCtrl.text.trim(),
                );
                ref.invalidate(profilesProvider);
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                debugPrint('Created profile ${profile.name}');
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = Localizations.localeOf(context);
    final profilesAsync = ref.watch(profilesProvider);
    final activeId = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabCareCircle(locale))),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add),
        label: Text(l.add(locale)),
        onPressed: () => _addMember(context, ref),
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (profiles) {
          if (activeId == null && profiles.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(activeProfileProvider.notifier).set(profiles.first.id);
            });
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.careCircleSubtitle(locale),
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              for (final profile in profiles)
                Card(
                  child: RadioListTile<String>(
                    value: profile.id,
                    groupValue: activeId,
                    onChanged: (_) => ref
                        .read(activeProfileProvider.notifier)
                        .set(profile.id),
                    title: Text(profile.name),
                    subtitle: Text(profile.relationship),
                    secondary: CircleAvatar(
                      child: Text(
                          profile.name.isEmpty ? '?' : profile.name[0]),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
