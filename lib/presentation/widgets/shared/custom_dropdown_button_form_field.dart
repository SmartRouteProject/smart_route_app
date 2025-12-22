import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final Widget? icon;
  final bool enabled;

  const CustomDropdownButtonFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isExpanded = true,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      icon: icon,
      decoration: InputDecoration(
        label: label != null ? Text(label!) : null,
        hintText: hint,
        errorText: errorMessage,
      ),
    );
  }
}
