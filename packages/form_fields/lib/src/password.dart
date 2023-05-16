import 'package:meta/meta.dart';

import 'form_fields_base.dart';

final class Password extends FormInput<String, PasswordValidationError> {
  const Password.unvalidated([String value = '']) : super.unvalidated(value);

  const Password.validated([String value = '']) : super.validated(value);

// This regular expression matches passwords that meet the following criteria:

// - At least one uppercase letter (`(?=.*?[A-Z])`)
// - At least one lowercase letter (`(?=.*?[a-z])`)
// - At least one digit (`(?=.*?[0-9])`)
// - At least one special character (`(?=.*?[!@#\$&*~])`)
// - At least 8 characters in length and 20 character long (`.{8,20}`)

  @visibleForTesting
  static final passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.short;
    if (!passwordRegex.hasMatch(value)) return PasswordValidationError.invalid;
    return null;
  }
}

enum PasswordValidationError {
  empty,
  invalid,
  short;
}
