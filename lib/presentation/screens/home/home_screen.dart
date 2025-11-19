import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(title: Text("HomeScreen")),
      drawer: CustomSideMenu(),
      body: GoogleMap(
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
      // Permanent, draggable bottom sheet
      bottomSheet: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            final next =
                (_sheetHeight ?? _initialSheetHeight) - details.delta.dy;
            _sheetHeight = next.clamp(_minSheetHeight, maxSheetHeight);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          width: double.infinity,
          height: (_sheetHeight ?? _initialSheetHeight).clamp(
            _minSheetHeight,
            maxSheetHeight,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                // Drag handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 12),
                // Content placeholder: replace with your widgets
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Routes nearby',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        tooltip: 'Expand',
                        icon: const Icon(Icons.keyboard_arrow_up_rounded),
                        onPressed: () {
                          setState(() => _sheetHeight = maxSheetHeight);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: 8,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.route),
                        title: Text('Route #${index + 1}'),
                        subtitle: const Text('Tap to view details'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
