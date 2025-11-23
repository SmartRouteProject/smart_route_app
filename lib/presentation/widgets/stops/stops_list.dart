import 'package:flutter/material.dart';
import 'package:smart_route_app/infrastructure/mocks/stops_sample.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class StopsList extends StatelessWidget {
  const StopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 8,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(Icons.route),
          title: Text('Route #${index + 1}'),
          subtitle: Text('Tap to view details'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierColor: Colors.black54,
              barrierDismissible: true,
              barrierLabel: 'close-return-adress-list',
              transitionDuration: const Duration(milliseconds: 250),
              pageBuilder: (_, __, ___) {
                return StopDetailPage(stop: stopsSample[0]);
              },
            );
          },
        ),
      ),
    );
  }
}
