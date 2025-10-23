import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';

class ChangePinBottomSheet extends ConsumerStatefulWidget {
  final String currentPin;
  final ValueChanged<String> onPinChanged;

  const ChangePinBottomSheet({
    super.key,
    required this.currentPin,
    required this.onPinChanged,
  });

  @override
  ConsumerState<ChangePinBottomSheet> createState() =>
      _ChangePinBottomSheetState();
}

class _ChangePinBottomSheetState extends ConsumerState<ChangePinBottomSheet> {
  String _enteredPin = '';
  String _confirmedPin = '';
  bool _isConfirming = false;
  bool _isError = false;

  void _onNumberPressed(String number) {
    if ((_isConfirming ? _confirmedPin : _enteredPin).length < 4) {
      setState(() {
        _isError = false;
        if (_isConfirming) {
          _confirmedPin += number;
        } else {
          _enteredPin += number;
        }
      });

      // Auto proceed when 4 digits are entered
      if ((_isConfirming ? _confirmedPin : _enteredPin).length == 4) {
        if (!_isConfirming) {
          // Move to confirmation
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _isConfirming = true;
            });
          });
        } else {
          // Validate confirmation
          _validatePinChange();
        }
      }
    }
  }

  void _validatePinChange() {
    if (_enteredPin != _confirmedPin) {
      setState(() {
        _isError = true;
        _enteredPin = '';
        _confirmedPin = '';
        _isConfirming = false;
      });
    } else {
      widget.onPinChanged(_enteredPin);
    }
  }

  void _onBackspacePressed() {
    setState(() {
      _isError = false;
      if (_isConfirming) {
        if (_confirmedPin.isNotEmpty) {
          _confirmedPin = _confirmedPin.substring(0, _confirmedPin.length - 1);
        } else {
          _isConfirming = false;
        }
      } else {
        if (_enteredPin.isNotEmpty) {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        }
      }
    });
  }

  String _getTitle() {
    if (_isConfirming) {
      return 'confirm_new_pin'.tr;
    }
    return 'enter_new_pin'.tr;
  }

  String _getSubtitle() {
    if (_isConfirming) {
      return 're_enter_4_digit_pin'.tr;
    }
    return 'enter_4_digit_pin'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.password_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          _getSubtitle(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // PIN Dots
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final currentPin = _isConfirming
                      ? _confirmedPin
                      : _enteredPin;
                  final hasDigit = index < currentPin.length;

                  return Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
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
                  );
                }),
              ),
            ),

            // Error Message
            if (_isError)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'pins_do_not_match'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            // Number Pad (same as PinBottomSheet)
            // ... include the same number pad widget structure
            // from the PinBottomSheet here
          ],
        ),
      ),
    );
  }
}
