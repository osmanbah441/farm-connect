import 'form_fields_base.dart';
import 'password.dart';

final class ComfirmationPassword
    extends FormInput<String, ComfirmationPasswordValidationError> {
  const ComfirmationPassword.unvalidated([String value = ''])
      : password = const Password.unvalidated(),
        super.unvalidated(value);

  const ComfirmationPassword.validated(String value, this.password)
      : super.validated(value);

  final Password password;

  @override
  ComfirmationPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ComfirmationPasswordValidationError.empty;
    if (value != password.value) {
      return ComfirmationPasswordValidationError.notMatch;
    }
    return null;
  }
}

enum ComfirmationPasswordValidationError {
  empty,
  notMatch,
}
