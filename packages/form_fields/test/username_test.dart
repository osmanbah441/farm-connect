import 'package:form_fields/form_fields.dart' show usernameRegex;
import 'package:test/test.dart';

void main() {
  final regex = usernameRegex;
  test('valid usernames', () {
    expect(
      regex.hasMatch('username'),
      isTrue,
    );

    expect(
      regex.hasMatch('username123'),
      isTrue,
    );

    expect(
      regex.hasMatch('user_name'),
      isTrue,
    );

    expect(
      regex.hasMatch('user123_name'),
      isTrue,
    );

    expect(
      regex.hasMatch('U123'),
      isTrue,
    );
  });

  test('invalid usernames', () {
    expect(
      regex.hasMatch('user.name'),
      isFalse,
      reason: 'contains dots',
    );

    expect(
      regex.hasMatch('user_name_'),
      isFalse,
      reason: 'ends with an underscore',
    );

    expect(
      regex.hasMatch('_username'),
      isFalse,
      reason: 'starts with an underscore',
    );

    expect(
      regex.hasMatch('user name'),
      isFalse,
      reason: 'contains whitespace',
    );

    expect(
      regex.hasMatch('user-name'),
      isFalse,
      reason: 'contains a hyphen',
    );

    expect(
      regex.hasMatch('user!name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user@name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user#name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch(r'user$name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user%name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user^name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user&name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user*name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user(name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user)name'),
      isFalse,
      reason: 'contains invalid character',
    );

    expect(
      regex.hasMatch('user_name1234567890123456'),
      isFalse,
      reason: 'more than 20 characters',
    );
  });
}
