import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

class CustomGoogleMap extends ConsumerWidget {
  const CustomGoogleMap({super.key});

  Future<Set<Marker>> _buildMarkers(
    List<Stop> stops,
    double devicePixelRatio,
    void Function(Stop stop) onStopTap,
  ) async {
    final futures = stops.asMap().entries.map((entry) async {
      final index = entry.key + 1;
      final stop = entry.value;
      final baseMarker = Marker(
        markerId: MarkerId(
          'stop-${index - 1}-${stop.latitude}-${stop.longitude}',
        ),
        position: LatLng(stop.latitude, stop.longitude),
        onTap: () => onStopTap(stop),
      );
      return GoogleMapsCustomMarker.createCustomMarker(
        marker: baseMarker,
        shape: MarkerShape.bubble,
        title: index.toString(),
        textSize: 50,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        enableShadow: true,
        circleOptions: CircleMarkerOptions(diameter: 144),
        imagePixelRatio: devicePixelRatio,
      );
    }).toList();

    return (await Future.wait(futures)).toSet();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final stops = mapState.selectedRoute?.stops ?? [];
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final markersFuture = _buildMarkers(stops, devicePixelRatio, (stop) {
      ref.read(mapProvider.notifier).selectStop(stop);
    });

    return FutureBuilder<Set<Marker>>(
      future: markersFuture,
      builder: (context, snapshot) {
        final markers = snapshot.data ?? <Marker>{};
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: mapState.cameraPosition,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          markers: markers,
          onMapCreated: (controller) =>
              ref.read(mapProvider.notifier).setMapController(controller),
        );
      },
    );
  }
}
