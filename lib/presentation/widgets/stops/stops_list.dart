import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/map_provider.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class StopsList extends ConsumerWidget {
  const StopsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final returnAddress = mapState.selectedRoute?.returnAddress;
    final selectedRoute = mapState.selectedRoute;
    final routeName = selectedRoute?.name ?? 'Ruta sin nombre';
    final stops = selectedRoute?.stops ?? [];

    return SafeArea(
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: stops.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: Icon(Icons.route),
                  title: Text('Parada #${index + 1}'),
                  subtitle: Text(stops[index].address),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierColor: Colors.black54,
                      barrierDismissible: true,
                      barrierLabel: 'close-stop-details',
                      transitionDuration: const Duration(milliseconds: 250),
                      pageBuilder: (_, __, ___) {
                        return StopDetailPage(stop: stops[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
