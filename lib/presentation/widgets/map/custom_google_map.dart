import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';

class CustomGoogleMap extends ConsumerWidget {
  const CustomGoogleMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final stops = mapState.selectedRoute?.stops ?? [];
    final markers = stops.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;
      return Marker(
        markerId: MarkerId('stop-$index-${stop.latitude}-${stop.longitude}'),
        position: LatLng(stop.latitude, stop.longitude),
        infoWindow: InfoWindow(title: stop.address),
      );
    }).toSet();

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: mapState.cameraPosition,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      markers: markers,
      onMapCreated:
          (controller) =>
              ref.read(mapProvider.notifier).setMapController(controller),
    );
  }
}
