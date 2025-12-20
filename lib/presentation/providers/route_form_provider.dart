import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/infrastructure/inputs/inputs.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';

final routeFormProvider =
    StateNotifierProvider.autoDispose<RouteNotifier, RouteFormState>((ref) {
      final routeRepository = RouteRepositoryImpl();

      return RouteNotifier(routeRepository: routeRepository, ref: ref);
    });

class RouteNotifier extends StateNotifier<RouteFormState> {
  final IRouteRepository routeRepository;
  final Ref<RouteFormState> ref;

  RouteNotifier({required this.routeRepository, required this.ref})
    : super(RouteFormState());

  Future<bool> onFormSubmit() async {
    try {
      _touchEveryField();

      if (!state.isValid) return false;

      state = state.copyWith(isPosting: true);

      await _createRoute();

      state = state.copyWith(isPosting: false);

      return true;
    } catch (err) {
      state = state.copyWith(isPosting: false);
      return false;
    }
  }

  onNameChange(String value) {
    state = state.copyWith(name: value, isValid: Formz.validate([state.date]));
  }

  onDateChanged(DateTime value) {
    final newDate = RouteDate.dirty(value);
    state = state.copyWith(date: newDate, isValid: Formz.validate([newDate]));
  }

  onReturnAddressChanged(ReturnAddress? value) {
    state = state.copyWith(
      returnAddress: value,
      clearReturnAddress: value == null,
      isValid: Formz.validate([state.date]),
    );
  }

  _touchEveryField() {
    final date = RouteDate.dirty(state.date.value);

    state = state.copyWith(
      isFormPosted: true,
      date: date,
      isValid: Formz.validate([date]),
    );
  }

  Future<void> _createRoute() async {
    try {
      final route = CreateRouteDto(
        name: state.name,
        date: state.date.value,
        returnAddress: state.returnAddress,
      );

      final routeResult = await routeRepository.createRoute(route);

      if (routeResult != null) {
        final currentUser = ref.read(authProvider).user;
        if (currentUser != null) {
          final updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            password: currentUser.password,
            name: currentUser.name,
            lastName: currentUser.lastName,
            returnAddresses: currentUser.returnAddresses,
            routes: [...currentUser.routes, routeResult],
            profilePicture: currentUser.profilePicture,
          );
          ref.read(authProvider.notifier).updateUser(updatedUser);
        }
      }
    } catch (err) {
      rethrow;
    }
  }
}

class RouteFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String name;
  final RouteDate date;
  final ReturnAddress? returnAddress;

  RouteFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = "",
    RouteDate? date,
    this.returnAddress,
  }) : date = date ?? RouteDate.dirty(DateTime.now());

  RouteFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    String? name,
    RouteDate? date,
    ReturnAddress? returnAddress,
    bool clearReturnAddress = false,
  }) => RouteFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    name: name ?? this.name,
    date: date ?? this.date,
    returnAddress: clearReturnAddress
        ? null
        : returnAddress ?? this.returnAddress,
  );
}
