import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/map_provider.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class StopsList extends ConsumerWidget {
  const StopsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(mapProvider).selectedRoute;
    final stops = selectedRoute?.stops ?? [];

    return ListView.builder(
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
    );
  }
}
