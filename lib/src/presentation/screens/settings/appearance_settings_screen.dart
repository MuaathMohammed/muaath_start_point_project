// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../providers/providers.dart';
// import '../../widgets/settings/color_picker_widget.dart';
// import '../../widgets/settings/settings_section.dart';

// class AppearanceSettingsScreen extends ConsumerStatefulWidget {
//   const AppearanceSettingsScreen({super.key});

//   @override
//   ConsumerState<AppearanceSettingsScreen> createState() =>
//       _AppearanceSettingsScreenState();
// }

// class _AppearanceSettingsScreenState
//     extends ConsumerState<AppearanceSettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final settingsAsync = ref.watch(appSettingsStateProvider);

//     return Scaffold(
//       appBar: CustomAppBar(title: context.trAppearance, showBackButton: true),
//       body: settingsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (settings) {
//           return ListView(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             children: [
//               // Theme Section
//               SettingsSection(
//                 title: context.trTheme,
//                 subtitle: 'Choose your preferred theme',
//                 icon: Icons.brightness_6_outlined,
//                 children: [
//                   _buildThemeOption(
//                     context,
//                     title: context.trLight,
//                     value: 'light',
//                     currentValue: settings.themeMode,
//                     icon: Icons.light_mode_outlined,
//                   ),
//                   _buildThemeOption(
//                     context,
//                     title: context.trDark,
//                     value: 'dark',
//                     currentValue: settings.themeMode,
//                     icon: Icons.dark_mode_outlined,
//                   ),
//                   _buildThemeOption(
//                     context,
//                     title: context.trSystem,
//                     value: 'system',
//                     currentValue: settings.themeMode,
//                     icon: Icons.phone_iphone_outlined,
//                   ),
//                 ],
//               ),

//               // Language Section
//               SettingsSection(
//                 title: context.trLanguage,
//                 subtitle: 'Select app language',
//                 icon: Icons.language_outlined,
//                 children: [
//                   _buildLanguageOption(
//                     context,
//                     title: context.trEnglish,
//                     value: 'en',
//                     currentValue: settings.language,
//                     flag: '🇺🇸',
//                   ),
//                   _buildLanguageOption(
//                     context,
//                     title: context.trArabic,
//                     value: 'ar',
//                     currentValue: settings.language,
//                     flag: '🇸🇦',
//                   ),
//                 ],
//               ),

//               // Color Scheme Section
//               SettingsSection(
//                 title: context.trColor,
//                 subtitle: 'Choose your primary color',
//                 icon: Icons.color_lens_outlined,
//                 children: [
//                   const SizedBox(height: 8),
//                   ColorPickerWidget(
//                     selectedColor: settings.primaryColorValue,
//                     onColorSelected: (color) {
//                       ref
//                           .read(appSettingsStateProvider.notifier)
//                           .updateTheme(settings.themeMode, color);
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),

//               // Preview Section
//               SettingsSection(
//                 title: 'Preview',
//                 subtitle: 'See how your settings look',
//                 icon: Icons.visibility_outlined,
//                 children: [_buildThemePreview(context, settings)],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildThemeOption(
//     BuildContext context, {
//     required String title,
//     required String value,
//     required String currentValue,
//     required IconData icon,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: currentValue == value
//             ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
//             : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//         border: currentValue == value
//             ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
//             : null,
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: currentValue == value
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//         ),
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.w500,
//             color: currentValue == value
//                 ? Theme.of(context).colorScheme.primary
//                 : null,
//           ),
//         ),
//         trailing: currentValue == value
//             ? Icon(
//                 Icons.check_circle_rounded,
//                 color: Theme.of(context).colorScheme.primary,
//               )
//             : null,
//         onTap: () {
//           ref
//               .read(appSettingsStateProvider.notifier)
//               .updateTheme(
//                 value,
//                 Color(ref.read(appSettingsStateProvider).value!.primaryColor),
//               );
//         },
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildLanguageOption(
//     BuildContext context, {
//     required String title,
//     required String value,
//     required String currentValue,
//     required String flag,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: currentValue == value
//             ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
//             : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//         border: currentValue == value
//             ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
//             : null,
//       ),
//       child: ListTile(
//         leading: Text(flag, style: const TextStyle(fontSize: 24)),
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.w500,
//             color: currentValue == value
//                 ? Theme.of(context).colorScheme.primary
//                 : null,
//           ),
//         ),
//         trailing: currentValue == value
//             ? Icon(
//                 Icons.check_circle_rounded,
//                 color: Theme.of(context).colorScheme.primary,
//               )
//             : null,
//         onTap: () {
//           ref.read(appSettingsStateProvider.notifier).updateLanguage(value);
//         },
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildThemePreview(BuildContext context, settings) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           // App Bar Preview
//           Container(
//             height: 56,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 const SizedBox(width: 16),
//                 Icon(
//                   Icons.menu,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 const SizedBox(width: 16),
//                 Text(
//                   'Preview',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.person,
//                     color: Theme.of(context).colorScheme.onPrimary,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Content Preview
//           Row(
//             children: [
//               // Card Preview
//               Expanded(
//                 child: Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.shopping_cart_outlined,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.people_outline,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Button Preview
//           Container(
//             width: double.infinity,
//             height: 48,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Text(
//                 'Primary Button',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onPrimary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
