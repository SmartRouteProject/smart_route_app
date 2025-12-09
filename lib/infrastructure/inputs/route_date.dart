import 'package:formz/formz.dart';

// Define input validation errors
enum RouteDateError { beforeToday }

// Extend FormzInput and provide the input type and error type.
class RouteDate extends FormzInput<DateTime, RouteDateError> {
  // Call super.pure to represent an unmodified form input.
  RouteDate.pure() : super.pure(DateTime.now());

  // Call super.dirty to represent a modified form input.
  const RouteDate.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RouteDateError.beforeToday) {
      return 'La fecha debe ser hoy o posterior';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RouteDateError? validator(DateTime value) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);

    if (selectedDate.isBefore(today)) return RouteDateError.beforeToday;

    return null;
  }
}
