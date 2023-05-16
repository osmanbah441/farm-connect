import 'package:meta/meta.dart';

import 'form_fields_base.dart';

final class Email extends FormInput<String, EmailValidationError> {
  const Email.unvalidated([String value = ''])
      : isAlreadyRegistered = false,
        super.unvalidated(value);

  const Email.validated(String value, {this.isAlreadyRegistered = false})
      : super.validated(value);

// This is a regular expression used to validate an email address. It matches the
// standard email format of "username@domain.com". Here's a breakdown of the different
// parts of the regular expression:

// - `^` matches the start of the string

// - `(` marks the start of a group

// - `([\\w-]+\\.)+` matches one or more groups of one or more word characters
//     (alphanumeric or underscore) or hyphens, followed by a dot. This matches the
//     subdomain(s) of the email address, such as "mail.google." in "mail.google.com".

// - `[\\w-]+` matches one or more word characters or hyphens. This matches the domain
//  name, such as "google" in "mail.google.com".

// - `|` separates the first part of the regex from the second part

// - `([a-zA-Z]|[\\w-]{2,})` matches either one alphabetic character or two
// or more word characters or hyphens. This matches domain names that are not split into
//  subdomains, such as "gmail" in "gmail.com".

// - `)` marks the end of the first group

// - `@` matches the "@" symbol

// - `(` marks the start of a group for the domain name

// - `(` starts another group, which matches IP addresses in square brackets [ ].

// - `([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.` matches each of the 4 parts
// of an IP address (separated by periods), with values between 0-255. The `?` after `[0-1]`
// makes the first digit optional, allowing for 1-digit numbers like "7" and "17".

// - `)` ends the IP address group

// - `|` separates the IP address group from the domain name group

// - `([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4}` matches domain names that consist of
// one or more groups of one or more alphabetic characters followed by one or more word
// characters or hyphens and a dot, ending with two to four alphabetic characters.
// This matches most common domain names like "google.com".

// - `)` marks the end of the domain name group

// - `$` matches the end of the string

// Overall, this regular expression is useful for validating email addresses,
// which can be useful in many web applications and forms.

  @visibleForTesting
  static final emailRegex = RegExp(
    '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
    '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
    '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$',
  );

  final bool isAlreadyRegistered;

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!emailRegex.hasMatch(value)) return EmailValidationError.invalid;
    if (isAlreadyRegistered) return EmailValidationError.alreadyRegistered;
    return null;
  }
}

enum EmailValidationError {
  invalid,
  empty,
  alreadyRegistered,
}
