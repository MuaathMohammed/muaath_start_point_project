// import 'package:flutter/material.dart';
// import '../localizations/app_localizations.dart';

// extension LocalizationExtensions on BuildContext {
//   AppLocalizations get loc => AppLocalizations.of(this)!;

//   // Quick access to common translations
//   String get trAppTitle => loc.appTitle;
//   String get trProducts => loc.products;
//   String get trCustomers => loc.customers;
//   String get trOrders => loc.orders;
//   String get trInventory => loc.inventory;
//   String get trPos => loc.pos;
//   String get trSettings => loc.settings;
//   String get trSearch => loc.search;
//   String get trAdd => loc.add;
//   String get trEdit => loc.edit;
//   String get trDelete => loc.delete;
//   String get trSave => loc.save;
//   String get trCancel => loc.cancel;
//   String get trLoading => loc.loading;
//   String get trError => loc.error;
//   String get trSuccess => loc.success;
//   String get trNoData => loc.noData;
// }
import 'package:flutter/material.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';
import '../localizations/app_localizations.dart';

extension LocalizationExtensions on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;

  // Quick access to common translations (optional - you can use 'key'.tr instead)
  String get trAppTitle => 'appTitle'.tr;
  String get trProducts => 'products'.tr;
  String get trCustomers => 'customers'.tr;
  String get trOrders => 'orders'.tr;
  String get trInventory => 'inventory'.tr;
  String get trPos => 'pos'.tr;
  String get trSettings => 'settings'.tr;
  String get trSearch => 'search'.tr;
  String get trAdd => 'add'.tr;
  String get trEdit => 'edit'.tr;
  String get trDelete => 'delete'.tr;
  String get trSave => 'save'.tr;
  String get trCancel => 'cancel'.tr;
  String get trLoading => 'loading'.tr;
  String get trError => 'error'.tr;
  String get trSuccess => 'success'.tr;
  String get trNoData => 'noData'.tr;

  // Settings specific
  String get trAppearance => 'appearance'.tr;
  String get trLanguage => 'language'.tr;
  String get trTheme => 'theme'.tr;
  String get trLight => 'light'.tr;
  String get trDark => 'dark'.tr;
  String get trSystem => 'system'.tr;
  String get trEnglish => 'english'.tr;
  String get trArabic => 'arabic'.tr;
  // ... add more as needed
}
