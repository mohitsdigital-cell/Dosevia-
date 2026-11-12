import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_strings.dart';
import 'screens/home/home_screen.dart';
import 'screens/medicines/medicines_screen.dart';
import 'screens/health/health_screen.dart';
import 'screens/care/care_circle_screen.dart';
import 'screens/profile/profile_screen.dart';

/// Five-tab bottom navigation (Blueprint Part 13.3).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l = AppStrings;

    final tabs = [
      const HomeScreen(),
      const MedicinesScreen(),
      const HealthScreen(),
      const CareCircleScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.tabHome(locale),
          ),
          NavigationDestination(
            icon: const Icon(Icons.medication_outlined),
            selectedIcon: const Icon(Icons.medication),
            label: l.tabMedicines(locale),
          ),
          NavigationDestination(
            icon: const Icon(Icons.monitor_heart_outlined),
            selectedIcon: const Icon(Icons.monitor_heart),
            label: l.tabHealth(locale),
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group),
            label: l.tabCareCircle(locale),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l.tabProfile(locale),
          ),
        ],
      ),
    );
  }
}
