import 'package:flutter/material.dart';

import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CreateRoute extends StatelessWidget {
  const CreateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              CustomTextFormField(label: 'Nombre de la ruta'),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Seleccioná una fecha'),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {},
                  child: const Text('Crear ruta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
