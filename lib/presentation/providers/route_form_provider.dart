import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/inputs/inputs.dart';

final routeFormProvider = StateNotifierProvider<RouteNotifier, RouteFormState>((
  ref,
) {
  return RouteNotifier();
});

class RouteNotifier extends StateNotifier<RouteFormState> {
  RouteNotifier() : super(RouteFormState());

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

  Future<bool> onFormSubmit() async {
    try {
      _touchEveryField();

      if (!state.isValid) return false;

      state = state.copyWith(isPosting: true);

      state = state.copyWith(isPosting: false);

      return true;
    } catch (err) {
      state = state.copyWith(isPosting: false);
      return false;
    }
  }

  _touchEveryField() {
    final date = RouteDate.dirty(state.date.value);

    state = state.copyWith(
      isFormPosted: true,
      date: date,
      isValid: Formz.validate([date]),
    );
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
    returnAddress:
        clearReturnAddress ? null : returnAddress ?? this.returnAddress,
  );
}
