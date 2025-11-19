import 'package:flutter/material.dart';
import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';
import 'package:intl/intl.dart';

class CustomSideMenu extends StatelessWidget {
  const CustomSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final vpSize = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Drawer(
      width: vpSize.width * 0.9,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 117, 193, 255),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 32, child: Icon(Icons.person)),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Nombre Apellido',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'usuario@correo.com',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Opciones de menú
            Expanded(
              child: ListView.separated(
                itemCount: sampleRoutes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final route = sampleRoutes[index];

                  return ListTile(
                    leading: const Icon(Icons.route),
                    // Fecha primero
                    title: Text(
                      dateFormat.format(route.creationDate),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    // Nombre de la ruta debajo
                    subtitle: Text(route.name),
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
                onPressed: () {},
                label: const Text("Nueva Ruta"),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
