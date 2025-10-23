// import 'package:flutter/material.dart';

// import '../localizations/translation_provider.dart';
// import '../localizations/translation_service.dart';

// extension StringTranslation on String {
//   String get tr {
//     final translationService = _getTranslationService();
//     return translationService?.translate(this) ?? this;
//   }

//   TranslationService? _getTranslationService() {
//     final context = _currentContext;
//     if (context != null) {
//       return context
//           .dependOnInheritedWidgetOfExactType<TranslationProvider>()
//           ?.service;
//     }
//     return null;
//   }

//   BuildContext? get _currentContext {
//     final navigatorKey = GlobalKey<NavigatorState>();
//     return navigatorKey.currentContext;
//   }
// }

// // Easy translation with parameters
// extension StringTranslationWithParams on String {
//   String trParams([Map<String, String>? params]) {
//     var translated = tr;
//     if (params != null) {
//       params.forEach((key, value) {
//         translated = translated.replaceAll('{{$key}}', value);
//       });
//     }
//     return translated;
//   }
// }

// // Quick access to common translations
// extension QuickTranslations on BuildContext {
//   // Settings
//   String get trSettings => 'settings'.tr;
//   String get trAppearance => 'appearance'.tr;
//   String get trLanguage => 'language'.tr;
//   String get trTheme => 'theme'.tr;
//   String get trLight => 'light'.tr;
//   String get trDark => 'dark'.tr;
//   String get trSystem => 'system'.tr;
//   String get trEnglish => 'english'.tr;
//   String get trArabic => 'arabic'.tr;
//   String get trColor => 'color'.tr;
//   String get trBusiness => 'business'.tr;
//   String get trCompany => 'company'.tr;
//   String get trTax => 'tax'.tr;
//   String get trCurrency => 'currency'.tr;
//   String get trSecurity => 'security'.tr;
//   String get trPinCode => 'pinCode'.tr;
//   String get trRequirePin => 'requirePin'.tr;
//   String get trPosSettings => 'posSettings'.tr;
//   String get trPrintReceipt => 'printReceipt'.tr;
//   String get trReceiptFooter => 'receiptFooter'.tr;
//   String get trAskForCustomer => 'askForCustomer'.tr;
//   String get trShowStockWarning => 'showStockWarning'.tr;
//   String get trSync => 'sync'.tr;
//   String get trAutoSync => 'autoSync'.tr;
//   String get trSyncInterval => 'syncInterval'.tr;
//   String get trMinutes => 'minutes'.tr;
//   String get trLastSync => 'lastSync'.tr;
//   String get trSyncNow => 'syncNow'.tr;
//   String get trAbout => 'about'.tr;
//   String get trVersion => 'version'.tr;
//   String get trPrivacy => 'privacy'.tr;
//   String get trTerms => 'terms'.tr;
//   String get trRetry => 'retry'.tr;
//   String get trSave => 'save'.tr;
//   String get trCancel => 'cancel'.tr;
//   String get trReset => 'reset'.tr;
//   String get trChangesSaved => 'changesSaved'.tr;

//   // Main App
//   String get trDashboard => 'dashboard'.tr;
//   String get trProducts => 'products'.tr;
//   String get trPos => 'pos'.tr;
//   String get trInventory => 'inventory'.tr;
//   String get trCustomers => 'customers'.tr;
//   String get trOrders => 'orders'.tr;
//   String get trSearch => 'search'.tr;
//   String get trAdd => 'add'.tr;
//   String get trEdit => 'edit'.tr;
//   String get trDelete => 'delete'.tr;
//   String get trLoading => 'loading'.tr;
//   String get trError => 'error'.tr;
//   String get trSuccess => 'success'.tr;
//   String get trNoData => 'noData'.tr;
//   String get trCompanyName => 'companyName'.tr;
//   String get trTaxRate => 'taxRate'.tr;
//   String get trSelectTheme => 'selectTheme'.tr;
//   String get trSelectLanguage => 'selectLanguage'.tr;
//   String get trSelectColor => 'selectColor'.tr;
//   String get trCompanyInformation => 'companyInformation'.tr;
// }
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../localizations/app_localizations.dart';

extension StringTranslation on String {
  String get tr {
    
    // Try to get the context
    final context = navigatorKey.currentContext;
              print("Test Tr ");
          print(context);

    if (context != null) {
      final appLocalizations = AppLocalizations.of(context);


      if (appLocalizations != null) {
        return appLocalizations.translate(this);
      }
    }
    // Fallback: return the key itself if no context or localization found
    return this;
  }

  // Helper method to get the current context
  BuildContext? get _currentContext {
    try {
      // This is a common approach to get context in extensions
      final navigatorKey = GlobalKey<NavigatorState>();
      return navigatorKey.currentContext;
    } catch (e) {
      return null;
    }
  }
}

// Alternative approach using a global navigator key
// Add this to your main.dart and pass it to MaterialApp
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// extension StringTranslationWithContext on String {
//   String trWithContext(BuildContext context) {
//     final appLocalizations = AppLocalizations.of(context);
//     return appLocalizations?.translate(this) ?? this;
//   }
// }
