import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/stop_form_provider.dart';

class PackageFormArgs {
  final Stop stop;
  final Package? initialPackage;
  final int? packageIndex;

  const PackageFormArgs({
    required this.stop,
    this.initialPackage,
    this.packageIndex,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PackageFormArgs &&
        other.stop == stop &&
        other.initialPackage == initialPackage &&
        other.packageIndex == packageIndex;
  }

  @override
  int get hashCode => Object.hash(stop, initialPackage, packageIndex);
}

final packageFormProvider = StateNotifierProvider.autoDispose
    .family<PackageFormNotifier, PackageFormState, PackageFormArgs>((
      ref,
      args,
    ) {
      return PackageFormNotifier(ref: ref, args: args);
    });

class PackageFormNotifier extends StateNotifier<PackageFormState> {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();
  final Stop _stop;
  final int? _editingIndex;

  PackageFormNotifier({required Ref ref, required PackageFormArgs args})
    : _ref = ref,
      _stop = args.stop,
      _editingIndex = args.packageIndex,
      super(
        PackageFormState(
          description: args.initialPackage?.description ?? '',
          weight: args.initialPackage?.weight ?? PackageWeightType.under_25kg,
          picture: args.initialPackage?.picture,
        ),
      );

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
    state = state.copyWith(isPosting: true, errorMessage: '');

    try {
      final package = Package(
        description: state.description.trim(),
        weight: state.weight,
        picture: state.picture,
      );

      final stopForm = _ref.read(stopFormProvider(_stop).notifier);
      if (_editingIndex != null) {
        stopForm.updatePackage(_editingIndex, package);
      } else {
        stopForm.addPackage(package);
      }

      state = state.copyWith(isPosting: false, errorMessage: '');
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(isPosting: false, errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'No se pudo guardar el paquete',
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }
}

class PackageFormState {
  final String description;
  final PackageWeightType weight;
  final File? picture;
  final bool isPosting;
  final String errorMessage;

  PackageFormState({
    this.description = '',
    this.weight = PackageWeightType.under_25kg,
    this.picture,
    this.isPosting = false,
    this.errorMessage = '',
  });

  PackageFormState copyWith({
    String? description,
    PackageWeightType? weight,
    File? picture,
    bool? isPosting,
    String? errorMessage,
  }) => PackageFormState(
    description: description ?? this.description,
    weight: weight ?? this.weight,
    picture: picture ?? this.picture,
    isPosting: isPosting ?? this.isPosting,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
