import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';

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
          arrivalTimeLabel: 'Cualquier hora',
          description: '',
          packageList: stop is DeliveryStop ? const [] : null,
          selectedType: stop is DeliveryStop
              ? StopType.delivery
              : StopType.pickup,
        ),
      );

  void onAddressChanged(String value) {
    state = state.copyWith(address: value);
  }

  void onTypeChanged(StopType type) {
    state = state.copyWith(
      selectedType: type,
      packageList: type == StopType.delivery ? (state.packageList ?? []) : null,
    );
  }

  void onArrivalTimeLabelChanged(String value) {
    state = state.copyWith(arrivalTimeLabel: value);
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: value);
  }
}

class StopFormState {
  final String address;
  final String arrivalTimeLabel;
  final String description;
  final List<Package>? packageList;
  final StopType selectedType;

  StopFormState({
    required this.address,
    required this.arrivalTimeLabel,
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
    String? arrivalTimeLabel,
    String? description,
    List<Package>? packageList,
    StopType? selectedType,
  }) => StopFormState(
    address: address ?? this.address,
    arrivalTimeLabel: arrivalTimeLabel ?? this.arrivalTimeLabel,
    description: description ?? this.description,
    packageList: packageList ?? this.packageList,
    selectedType: selectedType ?? this.selectedType,
  );
}
