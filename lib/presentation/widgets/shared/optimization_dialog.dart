import 'package:flutter/material.dart';

class OptimizationDialog extends StatefulWidget {
  const OptimizationDialog({super.key});

  @override
  State<OptimizationDialog> createState() => _OptimizationDialogState();
}

class _OptimizationDialogState extends State<OptimizationDialog> {
  bool _optimizeStops = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Optimizacion'),
      content: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Optimizar paradas'),
        value: _optimizeStops,
        onChanged: (value) {
          setState(() {
            _optimizeStops = value;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Aceptar'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
