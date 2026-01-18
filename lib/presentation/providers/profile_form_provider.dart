import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/inputs/inputs.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';

final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
      final userRepository = UserRepositoryImpl();

      final user = ref.read(authProvider).user;

      final userName = UserName.dirty(user?.name ?? '');
      final userLastName = UserName.dirty(user?.lastName ?? '');

      final initialState = ProfileFormState(
        userName: userName,
        userLastName: userLastName,
        profilePicture: user?.profilePicture,
        isValid: Formz.validate([userName, userLastName]),
      );

      return ProfileFormNotifier(
        ref,
        initialState,
        userRepository: userRepository,
      );
    });

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  final IUserRepository userRepository;
  final Ref<ProfileFormState> _ref;

  ProfileFormNotifier(
    this._ref,
    super.initialState, {
    required this.userRepository,
  });

  final ImagePicker _picker = ImagePicker();

  Future<bool> onFormSubmit() async {
    try {
      _touchEveryField();

      if (!state.isValid) return false;

      state = state.copyWith(isPosting: true, errorMessage: '');

      await _updateAuthUser();

      state = state.copyWith(isPosting: false, errorMessage: '');

      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(isPosting: false, errorMessage: err.message);
      return false;
    } catch (err) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'No se pudo actualizar el perfil',
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }

  onUserNameChange(String value) {
    final newUserName = UserName.dirty(value);
    state = state.copyWith(
      userName: newUserName,
      isValid: Formz.validate([newUserName, state.userLastName]),
    );
  }

  onUserLastnameChange(String value) {
    final newUserLastname = UserName.dirty(value);
    state = state.copyWith(
      userLastName: newUserLastname,
      isValid: Formz.validate([state.userName, newUserLastname]),
    );
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      state = state.copyWith(profilePicture: File(picked.path));
    }
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked != null) {
      state = state.copyWith(profilePicture: File(picked.path));
    }
  }

  void clearImage() {
    state = state = state.copyWith(profilePicture: null);
  }

  _touchEveryField() {
    final userName = UserName.dirty(state.userName.value);
    final userLastName = UserName.dirty(state.userLastName.value);

    state = state.copyWith(
      isFormPosted: true,
      userName: userName,
      userLastName: userLastName,
      isValid: Formz.validate([userName, userLastName]),
    );
  }

  Future<void> _updateAuthUser() async {
    try {
      final currentUser = _ref.read(authProvider).user;
      if (currentUser == null) return;

      final updatedUser = User(
        id: currentUser.id,
        email: currentUser.email,
        password: currentUser.password,
        name: state.userName.value,
        lastName: state.userLastName.value,
        profilePicture: state.profilePicture ?? currentUser.profilePicture,
        returnAddresses: currentUser.returnAddresses,
        routes: currentUser.routes,
      );

      final savedUser = await userRepository.editUser(updatedUser);

      _ref.read(authProvider.notifier).updateUser(savedUser);
    } catch (err) {
      rethrow;
    }
  }
}

class ProfileFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final UserName userName;
  final UserName userLastName;
  final File? profilePicture;
  final String errorMessage;

  ProfileFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.userName = const UserName.pure(),
    this.userLastName = const UserName.pure(),
    this.profilePicture,
    this.errorMessage = '',
  });

  ProfileFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    UserName? userName,
    UserName? userLastName,
    File? profilePicture,
    String? errorMessage,
  }) => ProfileFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    userName: userName ?? this.userName,
    userLastName: userLastName ?? this.userLastName,
    profilePicture: profilePicture ?? this.profilePicture,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
