import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/returnAdress/return_address_list.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Draggable persistent bottom sheet height state
  double? _sheetHeight;
  static const double _minSheetHeight = 150;
  static const double _initialSheetHeight = 140;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final size = MediaQuery.of(context).size;
    final maxSheetHeight = size.height * 0.6;
    _sheetHeight ??= _initialSheetHeight.clamp(_minSheetHeight, maxSheetHeight);
    final showOptimizeSection =
        mapState.selectedRoute?.state == RouteState.planned;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final logoutResp = await ref.read(authProvider.notifier).logout();
              if (logoutResp) {
                // ignore: use_build_context_synchronously
                context.pushReplacementNamed(LoginScreen.name);
              }
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      drawer: CustomSideMenu(),

      body: Stack(
        children: [
          // MAPA
          const CustomGoogleMap(),

          Positioned(
            bottom:
                (_sheetHeight ?? _initialSheetHeight) +
                12, // <-- separación fija
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  barrierDismissible: true,
                  barrierLabel: 'close-return-adress-list',
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (_, __, ___) {
                    return ReturnAdressList();
                  },
                );
              },
              elevation: 2,
              child: Icon(Icons.home),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  final next =
                      (_sheetHeight ?? _initialSheetHeight) - details.delta.dy;
                  final maxSheetHeight =
                      MediaQuery.of(context).size.height * 0.6;
                  _sheetHeight = next.clamp(_minSheetHeight, maxSheetHeight);
                });
              },
              child: RouteBottomSheet(
                height: (_sheetHeight ?? _initialSheetHeight),
              ),
            ),
          ),

          if (showOptimizeSection)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: BoxBorder.all(color: Colors.grey.shade300),
                  ),
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: LoadingFloatingActionButton(
                      label: "Optimizar",
                      loader: false,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
