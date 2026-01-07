import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class AssignedPackagesList extends ConsumerWidget {
  const AssignedPackagesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStop = ref.watch(
      mapProvider.select((state) => state.selectedStop),
    );
    if (selectedStop == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Paquetes asignados'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: const Center(child: Text('Sin parada seleccionada.')),
      );
    }

    final stopForm = ref.watch(stopFormProvider(selectedStop));
    final packages = stopForm.packageList ?? const <Package>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paquetes asignados'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: packages.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final package = packages[index];
                  final description = package.description.trim().isEmpty
                      ? 'Paquete ${index + 1}'
                      : package.description;

                  return ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(description),
                    subtitle: Text('Peso: ${package.weight.label}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              barrierColor: Colors.black54,
                              barrierDismissible: true,
                              barrierLabel: 'close-edit-package-form',
                              transitionDuration: const Duration(
                                milliseconds: 250,
                              ),
                              pageBuilder: (_, __, ___) {
                                return CreatePackageForm(
                                  stop: selectedStop,
                                  initialPackage: package,
                                  packageIndex: index,
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black54,
                        barrierDismissible: true,
                        barrierLabel: 'close-package-detail',
                        transitionDuration: const Duration(milliseconds: 250),
                        pageBuilder: (_, __, ___) {
                          return PackageDetailPage(package: package);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                heroTag: null,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black54,
                    barrierDismissible: true,
                    barrierLabel: 'close-create-package-form',
                    transitionDuration: const Duration(milliseconds: 250),
                    pageBuilder: (_, __, ___) {
                      return CreatePackageForm(stop: selectedStop);
                    },
                  );
                },
                label: const Text('Agregar Paquete'),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
