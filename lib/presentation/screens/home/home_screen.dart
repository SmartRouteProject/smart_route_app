import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/presentation/providers/auth_provider.dart';
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // Draggable persistent bottom sheet height state
  double? _sheetHeight;
  static const double _minSheetHeight = 100;
  static const double _initialSheetHeight = 140;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxSheetHeight = size.height * 0.6;
    _sheetHeight ??= _initialSheetHeight.clamp(_minSheetHeight, maxSheetHeight);

    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final logoutResp = await ref.read(authProvider.notifier).logout();
              if (logoutResp) {
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
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                width: double.infinity,
                height: (_sheetHeight ?? _initialSheetHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, -2),
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          onTap: () async {
                            await showSearch(
                              context: context,
                              delegate: AddressSearchDelegate(),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "Excribe para añadir una parada",
                          ),
                        ),
                      ),
                      Expanded(child: StopsList()),
                    ],
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
