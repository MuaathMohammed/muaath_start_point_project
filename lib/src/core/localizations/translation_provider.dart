import 'package:flutter/material.dart';
import 'translation_service.dart';

class TranslationProvider extends InheritedWidget {
  final TranslationService service;

  const TranslationProvider({
    super.key,
    required this.service,
    required super.child,
  });

  static TranslationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TranslationProvider>();
  }

  @override
  bool updateShouldNotify(TranslationProvider oldWidget) {
    return service.locale != oldWidget.service.locale;
  }
}
