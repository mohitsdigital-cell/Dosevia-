import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Re-export surface for app-level state. Kept tiny in the MVP.
export 'providers.dart' show localeProvider, themeModeProvider;

/// Simple UI state holder: which patient profile is active.
class ActiveProfileController extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}

final activeProfileProvider =
    NotifierProvider<ActiveProfileController, String?>(
        ActiveProfileController.new);
