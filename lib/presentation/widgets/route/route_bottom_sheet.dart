import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/widgets/widgets.dart';
import '../../providers/providers.dart';

class RouteBottomSheet extends ConsumerWidget {
  final double height;

  const RouteBottomSheet({super.key, required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final returnAddress = mapState.selectedRoute?.returnAddress;
    final routeName = mapState.selectedRoute?.name ?? 'Ruta sin nombre';

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
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                onTap: () async {
                  await showSearch(
                    context: context,
                    delegate: AddressSearchDelegate(),
                  );
                },
                decoration: const InputDecoration(
                  hintText: "Excribe para añadir una parada",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  routeName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.home_outlined),
                title: Text(
                  returnAddress != null
                      ? (returnAddress.nickname.isNotEmpty
                            ? returnAddress.nickname
                            : returnAddress.address)
                      : 'Sin direccion de retorno',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {},
              ),
            ),
            const Expanded(child: StopsList()),
          ],
        ),
      ),
    );
  }
}
