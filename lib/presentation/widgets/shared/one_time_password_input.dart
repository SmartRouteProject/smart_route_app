import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OneTimePasswordInput extends StatelessWidget {
  final int length;
  final double boxSize;

  const OneTimePasswordInput({super.key, this.length = 6, this.boxSize = 48});

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
        length,
        (_) => SizedBox(
          width: boxSize,
          height: boxSize,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: (boxSize - 20) / 2,
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
