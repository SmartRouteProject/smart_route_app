import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/mocks/stops_sample.dart';

enum StopType { delivery, pickup }

final stopFormProvider =
    StateNotifierProvider.autoDispose.family<StopFormNotifier, StopFormState, Stop>(
      (ref, stop) {
        return StopFormNotifier(stop: stop);
      },
    );

class StopFormNotifier extends StateNotifier<StopFormState> {
  StopFormNotifier({required Stop stop})
    : super(
        StopFormState(
          address: stop.address,
          latitude: stop.latitude,
          longitude: stop.longitude,
          arrivalTime: 'Cualquier hora',
          description: '',
          packageList: stop is DeliveryStop ? const [] : null,
          selectedType: stop is DeliveryStop
              ? StopType.delivery
              : StopType.pickup,
        ),
      );

  void onAddressChanged(String value) {
    final matched = stopsSample.where((stop) => stop.address == value);
    final coords = matched.isNotEmpty ? matched.first : null;
    state = state.copyWith(
      address: value,
      latitude: coords?.latitude ?? state.latitude,
      longitude: coords?.longitude ?? state.longitude,
    );
  }

  void onTypeChanged(StopType type) {
    state = state.copyWith(
      selectedType: type,
      packageList: type == StopType.delivery ? (state.packageList ?? []) : null,
    );
  }

  void onArrivalTimeChanged(String value) {
    state = state.copyWith(arrivalTime: value);
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: value);
  }
}

class StopFormState {
  final String address;
  final double latitude;
  final double longitude;
  final String arrivalTime;
  final String description;
  final List<Package>? packageList;
  final StopType selectedType;

  StopFormState({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.arrivalTime,
    required this.description,
    required this.packageList,
    required this.selectedType,
  });

  String get typeLabel {
    if (selectedType == StopType.delivery) return 'Entrega';
    if (selectedType == StopType.pickup) return 'Recogida';
    return 'Parada';
  }

  StopFormState copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? arrivalTime,
    String? description,
    List<Package>? packageList,
    StopType? selectedType,
  }) => StopFormState(
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    arrivalTime: arrivalTime ?? this.arrivalTime,
    description: description ?? this.description,
    packageList: packageList ?? this.packageList,
    selectedType: selectedType ?? this.selectedType,
  );
}
