import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ReturnAdressList extends ConsumerWidget {
  const ReturnAdressList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnAddresses =
        ref.watch(authProvider).user?.returnAddresses ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis direcciones de retorno"),
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
              child: returnAddresses.isEmpty
                  ? const Center(child: Text('Sin direcciones de retorno'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: returnAddresses.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final ra = returnAddresses[index];

                        return ListTile(
                          leading: const Icon(Icons.route),
                          title: Text(ra.nickname),
                          subtitle: Text(
                            ra.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierColor: Colors.black54,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        'close-return-address-form-edit',
                                    transitionDuration:
                                        const Duration(milliseconds: 250),
                                    pageBuilder: (_, __, ___) {
                                      return CreateReturnAdressForm(
                                        returnAddress: ra,
                                        returnAddressIndex: index,
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
                            Navigator.pop(context); // cierra el drawer
                          },
                        );
                      },
                    ),
            ),

            Divider(),

            Container(
              padding: EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                heroTag: null,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black54,
                    barrierDismissible: true,
                    barrierLabel: 'close-return-address-form',
                    transitionDuration: const Duration(milliseconds: 250),
                    pageBuilder: (_, __, ___) {
                      return CreateReturnAdressForm();
                    },
                  );
                },
                label: const Text("Agregar direccion"),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
