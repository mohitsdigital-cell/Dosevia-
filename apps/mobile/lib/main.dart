import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'core/app_strings.dart';
import 'data/db/app_database.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';
import 'ui/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const DoseviaApp(),
    ),
  );
}

class DoseviaApp extends ConsumerWidget {
  const DoseviaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Dosevia',
      debugShowCheckedModeBanner: false,
      theme: DoseviaTheme.light,
      darkTheme: DoseviaTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (context) => AppStrings.appName,
      home: const AppShell(),
    );
  }
}
