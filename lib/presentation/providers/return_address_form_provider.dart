import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';

final returnAddressFormProvider =
    StateNotifierProvider.autoDispose<
      ReturnAddressFormNotifier,
      ReturnAddressFormState
    >((ref) {
      final userRepository = UserRepositoryImpl();
      return ReturnAddressFormNotifier(
        ref: ref,
        userRepository: userRepository,
      );
    });

class ReturnAddressFormNotifier extends StateNotifier<ReturnAddressFormState> {
  final Ref _ref;
  final IUserRepository _userRepository;

  ReturnAddressFormNotifier({
    required Ref ref,
    required IUserRepository userRepository,
  }) : _ref = ref,
       _userRepository = userRepository,
       super(ReturnAddressFormState());

  void onNicknameChanged(String value) {
    state = state.copyWith(
      nickname: value,
      isValid: _isValid(nickname: value),
    );
  }

  void onAddressSelected(AddressSearch result) {
    state = state.copyWith(
      address: result.formattedAddress,
      latitude: result.latitude,
      longitude: result.longitude,
      isValid: _isValid(address: result.formattedAddress),
    );
  }

  Future<bool> onFormSubmit() async {
    if (state.isPosting) return false;
    _touchEveryField();
    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);
    final saved = await _saveReturnAddress();
    state = state.copyWith(isPosting: false);
    return saved;
  }

  void _touchEveryField() {
    state = state.copyWith(isFormPosted: true, isValid: _isValid());
  }

  bool _isValid({String? address, String? nickname}) {
    final addressValue = address ?? state.address;
    final nicknameValue = nickname ?? state.nickname;
    return addressValue.trim().isNotEmpty && nicknameValue.trim().isNotEmpty;
  }

  Future<bool> _saveReturnAddress() async {
    final currentUser = _ref.read(authProvider).user;
    if (currentUser == null) return false;

    final newAddress = ReturnAddress(
      nickname: state.nickname.trim(),
      latitude: state.latitude,
      longitude: state.longitude,
      address: state.address.trim(),
    );

    final updatedUser = currentUser.copyWith(
      returnAddresses: [...currentUser.returnAddresses, newAddress],
    );

    // final savedUser = await _userRepository.editUser(updatedUser);
    _ref.read(authProvider.notifier).updateUser(updatedUser);
    return true;
  }
}

class ReturnAddressFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String address;
  final double latitude;
  final double longitude;
  final String nickname;

  ReturnAddressFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
    this.nickname = '',
  });

  String? get addressErrorMessage {
    if (!isFormPosted) return null;
    if (address.trim().isEmpty) return 'El campo es requerido';
    return null;
  }

  String? get nicknameErrorMessage {
    if (!isFormPosted) return null;
    if (nickname.trim().isEmpty) return 'El campo es requerido';
    return null;
  }

  ReturnAddressFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    String? address,
    double? latitude,
    double? longitude,
    String? nickname,
  }) => ReturnAddressFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    nickname: nickname ?? this.nickname,
  );
}
