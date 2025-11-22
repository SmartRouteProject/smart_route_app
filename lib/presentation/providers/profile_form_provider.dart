import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final profileFormProvider = StateNotifierProvider<ProfileFormNotifier, File?>(
  (ref) => ProfileFormNotifier(),
);

class ProfileFormNotifier extends StateNotifier<File?> {
  ProfileFormNotifier() : super(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) state = File(picked.path);
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked != null) state = File(picked.path);
  }

  void clearImage() {
    state = null;
  }
}
