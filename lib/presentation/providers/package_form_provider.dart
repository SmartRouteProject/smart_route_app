import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/map_provider.dart';

final packageFormProvider =
    StateNotifierProvider.autoDispose<PackageFormNotifier, PackageFormState>((
      ref,
    ) {
      return PackageFormNotifier(ref: ref);
    });

class PackageFormNotifier extends StateNotifier<PackageFormState> {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  PackageFormNotifier({required Ref ref})
    : _ref = ref,
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

    final added = _ref
        .read(mapProvider.notifier)
        .addPackageToSelectedStop(package);

    state = state.copyWith(isPosting: false);
    return added;
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
