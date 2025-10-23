import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';

class FullScreenPinDialog extends ConsumerStatefulWidget {
  final String correctPin;
  final VoidCallback onSuccess;
  final VoidCallback? onCancel;
  final bool isSetupMode; // For PIN setup vs verification

  const FullScreenPinDialog({
    super.key,
    required this.correctPin,
    required this.onSuccess,
    this.onCancel,
    this.isSetupMode = false,
  });

  @override
  ConsumerState<FullScreenPinDialog> createState() =>
      _FullScreenPinDialogState();
}

class _FullScreenPinDialogState extends ConsumerState<FullScreenPinDialog> {
  String _enteredPin = '';
  bool _isError = false;
  bool _isLoading = false;
  bool _isConfirming = false;
  String _firstPin = '';
  String get currentPin => _isConfirming ? _enteredPin : _firstPin;
  void _onNumberPressed(String number) {
    if (_enteredPin.length < 4) {
      setState(() {
        _isError = false;
        _enteredPin += number;
      });

      // Auto-validate when 4 digits are entered
      if (_enteredPin.length == 4) {
        if (widget.isSetupMode && !_isConfirming) {
          // First PIN entry in setup mode
          setState(() {
            _firstPin = _enteredPin;
            _enteredPin = '';
            _isConfirming = true;
          });
        } else {
          _validatePin();
        }
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _isError = false;
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _validatePin() {
    if (widget.isSetupMode && _isConfirming) {
      // Confirm PIN in setup mode
      if (_enteredPin == _firstPin) {
        _completeSetup();
      } else {
        setState(() {
          _isError = true;
          _enteredPin = '';
          _firstPin = '';
          _isConfirming = false;
        });
      }
    } else {
      // Normal PIN verification
      if (_enteredPin == widget.correctPin) {
        _completeVerification();
      } else {
        setState(() {
          _isError = true;
          _enteredPin = '';
        });
      }
    }
  }

  // In FullScreenPinDialog, add a way to get the final PIN
  String get finalPin {
    if (widget.isSetupMode) {
      return _isConfirming ? _enteredPin : _firstPin;
    }
    return _enteredPin;
  }

  // Update the success callback in setup mode
  void _completeSetup() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Simply call onSuccess - let the parent handle navigation
        widget.onSuccess();
      }
    });
  }

  void _completeVerification() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Simply call onSuccess - let the parent handle navigation
        widget.onSuccess();
      }
    });
  }

  void _onCancel() {
    if (widget.isSetupMode && _isConfirming) {
      // Go back to first PIN entry
      setState(() {
        _enteredPin = '';
        _firstPin = '';
        _isConfirming = false;
        _isError = false;
      });
    } else {
      // Call the cancel callback - let parent handle navigation
      widget.onCancel?.call();
    }
  }

  void _notifyPinCompleted() {
    widget.onSuccess(); // The parent will handle getting the PIN
  }
  // void _completeSetup() {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // Save the new PIN
  //   final newPin = _isConfirming ? _enteredPin : _firstPin;

  //   // Update settings with new PIN
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     if (mounted) {
  //       Navigator.pop(context);

  //       // Call the success callback with the new PIN
  //       if (widget.isSetupMode) {
  //         // For setup mode, we need to update the settings
  //         _updatePinInSettings(newPin);
  //       } else {
  //         widget.onSuccess();
  //       }
  //     }
  //   });
  // }

  void _updatePinInSettings(String newPin) {
    // This will be handled by the parent widget
    widget.onSuccess(); // The parent will handle the PIN update
  }

  String _getTitle() {
    if (widget.isSetupMode) {
      return _isConfirming ? 'confirm_pin'.tr : 'set_pin'.tr;
    }
    return 'enter_pin'.tr;
  }

  String _getSubtitle() {
    if (widget.isSetupMode) {
      return _isConfirming ? 're_enter_pin'.tr : 'create_4_digit_pin'.tr;
    }
    return 'enter_4_digit_pin'.tr;
  }

  Widget _buildPinDots() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final hasDigit = index < _enteredPin.length;
          return Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasDigit
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              border: Border.all(
                color: _isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: _isLoading && hasDigit
                ? Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : null,
          );
        }),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onNumberPressed(number),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    VoidCallback onTap, {
    bool isCancel = false,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: isCancel
                    ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: isCancel
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isCancel
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _getTitle(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSubtitle(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // PIN Dots
                _buildPinDots(),

                // Error Message
                if (_isError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      widget.isSetupMode && _isConfirming
                          ? 'pins_do_not_match'.tr
                          : 'incorrect_pin'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),

                // Number Pad
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Row 1: 1, 2, 3
                        Expanded(
                          child: Row(
                            children: [
                              _buildNumberButton('1'),
                              _buildNumberButton('2'),
                              _buildNumberButton('3'),
                            ],
                          ),
                        ),

                        // Row 2: 4, 5, 6
                        Expanded(
                          child: Row(
                            children: [
                              _buildNumberButton('4'),
                              _buildNumberButton('5'),
                              _buildNumberButton('6'),
                            ],
                          ),
                        ),

                        // Row 3: 7, 8, 9
                        Expanded(
                          child: Row(
                            children: [
                              _buildNumberButton('7'),
                              _buildNumberButton('8'),
                              _buildNumberButton('9'),
                            ],
                          ),
                        ),

                        // Row 4: Cancel, 0, Backspace
                        Expanded(
                          child: Row(
                            children: [
                              _buildActionButton(
                                Icons.close,
                                'cancel'.tr,
                                _onCancel,
                                isCancel: true,
                              ),
                              _buildNumberButton('0'),
                              _buildActionButton(
                                Icons.backspace_outlined,
                                'clear'.tr,
                                _onBackspacePressed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
