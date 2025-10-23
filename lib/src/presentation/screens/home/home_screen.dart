// lib/src/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';
import 'package:muaath_start_point_project/src/presentation/screens/settings/settings_screen.dart';
import '../../../core/services/security_service.dart';
import '../../widgets/componenets/custom_app_bar.dart';
import 'home_content_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContentScreen(), // ✅ Fixed: No recursion
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    WidgetsBinding.instance.addObserver(this); // ✅ Now this will work
    // Check PIN on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkPinSecurity();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ Now this will work
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Check PIN when app returns from background
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkPinSecurity();
        }
      });
    }
  }

  void _checkPinSecurity() async {
    try {
      final requirePin = await SecurityService.checkPinRequired(ref);
      if (requirePin && mounted) {
        await SecurityService.showPinVerificationDialog(context, ref);
      }
    } catch (e) {
      // Handle any errors silently
      debugPrint('PIN verification error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getAppBarTitle(),
        showBackButton: false,
        actions: _currentIndex == 0 ? _buildHomeActions() : null,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildHomeActions() {
    return [
      IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          // TODO: Show app info dialog
        },
      ),
    ];
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'home'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: 'settings'.tr,
        ),
      ],
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'home'.tr;
      case 1:
        return 'settings'.tr;
      default:
        return 'home'.tr;
    }
  }
}
