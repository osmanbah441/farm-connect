import 'package:meta/meta.dart';

import 'form_fields_base.dart';

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
final usernameRegex = RegExp(
  r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
);

final class FirstName extends FormInput<String, FirstNameValidationError> {
  const FirstName.unvalidated([String value = '']) : super.unvalidated(value);

  const FirstName.validated(String value) : super.validated(value);

  @override
  FirstNameValidationError? validator(String value) {
    if (value.isEmpty) return FirstNameValidationError.empty;
    if (value.length < 3 || value.length > 20) {
      return FirstNameValidationError.length;
    }
    if (!usernameRegex.hasMatch(value)) return FirstNameValidationError.invalid;
    return null;
  }
}

enum FirstNameValidationError {
  invalid,
  empty,
  length,
}

final class LastName extends FormInput<String, FirstNameValidationError> {
  const LastName.unvalidated([String value = '']) : super.unvalidated(value);

  const LastName.validated(String value) : super.validated(value);

  @override
  FirstNameValidationError? validator(String value) {
    if (value.isEmpty) return FirstNameValidationError.empty;
    if (value.length < 3 || value.length > 20) {
      return FirstNameValidationError.length;
    }
    if (!usernameRegex.hasMatch(value)) return FirstNameValidationError.invalid;
    return null;
  }
}

enum LastNameValidationError {
  invalid,
  empty,
  length,
}
