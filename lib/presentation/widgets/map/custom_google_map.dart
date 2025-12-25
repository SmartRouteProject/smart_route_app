import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';

class CustomGoogleMap extends ConsumerWidget {
  const CustomGoogleMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: mapState.cameraPosition,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
    );
  }
}
