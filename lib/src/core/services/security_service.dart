// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:muaath_start_point_project/src/providers/providers.dart';

// import '../../presentation/screens/settings/components/pin_bottom_sheet.dart';

// class SecurityService {
//   static Future<bool> checkPinRequired(WidgetRef ref) async {
//     final settingsAsync = ref.read(appSettingsStateProvider);

//     return settingsAsync.when(
//       data: (settings) => settings.requirePin,
//       loading: () => false,
//       error: (_, __) => false,
//     );
//   }

//   static Future<String> getStoredPin(WidgetRef ref) async {
//     final settingsAsync = ref.read(appSettingsStateProvider);

//     return settingsAsync.when(
//       data: (settings) => settings.pinCode,
//       loading: () => '0000',
//       error: (_, __) => '0000',
//     );
//   }

//   static Future<bool> isFirstTimeSetup(WidgetRef ref) async {
//     final settingsAsync = ref.read(appSettingsStateProvider);

//     return settingsAsync.when(
//       data: (settings) =>
//           settings.pinCode == '0000', // Default PIN means first time
//       loading: () => false,
//       error: (_, __) => false,
//     );
//   }

//   static Future<void> showPinVerificationDialog(
//     BuildContext context,
//     WidgetRef ref,
//   ) async {
//     final requirePin = await checkPinRequired(ref);
//     if (!requirePin) return;

//     final storedPin = await getStoredPin(ref);

//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => FullScreenPinDialog(
//         correctPin: storedPin,
//         onSuccess: () {
//           // PIN verified successfully
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('PIN verified successfully'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 1),
//             ),
//           );
//         },
//         onCancel: () {
//           // User cancelled - close app or handle as needed
//           Navigator.popUntil(context, (route) => route.isFirst);
//         },
//       ),
//     );
//   }

//   static Future<void> showPinSetupDialog(
//     BuildContext context,
//     WidgetRef ref,
//   ) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => FullScreenPinDialog(
//         correctPin: '0000', // Not used in setup mode
//         onSuccess: () {
//           // PIN setup completed successfully
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('PIN set successfully'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         },
//         onCancel: () {
//           Navigator.pop(context);
//         },
//         isSetupMode: true,
//       ),
//     );
//   }

//   static Future<void> showFirstTimeSetupDialog(
//     BuildContext context,
//     WidgetRef ref,
//   ) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Text('Security Setup'),
//         content: Text('Would you like to set up a PIN code for app security?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // User chose not to setup PIN
//               ref
//                   .read(appSettingsStateProvider.notifier)
//                   .updateSecuritySettings(false, '0000');
//             },
//             child: Text('Not Now'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               showPinSetupDialog(context, ref);
//             },
//             child: Text('Setup PIN'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PinManagerService {
//   static Future<void> updatePin(WidgetRef ref, String newPin) async {
//     try {
//       await ref
//           .read(appSettingsStateProvider.notifier)
//           .updateSecuritySettings(
//             true, // Enable PIN when setting it
//             newPin,
//           );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<void> disablePin(WidgetRef ref) async {
//     try {
//       await ref
//           .read(appSettingsStateProvider.notifier)
//           .updateSecuritySettings(
//             false,
//             '0000', // Reset to default
//           );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> verifyCurrentPin(WidgetRef ref, String enteredPin) async {
//     final settingsAsync = ref.read(appSettingsStateProvider);

//     return settingsAsync.when(
//       data: (settings) => settings.pinCode == enteredPin,
//       loading: () => false,
//       error: (_, __) => false,
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muaath_start_point_project/src/presentation/screens/settings/components/pin_bottom_sheet.dart';
import 'package:muaath_start_point_project/src/providers/providers.dart';

class SecurityService {
  static Future<bool> checkPinRequired(WidgetRef ref) async {
    final settingsAsync = ref.read(appSettingsStateProvider);

    return settingsAsync.when(
      data: (settings) => settings.requirePin,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  static Future<String> getStoredPin(WidgetRef ref) async {
    final settingsAsync = ref.read(appSettingsStateProvider);

    return settingsAsync.when(
      data: (settings) => settings.pinCode,
      loading: () => '0000',
      error: (_, __) => '0000',
    );
  }

  static Future<void> showPinVerificationDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final requirePin = await checkPinRequired(ref);
    if (!requirePin) return;

    final storedPin = await getStoredPin(ref);

    // Use Completer to handle the dialog result properly
    final completer = Completer<void>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenPinDialog(
        correctPin: storedPin,
        onSuccess: () {
          // PIN verified successfully
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PIN verified successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );
          }
          completer.complete();
        },
        onCancel: () {
          // User cancelled - don't navigate, just close dialog
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PIN verification cancelled'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          completer.complete();
        },
      ),
    );

    return completer.future;
  }

  static Future<String?> showPinSetupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenPinDialog(
        correctPin: '0000',
        onSuccess: () {
          Navigator.pop(context, 'success');
        },
        onCancel: () {
          Navigator.pop(context, null);
        },
        isSetupMode: true,
      ),
    );
  }

  static Future<void> showFirstTimeSetupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal
      builder: (context) => AlertDialog(
        title: const Text('Security Setup'),
        content: const Text(
          'Would you like to set up a PIN code for app security?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // User chose not to setup PIN
              ref
                  .read(appSettingsStateProvider.notifier)
                  .updateSecuritySettings(false, '0000');
            },
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showPinSetupDialog(context, ref);
            },
            child: const Text('Setup PIN'),
          ),
        ],
      ),
    );
  }

  // Helper method to check if context is mounted
  static bool get mounted => true; // This is handled by the widget itself
}
