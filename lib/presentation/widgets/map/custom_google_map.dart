import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> _moveCameraForStops(List<Stop> stops) async {
    if (stops.isEmpty) {
      await ref.read(mapProvider.notifier).setCurrentPosition();
      return;
    }

    final controller = ref.read(mapProvider).mapController;
    if (controller == null) return;

    var minLat = stops.first.latitude;
    var maxLat = stops.first.latitude;
    var minLng = stops.first.longitude;
    var maxLng = stops.first.longitude;

    for (final stop in stops.skip(1)) {
      if (stop.latitude < minLat) minLat = stop.latitude;
      if (stop.latitude > maxLat) maxLat = stop.latitude;
      if (stop.longitude < minLng) minLng = stop.longitude;
      if (stop.longitude > maxLng) maxLng = stop.longitude;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (position.latitude < minLat) minLat = position.latitude;
      if (position.latitude > maxLat) maxLat = position.latitude;
      if (position.longitude < minLng) minLng = position.longitude;
      if (position.longitude > maxLng) maxLng = position.longitude;
    } catch (_) {}

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 72));
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    ref.listen<RouteEnt?>(mapProvider.select((state) => state.selectedRoute), (
      _,
      next,
    ) {
      final stops = next?.stops ?? [];
      _refreshMarkers(stops);
      _moveCameraForStops(stops);
    });
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: mapState.cameraPosition,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      markers: _markers,
      polylines: mapState.polylines,
      onMapCreated: (controller) =>
          ref.read(mapProvider.notifier).setMapController(controller),
    );
  }
}
