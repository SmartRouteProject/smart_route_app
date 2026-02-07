import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class RouteBottomSheet extends ConsumerWidget {
  final double height;

  const RouteBottomSheet({super.key, required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStop = ref.watch(mapProvider).selectedStop;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: selectedStop == null ? const StopsList() : const ActiveStop(),
    );
  }
}
