import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreateReturnAdressForm extends StatelessWidget {
  const CreateReturnAdressForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar direccion de retorno"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    CustomTextFormField(label: 'Direccion'),
                    CustomTextFormField(label: 'Nombre'),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
