import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

class CustomGoogleMap extends ConsumerStatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  ConsumerState<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends ConsumerState<CustomGoogleMap> {
  Set<Marker> _markers = <Marker>{};
  int _markerRequestId = 0;
  double _devicePixelRatio = 1.0;

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
  void initState() {
    super.initState();
    _refreshMarkers(ref.read(mapProvider).selectedRoute?.stops ?? []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ratio = MediaQuery.of(context).devicePixelRatio;
    if (_devicePixelRatio != ratio) {
      _devicePixelRatio = ratio;
      _refreshMarkers(ref.read(mapProvider).selectedRoute?.stops ?? []);
    }
  }

  Future<void> _refreshMarkers(List<Stop> stops) async {
    final requestId = ++_markerRequestId;
    final markers = await _buildMarkers(stops, _devicePixelRatio, (stop) {
      ref.read(mapProvider.notifier).selectStop(stop);
    });

    if (!mounted || requestId != _markerRequestId) return;
    setState(() => _markers = markers);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    ref.listen<RouteEnt?>(
      mapProvider.select((state) => state.selectedRoute),
      (_, next) => _refreshMarkers(next?.stops ?? []),
    );
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: mapState.cameraPosition,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      markers: _markers,
      onMapCreated: (controller) =>
          ref.read(mapProvider.notifier).setMapController(controller),
    );
  }
}
