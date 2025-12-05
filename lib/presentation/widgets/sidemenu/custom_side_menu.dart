import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class CustomSideMenu extends ConsumerWidget {
  const CustomSideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpSize = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Drawer(
      width: vpSize.width * 0.9,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _SideMenuHeader(),

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
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black54,
                    barrierDismissible: true,
                    barrierLabel: 'close-route-form',
                    transitionDuration: const Duration(milliseconds: 250),
                    pageBuilder: (_, __, ___) {
                      return const CreateRoute();
                    },
                  );
                },
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

class _SideMenuHeader extends ConsumerWidget {
  const _SideMenuHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!;

    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 117, 193, 255),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 32, child: Icon(Icons.person)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${user.name} ${user.lastName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          // Ícono arriba a la derecha
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.edit_square, color: Colors.white),
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  barrierDismissible: true,
                  barrierLabel: 'close-profile-form',
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (_, __, ___) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Perfil"),
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
                          child: const ProfileForm(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
