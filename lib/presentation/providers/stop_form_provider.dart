import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/infrastructure/mocks/stops_sample.dart';
import 'package:smart_route_app/presentation/providers/map_provider.dart';

enum StopType { delivery, pickup }

final stopFormProvider =
    StateNotifierProvider.autoDispose.family<StopFormNotifier, StopFormState, Stop>(
      (ref, stop) {
        return StopFormNotifier(ref: ref, stop: stop);
      },
    );

class StopFormNotifier extends StateNotifier<StopFormState> {
  final Ref _ref;
  final Stop _originalStop;
  final IStopRepository _stopRepository;

  StopFormNotifier({required Ref ref, required Stop stop})
    : _ref = ref,
      _originalStop = stop,
      _stopRepository = StopRepositoryImpl(),
      super(
        StopFormState(
          address: stop.address,
          latitude: stop.latitude,
          longitude: stop.longitude,
          arrivalTime: _formatArrivalTime(stop.arrivalTime),
          description: stop.description,
          packageList: stop is DeliveryStop
              ? List<Package>.from(stop.packages)
              : null,
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

  void onAddressSelected(AddressSearch result) {
    state = state.copyWith(
      address: result.formattedAddress,
      latitude: result.latitude,
      longitude: result.longitude,
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

  void addPackage(Package package) {
    if (state.selectedType != StopType.delivery) return;
    final currentPackages = state.packageList ?? const <Package>[];
    state = state.copyWith(
      packageList: List<Package>.from([...currentPackages, package]),
    );
  }

  void updatePackage(int index, Package package) {
    if (state.selectedType != StopType.delivery) return;
    final currentPackages = List<Package>.from(
      state.packageList ?? const <Package>[],
    );
    if (index < 0 || index >= currentPackages.length) return;
    currentPackages[index] = package;
    state = state.copyWith(packageList: currentPackages);
  }

  void removePackage(int index) {
    if (state.selectedType != StopType.delivery) return;
    final currentPackages = List<Package>.from(
      state.packageList ?? const <Package>[],
    );
    if (index < 0 || index >= currentPackages.length) return;
    currentPackages.removeAt(index);
    state = state.copyWith(packageList: currentPackages);
  }

  Future<bool> onSubmit() async {
    final routeId = _ref.read(mapProvider).selectedRoute?.id;
    if (routeId == null || routeId.isEmpty) return false;
    if (state.isPosting) return false;

    state = state.copyWith(isPosting: true);
    final updatedStop = _buildUpdatedStop();
    final isNewStop = _originalStop.id == null || _originalStop.id!.isEmpty;
    final Stop? response = isNewStop
        ? await _stopRepository.createStop(routeId, updatedStop)
        : await _stopRepository.editStop(routeId, updatedStop);

    if (response == null) {
      state = state.copyWith(isPosting: false);
      return false;
    }

    _ref.read(mapProvider.notifier).upsertStop(
      originalStop: _originalStop,
      updatedStop: response,
    );
    state = state.copyWith(isPosting: false);
    return true;
  }

  Stop _buildUpdatedStop() {
    final address = state.address;
    final arrivalTime = _parseArrivalTime(state.arrivalTime);
    final description = state.description;

    if (state.selectedType == StopType.delivery) {
      return DeliveryStop(
        id: _originalStop.id,
        latitude: state.latitude,
        longitude: state.longitude,
        address: address,
        status: _originalStop.status,
        arrivalTime: arrivalTime,
        description: description,
        packages: state.packageList ?? const [],
      );
    }

    return PickupStop(
      id: _originalStop.id,
      latitude: state.latitude,
      longitude: state.longitude,
      address: address,
      status: _originalStop.status,
      arrivalTime: arrivalTime,
      description: description,
    );
  }
}

String _formatArrivalTime(DateTime? value) {
  if (value == null) return 'Cualquier hora';
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

DateTime? _parseArrivalTime(String value) {
  if (value.trim().isEmpty || value == 'Cualquier hora') return null;
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

class StopFormState {
  final String address;
  final double latitude;
  final double longitude;
  final String arrivalTime;
  final String description;
  final List<Package>? packageList;
  final StopType selectedType;
  final bool isPosting;

  StopFormState({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.arrivalTime,
    required this.description,
    required this.packageList,
    required this.selectedType,
    this.isPosting = false,
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
    bool? isPosting,
  }) => StopFormState(
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    arrivalTime: arrivalTime ?? this.arrivalTime,
    description: description ?? this.description,
    packageList: packageList ?? this.packageList,
    selectedType: selectedType ?? this.selectedType,
    isPosting: isPosting ?? this.isPosting,
  );
}
