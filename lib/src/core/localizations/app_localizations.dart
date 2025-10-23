import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'muaath_start_point_project',

      'settings': 'Settings',
      'search': 'Search...',
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'noData': 'No data available',
      'appearance': 'Appearance',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'english': 'English',
      'arabic': 'Arabic',
      'color': 'Color',
      'business': 'Business',
      'company': 'Company',
      'tax': 'Tax',
      'currency': 'Currency',
      'security': 'Security',
      'pinCode': 'PIN Code',
      'requirePin': 'Require PIN',
      'posSettings': 'POS Settings',
      'printReceipt': 'Print Receipt',
      'receiptFooter': 'Receipt Footer',
      'askForCustomer': 'Ask for Customer',
      'showStockWarning': 'Show Stock Warning',
      'sync': 'Sync',
      'autoSync': 'Auto Sync',
      'syncInterval': 'Sync Interval',
      'minutes': 'minutes',
      'lastSync': 'Last Sync',
      'syncNow': 'Sync Now',
      'about': 'About',
      'version': 'Version',
      'privacy': 'Privacy Policy',
      'terms': 'Terms of Service',
      'retry': 'Retry',
      'reset': 'Reset to Default',
      'changesSaved': 'Changes saved successfully',
      "dashboard": "Dashboard",
      "manage_business": "Manage your business operations",
      "total_sales": "Total Sales",

      "point_of_sale": "Point of Sale",
      "process_sales": "Process sales & payments",
      "manage_inventory": "Manage inventory",
      "customer_database": "Customer database",
      "sales_history": "Sales history",
      "product_categories": "Product categories",
      "manage_locations": "Manage locations",
      "sales_analytics": "Sales analytics",
      "app_configuration": "App configuration",
      "loading_dashboard": "Loading dashboard...",
      "error_loading": "Error loading dashboard",
      "uom": "Units of Measure",
      "uoms": "UOMs",
      "add_uom": "Add UOM",
      "edit_uom": "Edit UOM",
      "uom_name": "UOM Name",
      "uom_code": "UOM Code",
      "base_uom": "Base UOM",
      "conversion_rate": "Conversion Rate",
      "is_base_unit": "Is Base Unit",
      "base_unit": "Base Unit",
      "manage_uoms": "Manage Units of Measure",
      "no_uoms": "No units of measure found",
      "uom_added": "UOM added successfully",
      "uom_updated": "UOM updated successfully",
      "uom_deleted": "UOM deleted successfully",
      "delete_uom": "Delete UOM",
      "delete_uom_confirmation": "Are you sure you want to delete this UOM?",
      "uom_type": "UOM Type",
      "uom_type_unit": "Unit",
      "uom_type_weight": "Weight",
      "uom_type_volume": "Volume",
      "uom_type_length": "Length",
      "decimals": "Decimals",
      "is_active": "Is Active",
      "active": "Active",
      "inactive": "Inactive",
      "search_uoms": "Search UOMs...",
      "required_field": "This field is required",
      "code_already_exists": "UOM code already exists",
      "categories": "Categories",
      "category": "Category",
      "add_category": "Add Category",
      "edit_category": "Edit Category",
      "category_name": "Category Name",
      "category_code": "Category Code",
      "category_description": "Description",
      "parent_category": "Parent Category",
      "no_parent": "No Parent",
      "manage_categories": "Manage Categories",
      "no_categories": "No categories found",
      "category_added": "Category added successfully",
      "category_updated": "Category updated successfully",
      "category_deleted": "Category deleted successfully",
      "delete_category": "Delete Category",
      "delete_category_confirmation":
          "Are you sure you want to delete this category?",
      "search_categories": "Search categories...",
      "root_categories": "Root Categories",
      "subcategories": "Subcategories",
      "has_subcategories": "Has subcategories",
      "select_parent": "Select Parent Category",
      "warehouses": "Warehouses",
      "warehouse": "Warehouse",
      "add_warehouse": "Add Warehouse",
      "edit_warehouse": "Edit Warehouse",
      "warehouse_name": "Warehouse Name",
      "warehouse_code": "Warehouse Code",
      "location": "Location",
      "warehouse_type": "Warehouse Type",
      "warehouse_type_central": "Central",
      "warehouse_type_seller": "Seller",
      "warehouse_type_store": "Store",
      "is_default": "Is Default",
      "default_warehouse": "Default Warehouse",
      "set_as_default": "Set as Default",
      "manage_warehouses": "Manage Warehouses",
      "no_warehouses": "No warehouses found",
      "warehouse_added": "Warehouse added successfully",
      "warehouse_updated": "Warehouse updated successfully",
      "warehouse_deleted": "Warehouse deleted successfully",
      "delete_warehouse": "Delete Warehouse",
      "delete_warehouse_confirmation":
          "Are you sure you want to delete this warehouse?",
      "search_warehouses": "Search warehouses...",
      "active_warehouses": "Active Warehouses",
      "set_default_success": "Default warehouse set successfully",
      "suppliers": "Suppliers",
      "supplier": "Supplier",
      "add_supplier": "Add Supplier",
      "edit_supplier": "Edit Supplier",
      "supplier_name": "Supplier Name",
      "supplier_code": "Supplier Code",
      "contact_person": "Contact Person",
      "email": "Email",
      "phone": "Phone",
      "address": "Address",
      "tax_number": "Tax Number",
      "payment_terms": "Payment Terms",
      "manage_suppliers": "Manage Suppliers",
      "no_suppliers": "No suppliers found",
      "date": "Date",
      "time": "Time",
      "customer": "Customer",
      "cashier": "Cashier",
      "items": "Items",
      "subtotal": "Subtotal",
      "discount": "Discount",
      'Settings': 'Settings',
      'home': 'Home',

      // Error messages
      'Failed to load settings': 'Failed to load settings',

      // Appearance Section
      'Appearance': 'Appearance',
      'Theme': 'Theme',
      'Dark, Light, or System': 'Dark, Light, or System',
      'Language': 'Language',
      'App language': 'App language',
      'Primary Color': 'Primary Color',
      'Choose accent color': 'Choose accent color',

      // Theme options
      'Light': 'Light',
      'Dark': 'Dark',
      'System': 'System',
      'Select Theme': 'Select Theme',

      // Language options
      'English': 'English',
      'Arabic': 'Arabic',
      'Select Language': 'Select Language',

      // Security Section
      'Security': 'Security',
      'Require PIN': 'Require PIN',
      'Lock app with PIN code': 'Lock app with PIN code',
      'Change PIN Code': 'Change PIN Code',
      'Update your security PIN': 'Update your security PIN',

      // PIN-related messages
      'pin_set_successfully': 'PIN set successfully',
      'pin_setup_cancelled': 'PIN setup cancelled',
      'pin_disabled_successfully': 'PIN disabled successfully',
      'pin_verification_failed': 'PIN verification failed',
      'pin_changed_successfully': 'PIN changed successfully',

      // About Section
      'About': 'About',
      'Version': 'Version',
      'App version information': 'App version information',
    },
    'ar': {
      'appTitle': 'بائع سيرب',
      'products': 'المنتجات',
      'customers': 'العملاء',
      'orders': 'الطلبات',
      'inventory': 'المخزون',
      'pos': 'نقطة البيع',
      'settings': 'الإعدادات',
      'search': 'بحث...',
      'add': 'إضافة',
      'edit': 'تعديل',
      'delete': 'حذف',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'noData': 'لا توجد بيانات',
      'appearance': 'المظهر',
      'language': 'اللغة',
      'theme': 'السمة',
      'light': 'فاتح',
      'dark': 'داكن',
      'system': 'النظام',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'color': 'اللون',
      'business': 'الأعمال',
      'company': 'الشركة',
      'tax': 'الضريبة',
      'currency': 'العملة',
      'security': 'الأمان',
      'pinCode': 'رمز PIN',
      'requirePin': 'طلب رمز PIN',
      'posSettings': 'إعدادات نقطة البيع',
      'printReceipt': 'طباعة الإيصال',
      'receiptFooter': 'تذييل الإيصال',
      'askForCustomer': 'السؤال عن العميل',
      'showStockWarning': 'عرض تحذير المخزون',
      'sync': 'المزامنة',
      'autoSync': 'مزامنة تلقائية',
      'syncInterval': 'فترة المزامنة',
      'minutes': 'دقائق',
      'lastSync': 'آخر مزامنة',
      'syncNow': 'مزامنة الآن',
      'about': 'حول',
      'version': 'الإصدار',
      'privacy': 'سياسة الخصوصية',
      'terms': 'شروط الخدمة',
      'retry': 'إعادة المحاولة',
      'reset': 'إعادة التعيين',
      'changesSaved': 'تم حفظ التغييرات بنجاح',
      'Settings': 'الإعدادات',
      'Failed to load settings': 'فشل في تحميل الإعدادات',

      // Appearance
      'home': 'البداية',
      'Appearance': 'المظهر',
      'Theme': 'السمة',
      'Dark, Light, or System': 'داكن، فاتح، أو النظام',
      'Language': 'اللغة',
      'App language': 'لغة التطبيق',
      'Primary Color': 'اللون الأساسي',
      'Choose accent color': 'اختر اللون المميز',
      'Select Theme': 'اختر السمة',
      'Light': 'فاتح',
      'Dark': 'داكن',
      'System': 'النظام',
      'Select Language': 'اختر اللغة',
      'English': 'الإنجليزية',
      'Arabic': 'العربية',

      // Security
      'Security': 'الأمان',
      'Require PIN': 'طلب رمز PIN',
      'Lock app with PIN code': 'قفل التطبيق برمز PIN',
      'Change PIN Code': 'تغيير رمز PIN',
      'Update your security PIN': 'تحديث رمز الأمان الخاص بك',

      // PIN Messages
      'pin_set_successfully': 'تم تعيين الرمز بنجاح',
      'pin_setup_cancelled': 'تم إلغاء إعداد الرمز',
      'pin_disabled_successfully': 'تم تعطيل الرمز بنجاح',
      'pin_verification_failed': 'فشل التحقق من الرمز',
      'pin_changed_successfully': 'تم تغيير الرمز بنجاح',

      // About
      'About': 'حول',
      'Version': 'الإصدار',
      'App version information': 'معلومات إصدار التطبيق',
      "close": "إغلاق",
    },
  };

  // Generic translate method - this is what makes 'key'.tr possible
  String translate(String key) {
    print("Test Tr ${this}");

    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // You can keep the individual getters if you want, but they're optional now
  String get appTitle => translate('appTitle');
  String get products => translate('products');
  String get customers => translate('customers');
  // ... keep other getters if needed, but they're not required for the .tr extension
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
