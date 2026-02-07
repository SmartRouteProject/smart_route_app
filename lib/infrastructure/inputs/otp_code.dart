import 'package:formz/formz.dart';

enum OtpCodeError { empty, length, format }

class OtpCode extends FormzInput<String, OtpCodeError> {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  const OtpCode.pure() : super.pure('');
  const OtpCode.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == OtpCodeError.empty) return 'El codigo es requerido';
    if (displayError == OtpCodeError.length) {
      return 'El codigo debe tener 6 digitos';
    }
    if (displayError == OtpCodeError.format) {
      return 'El codigo solo puede contener numeros';
    }

    return null;
  }

  @override
  OtpCodeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return OtpCodeError.empty;
    if (!_digitsOnly.hasMatch(value)) return OtpCodeError.format;
    if (value.length != 6) return OtpCodeError.length;

    return null;
  }
}
