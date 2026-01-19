import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';

class OptimizationDialog extends ConsumerWidget {
  const OptimizationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(optimizationProvider);
    final notifier = ref.read(optimizationProvider.notifier);

    return AlertDialog(
      title: const Text('Optimizacion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Optimizar paradas'),
            value: state.optimizeStops,
            onChanged: state.optimizing ? null : notifier.setOptimizeStops,
          ),
          if (state.optimizing)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(optimizationProvider.notifier).onSubmit();
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
