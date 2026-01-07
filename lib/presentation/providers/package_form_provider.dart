import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/stop_form_provider.dart';

final packageFormProvider = StateNotifierProvider.autoDispose
    .family<PackageFormNotifier, PackageFormState, Stop>((ref, stop) {
      return PackageFormNotifier(ref: ref, stop: stop);
    });

class PackageFormNotifier extends StateNotifier<PackageFormState> {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();
  final Stop _stop;

  PackageFormNotifier({required Ref ref, required Stop stop})
    : _ref = ref,
      _stop = stop,
      super(PackageFormState());

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: value);
  }

  void onWeightChanged(PackageWeightType? value) {
    if (value == null) return;
    state = state.copyWith(weight: value);
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      state = state.copyWith(picture: File(picked.path));
    }
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked != null) {
      state = state.copyWith(picture: File(picked.path));
    }
  }

  void clearImage() {
    state = state.copyWith(picture: null);
  }

  Future<bool> onFormSubmit() async {
    if (state.isPosting) return false;
    state = state.copyWith(isPosting: true);

    final package = Package(
      description: state.description.trim(),
      weight: state.weight,
      picture: state.picture,
    );

    _ref.read(stopFormProvider(_stop).notifier).addPackage(package);

    state = state.copyWith(isPosting: false);
    return true;
  }
}

class PackageFormState {
  final String description;
  final PackageWeightType weight;
  final File? picture;
  final bool isPosting;

  PackageFormState({
    this.description = '',
    this.weight = PackageWeightType.under_25kg,
    this.picture,
    this.isPosting = false,
  });

  PackageFormState copyWith({
    String? description,
    PackageWeightType? weight,
    File? picture,
    bool? isPosting,
  }) => PackageFormState(
    description: description ?? this.description,
    weight: weight ?? this.weight,
    picture: picture ?? this.picture,
    isPosting: isPosting ?? this.isPosting,
  );
}
