import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';
import '../../../core/services/security_service.dart';
import '../../../domain/entities/app_settings/app_settings.dart';
import '../../../providers/providers.dart';
import '../../widgets/componenets/custom_app_bar.dart';
import '../../widgets/componenets/loading_error_widgets.dart';
import 'components/pin_bottom_sheet.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _pendingNewPin; // Store the new PIN temporarily

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsStateProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Settings'.tr, showBackButton: true),
      body: settingsAsync.when(
        loading: () => const CustomLoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Failed to load settings',
          onRetry: () => ref.refresh(appSettingsStateProvider),
        ),
        data: (settings) {
          return ListView(
            children: [
              // Appearance Section
              _buildSettingsSection(
                context,
                title: 'Appearance'.tr,
                icon: Icons.palette_outlined,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Theme'.tr,
                    subtitle: 'Dark, Light, or System'.tr,
                    value: _getThemeDisplayName(settings.themeMode),
                    icon: Icons.brightness_6_outlined,
                    onTap: () => _showThemeDialog(context, ref, settings),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Language'.tr,
                    subtitle: 'App language'.tr,
                    value: _getLanguageDisplayName(settings.language),
                    icon: Icons.language_outlined,
                    onTap: () => _showLanguageDialog(context, ref, settings),
                  ),
                  _buildSettingsItem(
                    context,
                    title: 'Primary Color'.tr,
                    subtitle: 'Choose accent color'.tr,
                    value: '',
                    icon: Icons.color_lens_outlined,
                    onTap: () => _showColorDialog(context, ref, settings),
                  ),
                ],
              ),

              // Security Section
              _buildSettingsSection(
                context,
                title: 'Security'.tr,
                icon: Icons.security_outlined,
                children: [
                  _buildSwitchItem(
                    context,
                    title: 'Require PIN'.tr,
                    subtitle: 'Lock app with PIN code'.tr,
                    value: settings.requirePin,
                    icon: Icons.lock_outline,
                    onChanged: (value) async {
                      if (value) {
                        // Enable PIN - show setup dialog
                        await _setupPinCode(context, ref);
                      } else {
                        // Disable PIN - verify current PIN first
                        await _disablePinWithVerification(
                          context,
                          ref,
                          settings,
                        );
                      }
                    },
                  ),

                  if (settings.requirePin) ...[
                    _buildSettingsItem(
                      context,
                      title: 'Change PIN Code'.tr,
                      subtitle: 'Update your security PIN'.tr,
                      value: '',
                      icon: Icons.password_outlined,
                      onTap: () => _changePinCode(context, ref, settings),
                    ),
                  ],
                ],
              ),

              // About Section
              _buildSettingsSection(
                context,
                title: 'About'.tr,
                icon: Icons.info_outlined,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Version'.tr,
                    subtitle: 'App version information'.tr,
                    value: '1.0.0',
                    icon: Icons.info_outline,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // In SettingsScreen, simplify the PIN setup method:
  Future<void> _setupPinCode(BuildContext context, WidgetRef ref) async {
    final result = await SecurityService.showPinSetupDialog(context, ref);

    if (result == 'success') {
      // PIN setup was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_set_successfully'.tr),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // PIN setup was cancelled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_setup_cancelled'.tr),
          backgroundColor: Colors.orange,
        ),
      );
      // Refresh to show correct switch state (PIN not enabled)
      ref.refresh(appSettingsStateProvider);
    }
  }

  Future<void> _disablePinWithVerification(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenPinDialog(
        correctPin: settings.pinCode,
        onSuccess: () {
          Navigator.pop(context, true); // Verified successfully
        },
        onCancel: () {
          Navigator.pop(context, false); // Cancelled
        },
      ),
    );

    if (verified == true) {
      // Disable PIN security
      await ref
          .read(appSettingsStateProvider.notifier)
          .updateSecuritySettings(
            false, // Disable PIN
            settings.pinCode, // Keep existing PIN
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_disabled_successfully'.tr),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Verification failed or cancelled - keep PIN enabled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_verification_failed'.tr),
          backgroundColor: Colors.red,
        ),
      );

      // Refresh to show correct switch state
      ref.refresh(appSettingsStateProvider);
    }
  }

  Future<void> _changePinCode(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    // First verify current PIN
    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenPinDialog(
        correctPin: settings.pinCode,
        onSuccess: () {
          Navigator.pop(context, true); // Verified successfully
        },
        onCancel: () {
          Navigator.pop(context, false); // Cancelled
        },
      ),
    );

    if (verified != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_verification_failed'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Then setup new PIN
    final newPin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenPinDialog(
        correctPin: '0000', // Not used in setup mode
        onSuccess: () {
          Navigator.pop(context, _pendingNewPin);
        },
        onCancel: () {
          Navigator.pop(context, null);
        },
        isSetupMode: true,
      ),
    );

    if (newPin != null && newPin.isNotEmpty) {
      // Update with new PIN
      await ref
          .read(appSettingsStateProvider.notifier)
          .updateSecuritySettings(
            true, // Keep PIN enabled
            newPin, // New PIN
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pin_changed_successfully'.tr),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Helper method to update pending PIN (called from FullScreenPinDialog)
  void _updatePendingPin(String newPin) {
    setState(() {
      _pendingNewPin = newPin;
    });
  }

  // Your existing UI builder methods remain the same...
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Your existing theme, language, and color dialog methods...
  String _getThemeDisplayName(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light'.tr;
      case 'dark':
        return 'Dark'.tr;
      case 'system':
        return 'System'.tr;
      default:
        return 'Light'.tr;
    }
  }

  String _getLanguageDisplayName(String language) {
    switch (language) {
      case 'en':
        return 'English'.tr;
      case 'ar':
        return 'Arabic'.tr;
      default:
        return 'English'.tr;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              ref,
              settings,
              'Light'.tr,
              'light',
              Icons.light_mode_outlined,
            ),
            _buildThemeOption(
              context,
              ref,
              settings,
              'Dark'.tr,
              'dark',
              Icons.dark_mode_outlined,
            ),
            _buildThemeOption(
              context,
              ref,
              settings,
              'System'.tr,
              'system',
              Icons.phone_iphone_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    String title,
    String value,
    IconData icon,
  ) {
    final isSelected = settings.themeMode == value;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        ref
            .read(appSettingsStateProvider.notifier)
            .updateTheme(value, settings.primaryColorValue);
        Navigator.pop(context);
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              ref,
              settings,
              'English'.tr,
              'en',
              '🇺🇸',
            ),
            _buildLanguageOption(
              context,
              ref,
              settings,
              'Arabic'.tr,
              'ar',
              '🇸🇦',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    String title,
    String value,
    String flag,
  ) {
    final isSelected = settings.language == value;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 20)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        ref.read(appSettingsStateProvider.notifier).updateLanguage(value);
        Navigator.pop(context);
      },
    );
  }

  void _showColorDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Color'.tr),
        content: _buildColorGrid(context, ref, settings),
      ),
    );
  }

  Widget _buildColorGrid(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final colors = {
      'Blue': 0xFF2563EB,
      'Green': 0xFF059669,
      'Purple': 0xFF7C3AED,
      'Orange': 0xFFEA580C,
      'Pink': 0xFFDB2777,
      'Indigo': 0xFF4F46E5,
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.entries.map((entry) {
        final color = Color(entry.value);
        final isSelected = settings.primaryColor == entry.value;

        return GestureDetector(
          onTap: () {
            ref
                .read(appSettingsStateProvider.notifier)
                .updateTheme(settings.themeMode, color);
            Navigator.pop(context);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    )
                  : Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                      width: 2,
                    ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
