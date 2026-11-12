import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_strings.dart';
import '../../../state/app_state.dart';
import '../../../state/providers.dart';
import '../../../state/medicine_controllers.dart';

/// Profile tab (Blueprint Part 13.3): language, theme, dose history,
/// data export, about.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final db = await ref.read(appDatabaseProvider).db;
    final profileId = ref.read(activeProfileProvider);

    final medicines = await db.query('medicines',
        where: 'profile_id = ?', whereArgs: [profileId]);
    final doseEvents = await db.query('dose_events',
        where: 'profile_id = ?', whereArgs: [profileId]);
    final vitals = await db
        .query('vitals', where: 'profile_id = ?', whereArgs: [profileId]);

    final summary =
        'medicines: ${medicines.length}, dose_events: ${doseEvents.length}, vitals: ${vitals.length}';

    messenger.showSnackBar(SnackBar(content: Text('Export summary - $summary')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppStrings;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final historyAsync = ref
        .watch(doseHistoryProvider(ref.watch(activeProfileProvider) ?? ''));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProfile(locale))),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language / भाषा'),
            subtitle: Text(locale.languageCode == 'hi' ? 'हिन्दी' : 'English'),
            onTap: () => ref.read(localeProvider.notifier).set(
                locale.languageCode == 'hi'
                    ? const Locale('en')
                    : const Locale('hi')),
          ),
          ListTile(
            leading: Icon(themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            title: const Text('Dark mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (v) => ref
                  .read(themeModeProvider.notifier)
                  .set(v ? ThemeMode.dark : ThemeMode.light),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export data (summary)'),
            onTap: () => _exportData(context, ref),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.doseHistory(locale),
                style: Theme.of(context).textTheme.titleMedium),
          ),
          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Padding(padding: const EdgeInsets.all(16), child: Text('$e')),
            data: (events) => events.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No dose events yet.'))
                : Column(
                    children: [
                      for (final e in events.take(20))
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.history, size: 18),
                          title: Text(e.action.label),
                          subtitle: Text(
                              '${e.recordedAt.day}/${e.recordedAt.month}/${e.recordedAt.year}'),
                        ),
                    ],
                  ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Dosevia'),
            subtitle:
                Text('Your Health. Your Family. One Connected Care.'),
          ),
        ],
      ),
    );
  }
}
