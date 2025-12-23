import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OneTimePasswordInput extends StatefulWidget {
  final int length;
  final double boxSize;
  final ValueChanged<String>? onChanged;

  const OneTimePasswordInput({
    super.key,
    this.length = 6,
    this.boxSize = 48,
    this.onChanged,
  });

  @override
  State<OneTimePasswordInput> createState() => _OneTimePasswordInputState();
}

class _OneTimePasswordInputState extends State<OneTimePasswordInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
  }

  void _handleChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final outlineColor = Theme.of(context).colorScheme.outlineVariant;
    final focusColor = Theme.of(context).colorScheme.primary;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: widget.boxSize,
          height: widget.boxSize,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _handleChanged(index, value),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: (widget.boxSize - 20) / 2,
                horizontal: 0,
              ),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: outlineColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: focusColor, width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
