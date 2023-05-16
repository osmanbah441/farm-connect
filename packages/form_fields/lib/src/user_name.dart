import 'package:meta/meta.dart';

import 'form_fields_base.dart';

final class Username extends FormInput<String, UsernameValidationError> {
  const Username.unvalidated([String value = '']) : super.unvalidated(value);

  const Username.validated(String value) : super.validated(value);

  // This regular expression is a pattern that can be used to validate a string to ensure it
// meets certain criteria. Specifically, it checks that the string:

// contains between 1 and 20 characters (inclusive)
// does not start with an underscore character
// does not contain two consecutive underscore or dot characters
// contains only alphanumeric characters or underscores
// Here is a breakdown of the different parts of the regular expression:

// ^ matches the start of the string

// (?=.{1,20}$) is a positive lookahead assertion that checks the length of the string,
// ensuring it has between 1 and 20 characters

// (?![_]) is a negative lookahead assertion that ensures the string does not start with an underscore

// (?!.*[_.]{2}) is a negative lookahead assertion that checks if the string does
// not contain two consecutive underscore or dot characters

// [a-zA-Z0-9_]+ matches one or more alphanumeric characters or underscores

// (?<![_])$ is a negative lookbehind assertion that ensures the string does not end with an
// underscore, followed by the end of the string anchor $.

// Overall, this regular expression is useful for validating input in various scenarios
// such as user account creation or password validation, where a string needs to meet specific
// criteria to be considered valid.
  @visibleForTesting
  static final usernameRegex = RegExp(
    r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
  );

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (value.length < 3 || value.length > 20) {
      return UsernameValidationError.length;
    }
    if (!usernameRegex.hasMatch(value)) return UsernameValidationError.invalid;
    return null;
  }
}

enum UsernameValidationError {
  invalid,
  empty,
  length,
}
