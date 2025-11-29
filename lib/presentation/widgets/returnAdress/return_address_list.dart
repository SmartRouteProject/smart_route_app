import 'package:flutter/material.dart';
import 'package:smart_route_app/infrastructure/mocks/return_adresses_sample.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ReturnAdressList extends StatelessWidget {
  const ReturnAdressList({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: 8,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ra = returnAddressesSample[index];

                  return ListTile(
                    leading: const Icon(Icons.route),
                    // Fecha primero
                    title: Text(ra.nickname),
                    // Nombre de la ruta debajo
                    subtitle: Text(ra.address),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete_outline),
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
